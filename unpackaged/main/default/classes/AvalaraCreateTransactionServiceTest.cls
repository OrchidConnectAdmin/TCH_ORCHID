/**
 * Test class for AvalaraCreateTransactionService.
 * Covers: end-to-end tax calculation flow with HttpCalloutMock for
 * SalesOrder estimate, multi-line, and exempt customer scenarios.
 */
@isTest
private class AvalaraCreateTransactionServiceTest {

    // ─── Mock Implementations ───

    /**
     * Mock that returns a successful SalesOrder response with tax calculated.
     */
    private class SalesOrderSuccessMock implements HttpCalloutMock {
        /** Responds with a 200/201 and a SalesOrder with tax. */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"id":123456789,"code":"TX-001","status":"Temporary","type":"SalesOrder",'
                + '"totalTax":6.00,"totalTaxable":100.00,"totalAmount":100.00,"totalExempt":0,"totalDiscount":0,'
                + '"lines":[{"lineNumber":"1","tax":6.00,"taxableAmount":100.00,"taxCalculated":6.00,"lineAmount":100.00,"rate":0.06,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
                + '}');
            return response;
        }
    }

    /**
     * Mock that returns a SalesInvoice response with Saved status.
     */
    private class SalesInvoiceSavedMock implements HttpCalloutMock {
        /** Responds with a 200/201 and a SalesInvoice in Saved status. */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"id":987654321,"code":"INV-001","status":"Saved","type":"SalesInvoice",'
                + '"totalTax":44.38,"totalTaxable":500.00,"totalAmount":500.00,"totalExempt":0,"totalDiscount":0,'
                + '"lines":[{"lineNumber":"1","tax":44.38,"taxableAmount":500.00,"taxCalculated":44.38,"lineAmount":500.00,"rate":0.08875,"itemCode":"LIFECYCLE-TEST","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
                + '}');
            return response;
        }
    }

    /**
     * Mock that returns an exempt customer response with zero tax.
     */
    private class ExemptCustomerMock implements HttpCalloutMock {
        /** Responds with a 200 and zero tax for exempt customer. */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"id":111222333,"code":"EX-001","status":"Temporary","type":"SalesOrder",'
                + '"totalTax":0,"totalTaxable":0,"totalAmount":100.00,"totalExempt":100.00,"totalDiscount":0,'
                + '"lines":[{"lineNumber":"1","tax":0,"taxableAmount":0,"taxCalculated":0,"lineAmount":100.00,"rate":0,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
                + '}');
            return response;
        }
    }

    // ─── execute Tests ───

    /**
     * Verifies that execute returns calculated tax for a SalesOrder estimate.
     */
    @isTest
    static void executeWithSalesOrderReturnsTaxTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new SalesOrderSuccessMock());

        AvalaraCreateTransaction.Request transactionRequest = buildSalesOrderRequest();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionService.execute(transactionRequest);
        Test.stopTest();

        System.assertEquals('Temporary', response.status, 'SalesOrder should have Temporary status');
        System.assertEquals(6.00, response.totalTax, 'totalTax should be calculated');
        System.assertEquals(1, response.lines.size(), 'Should have one line');
        System.assertEquals(6.00, response.lines[0].tax, 'Line tax should be calculated');
    }

    /**
     * Verifies that execute returns Saved status for a SalesInvoice.
     */
    @isTest
    static void executeWithSalesInvoiceReturnsSavedStatusTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new SalesInvoiceSavedMock());

        AvalaraCreateTransaction.Request transactionRequest = buildSalesInvoiceRequest();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionService.execute(transactionRequest);
        Test.stopTest();

        System.assertEquals('Saved', response.status, 'SalesInvoice should have Saved status');
        System.assertNotEquals(null, response.code, 'Transaction code should be present for commit/void');
        System.assertEquals(44.38, response.totalTax, 'totalTax should be calculated');
    }

    /**
     * Verifies that execute returns zero tax for an exempt customer.
     */
    @isTest
    static void executeWithExemptCustomerReturnsZeroTaxTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new ExemptCustomerMock());

        AvalaraCreateTransaction.Request transactionRequest = buildExemptCustomerRequest();

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraCreateTransactionService.execute(transactionRequest);
        Test.stopTest();

        System.assertEquals(0, response.totalTax, 'totalTax should be zero for exempt customer');
        System.assertEquals(100.00, response.totalExempt, 'totalExempt should be the full amount');
    }

    // ─── Test Data Helpers ───

    /**
     * Builds a SalesOrder request with one line item.
     * @return populated Request
     */
    private static AvalaraCreateTransaction.Request buildSalesOrderRequest() {
        return buildBaseRequest('SalesOrder', 'CUST-001', null);
    }

    /**
     * Builds a SalesInvoice request with one line item and commit=false.
     * @return populated Request
     */
    private static AvalaraCreateTransaction.Request buildSalesInvoiceRequest() {
        AvalaraCreateTransaction.Request transactionRequest = buildBaseRequest('SalesInvoice', 'CUST-001', null);
        transactionRequest.commitTransaction = false;
        return transactionRequest;
    }

    /**
     * Builds an exempt customer SalesOrder request.
     * @return populated Request with customerUsageType='A'
     */
    private static AvalaraCreateTransaction.Request buildExemptCustomerRequest() {
        return buildBaseRequest('SalesOrder', 'EXEMPT-001', 'A');
    }

    /**
     * Builds a base transaction request with configurable type, customer, and exemption.
     * @param documentType the document type (SalesOrder or SalesInvoice)
     * @param customerCode the customer identifier
     * @param customerUsageType the exemption code (null if not exempt)
     * @return populated Request
     */
    private static AvalaraCreateTransaction.Request buildBaseRequest(String documentType, String customerCode, String customerUsageType) {
        AvalaraCreateTransaction.Request transactionRequest = new AvalaraCreateTransaction.Request();
        transactionRequest.companyCode = 'DEFAULT';
        transactionRequest.type = documentType;
        transactionRequest.transactionDate = '2026-05-12';
        transactionRequest.customerCode = customerCode;
        transactionRequest.customerUsageType = customerUsageType;

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
}
