/**
 * Test class for AvalaraCreateTransactionTransformer.
 * Covers: request serialization (all fields, optional fields, lines, addresses),
 * response deserialization (totals, lines, tax details, exempt), and edge cases.
 */
@isTest
private class AvalaraCreateTransactionTransformerTest {

    // ─── transformRequest Tests ───

    /**
     * Verifies that transformRequest serializes all required fields and addresses.
     */
    @isTest
    static void transformRequestSerializesAllFieldsTest() {
        AvalaraCreateTransaction.Request transactionRequest = buildSalesOrderRequest();

        Test.startTest();
        String jsonResult = AvalaraCreateTransactionTransformer.transformRequest(transactionRequest);
        Test.stopTest();

        Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        System.assertEquals('DEFAULT', parsed.get('companyCode'), 'companyCode should be serialized');
        System.assertEquals('SalesOrder', parsed.get('type'), 'type should be serialized');
        System.assertEquals('CUST-001', parsed.get('customerCode'), 'customerCode should be serialized');
        System.assertNotEquals(null, parsed.get('addresses'), 'addresses should be present');
        System.assertNotEquals(null, parsed.get('lines'), 'lines should be present');
    }

    /**
     * Verifies that transformRequest serializes line items with correct field names.
     */
    @isTest
    static void transformRequestSerializesLineItemsTest() {
        AvalaraCreateTransaction.Request transactionRequest = buildSalesOrderRequest();

        Test.startTest();
        String jsonResult = AvalaraCreateTransactionTransformer.transformRequest(transactionRequest);
        Test.stopTest();

        Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        List<Object> lines = (List<Object>) parsed.get('lines');
        System.assertEquals(1, lines.size(), 'Should have one line');

        Map<String, Object> firstLine = (Map<String, Object>) lines[0];
        System.assertEquals('1', firstLine.get('number'), 'number should be serialized');
        System.assertEquals('P0000000', firstLine.get('taxCode'), 'taxCode should be serialized');
        System.assertEquals(100.00, firstLine.get('amount'), 'amount should be serialized');
    }

    /**
     * Verifies that transformRequest serializes shipFrom and shipTo addresses.
     */
    @isTest
    static void transformRequestSerializesAddressesTest() {
        AvalaraCreateTransaction.Request transactionRequest = buildSalesOrderRequest();

        Test.startTest();
        String jsonResult = AvalaraCreateTransactionTransformer.transformRequest(transactionRequest);
        Test.stopTest();

        Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        Map<String, Object> addresses = (Map<String, Object>) parsed.get('addresses');
        Map<String, Object> shipFrom = (Map<String, Object>) addresses.get('shipFrom');
        Map<String, Object> shipTo = (Map<String, Object>) addresses.get('shipTo');

        System.assertEquals('CA', shipFrom.get('region'), 'shipFrom region should be CA');
        System.assertEquals('DC', shipTo.get('region'), 'shipTo region should be DC');
    }

    /**
     * Verifies that transformRequest includes commit and exemption fields when set.
     */
    @isTest
    static void transformRequestIncludesOptionalFieldsTest() {
        AvalaraCreateTransaction.Request transactionRequest = buildSalesOrderRequest();
        transactionRequest.commitTransaction = true;
        transactionRequest.exemptionNo = 'EX-12345';
        transactionRequest.customerUsageType = 'A';

        Test.startTest();
        String jsonResult = AvalaraCreateTransactionTransformer.transformRequest(transactionRequest);
        Test.stopTest();

        Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        System.assertEquals(true, parsed.get('commit'), 'commit should be true');
        System.assertEquals('EX-12345', parsed.get('exemptionNo'), 'exemptionNo should be serialized');
        System.assertEquals('A', parsed.get('customerUsageType'), 'customerUsageType should be serialized');
    }

    /**
     * Verifies that transformRequest throws when request is null.
     */
    @isTest
    static void transformRequestThrowsWhenNullTest() {
        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraCreateTransactionTransformer.transformRequest(null);
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('cannot be null'), 'Should indicate null request');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for null request');
    }

    // ─── transformResponse Tests ───

    /**
     * Verifies that transformResponse parses transaction totals and status.
     */
    @isTest
    static void transformResponseParsesTransactionTotalsTest() {
        String responseJson = buildSalesOrderResponseJson();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(6.00, response.totalTax, 'totalTax should be parsed');
        System.assertEquals(100.00, response.totalTaxable, 'totalTaxable should be parsed');
        System.assertEquals(100.00, response.totalAmount, 'totalAmount should be parsed');
        System.assertEquals('Temporary', response.status, 'status should be Temporary for SalesOrder');
    }

    /**
     * Verifies that transformResponse parses transaction code and ID.
     */
    @isTest
    static void transformResponseParsesTransactionIdentifiersTest() {
        String responseJson = buildSalesOrderResponseJson();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertNotEquals(null, response.code, 'code should be parsed');
        System.assertNotEquals(null, response.id, 'id should be parsed');
    }

    /**
     * Verifies that transformResponse parses line-level tax details.
     */
    @isTest
    static void transformResponseParsesLineTaxDetailsTest() {
        String responseJson = buildSalesOrderResponseJson();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(1, response.lines.size(), 'Should have one response line');

        AvalaraCreateTransaction.ResponseLine firstLine = response.lines[0];
        System.assertEquals(6.00, firstLine.tax, 'line tax should be parsed');
        System.assertEquals(100.00, firstLine.taxableAmount, 'taxableAmount should be parsed');
        System.assertEquals(100.00, firstLine.lineAmount, 'lineAmount should be parsed');
        System.assertEquals('P0000000', firstLine.taxCode, 'taxCode should be parsed');
    }

    /**
     * Verifies that transformResponse parses jurisdiction-level tax detail breakdown.
     */
    @isTest
    static void transformResponseParsesJurisdictionDetailsTest() {
        String responseJson = buildSalesOrderResponseJson();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionTransformer.transformResponse(responseJson);
        Test.stopTest();

        List<AvalaraCreateTransaction.TaxDetail> details = response.lines[0].details;
        System.assertEquals(1, details.size(), 'Should have one tax detail');
        System.assertEquals('DISTRICT OF COLUMBIA', details[0].jurisName, 'jurisName should be parsed');
        System.assertEquals('State', details[0].jurisType, 'jurisType should be parsed');
        System.assertEquals(6.00, details[0].tax, 'detail tax should be parsed');
    }

    /**
     * Verifies that transformResponse handles a multi-line response with NT line having zero tax.
     */
    @isTest
    static void transformResponseParsesMultiLineWithNonTaxableTest() {
        String responseJson = buildMultiLineResponseJson();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(3, response.lines.size(), 'Should have three response lines');

        AvalaraCreateTransaction.ResponseLine nonTaxableLine = response.lines[2];
        System.assertEquals(0, nonTaxableLine.tax, 'NT line should have zero tax');
        System.assertEquals('NT', nonTaxableLine.taxCode, 'taxCode should be NT');
    }

    /**
     * Verifies that transformResponse handles exempt customer with zero total tax.
     */
    @isTest
    static void transformResponseParsesExemptTransactionTest() {
        String responseJson = buildExemptResponseJson();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(0, response.totalTax, 'totalTax should be zero for exempt customer');
        System.assertEquals(100.00, response.totalExempt, 'totalExempt should be the full amount');
    }

    /**
     * Verifies that transformResponse throws when body is blank.
     */
    @isTest
    static void transformResponseThrowsWhenBlankTest() {
        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraCreateTransactionTransformer.transformResponse('');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('blank'), 'Should indicate blank response');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for blank response');
    }

    // ─── Test Data Helpers ───

    /**
     * Builds a basic SalesOrder request with one line item.
     * @return populated Request
     */
    private static AvalaraCreateTransaction.Request buildSalesOrderRequest() {
        AvalaraCreateTransaction.Request transactionRequest = new AvalaraCreateTransaction.Request();
        transactionRequest.companyCode = 'DEFAULT';
        transactionRequest.type = 'SalesOrder';
        transactionRequest.transactionDate = '2026-05-12';
        transactionRequest.customerCode = 'CUST-001';

        transactionRequest.shipFromAddress = buildAddress('123 Main Street', 'Irvine', 'CA', '92615', 'US');
        transactionRequest.shipToAddress = buildAddress('1600 Pennsylvania Avenue NW', 'Washington', 'DC', '20500', 'US');

        AvalaraCreateTransaction.LineItem lineItem = new AvalaraCreateTransaction.LineItem();
        lineItem.number_x = '1';
        lineItem.quantity = 1;
        lineItem.amount = 100.00;
        lineItem.taxCode = 'P0000000';
        lineItem.itemCode = 'ITEM-001';
        lineItem.description = 'Tangible personal property';

        transactionRequest.lineItems = new List<AvalaraCreateTransaction.LineItem>{ lineItem };
        return transactionRequest;
    }

    /**
     * Builds an Address with the specified fields.
     * @return populated Address
     */
    private static AvalaraCreateTransaction.Address buildAddress(String line1, String city, String region, String postalCode, String country) {
        AvalaraCreateTransaction.Address address = new AvalaraCreateTransaction.Address();
        address.line1 = line1;
        address.city = city;
        address.region = region;
        address.postalCode = postalCode;
        address.country = country;
        return address;
    }

    /**
     * Builds a SalesOrder response JSON with one taxable line.
     * @return JSON string matching real Avalara API output
     */
    private static String buildSalesOrderResponseJson() {
        return '{'
            + '"id":123456789,'
            + '"code":"TX-20260512-001",'
            + '"companyCode":"DEFAULT",'
            + '"date":"2026-05-12",'
            + '"status":"Temporary",'
            + '"type":"SalesOrder",'
            + '"customerVendorCode":"CUST-001",'
            + '"totalTax":6.00,'
            + '"totalTaxable":100.00,'
            + '"totalAmount":100.00,'
            + '"totalExempt":0,'
            + '"totalDiscount":0,'
            + '"lines":[{'
            + '"lineNumber":"1",'
            + '"tax":6.00,'
            + '"taxableAmount":100.00,'
            + '"taxCalculated":6.00,'
            + '"lineAmount":100.00,'
            + '"rate":0.06,'
            + '"itemCode":"ITEM-001",'
            + '"taxCode":"P0000000",'
            + '"isItemTaxable":true,'
            + '"details":[{"jurisName":"DISTRICT OF COLUMBIA","jurisType":"State","rate":0.06,"tax":6.00,"taxableAmount":100.00,"taxName":"DC SALES TAX"}]'
            + '}]'
            + '}';
    }

    /**
     * Builds a multi-line response JSON with taxable, SaaS, and non-taxable lines.
     * @return JSON string matching real Avalara API output
     */
    private static String buildMultiLineResponseJson() {
        return '{'
            + '"id":123456790,'
            + '"code":"TX-20260512-002",'
            + '"status":"Temporary",'
            + '"type":"SalesOrder",'
            + '"totalTax":26.62,'
            + '"totalTaxable":299.99,'
            + '"totalAmount":374.99,'
            + '"totalExempt":75.00,'
            + '"totalDiscount":0,'
            + '"lines":['
            + '{"lineNumber":"1","tax":22.19,"taxableAmount":250.00,"taxCalculated":22.19,"lineAmount":250.00,"rate":0.08875,"itemCode":"MEMBERSHIP-ANNUAL","taxCode":"P0000000","isItemTaxable":true,"details":[]},'
            + '{"lineNumber":"2","tax":4.43,"taxableAmount":49.99,"taxCalculated":4.43,"lineAmount":49.99,"rate":0.08875,"itemCode":"SOFTWARE-SUB","taxCode":"SW054000","isItemTaxable":true,"details":[]},'
            + '{"lineNumber":"3","tax":0,"taxableAmount":0,"taxCalculated":0,"lineAmount":75.00,"rate":0,"itemCode":"DONATION","taxCode":"NT","isItemTaxable":false,"details":[]}'
            + ']'
            + '}';
    }

    /**
     * Builds an exempt customer response JSON with zero tax.
     * @return JSON string matching real Avalara API output
     */
    private static String buildExemptResponseJson() {
        return '{'
            + '"id":123456791,'
            + '"code":"TX-20260512-003",'
            + '"status":"Temporary",'
            + '"type":"SalesOrder",'
            + '"totalTax":0,'
            + '"totalTaxable":0,'
            + '"totalAmount":100.00,'
            + '"totalExempt":100.00,'
            + '"totalDiscount":0,'
            + '"lines":[{"lineNumber":"1","tax":0,"taxableAmount":0,"taxCalculated":0,"lineAmount":100.00,"rate":0,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
            + '}';
    }
}
