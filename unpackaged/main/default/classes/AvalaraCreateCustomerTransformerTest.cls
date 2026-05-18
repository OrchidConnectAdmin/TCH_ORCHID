/**
 * Test class for AvalaraCreateCustomerTransformer.
 * Covers: request serialization (all fields, optional fields, array wrapping),
 * response deserialization (customer data), and edge cases.
 */
@isTest
private class AvalaraCreateCustomerTransformerTest {

    // ─── transformRequest Tests ───

    @isTest
    static void transformRequestSerializesAllFieldsTest() {
        AvalaraCreateCustomer.Request customerRequest = buildCustomerRequest();

        Test.startTest();
        String jsonResult = AvalaraCreateCustomerTransformer.transformRequest(customerRequest);
        Test.stopTest();

        List<Object> parsedList = (List<Object>) JSON.deserializeUntyped(jsonResult);
        System.assertEquals(1, parsedList.size(), 'Should be wrapped in an array with one element');

        Map<String, Object> parsed = (Map<String, Object>) parsedList[0];
        System.assertEquals('CUST-001', parsed.get('customerCode'), 'customerCode should be serialized');
        System.assertEquals('Test Customer', parsed.get('name'), 'name should be serialized');
        System.assertEquals('350 Fifth Avenue', parsed.get('line1'), 'line1 should be serialized');
        System.assertEquals('New York', parsed.get('city'), 'city should be serialized');
        System.assertEquals('NY', parsed.get('region'), 'region should be serialized');
        System.assertEquals('10118', parsed.get('postalCode'), 'postalCode should be serialized');
        System.assertEquals('US', parsed.get('country'), 'country should be serialized');
        System.assertEquals('test@example.com', parsed.get('emailAddress'), 'emailAddress should be serialized');
    }

    @isTest
    static void transformRequestOmitsBlankFieldsTest() {
        AvalaraCreateCustomer.Request customerRequest = new AvalaraCreateCustomer.Request();
        customerRequest.customerCode = 'CUST-002';

        Test.startTest();
        String jsonResult = AvalaraCreateCustomerTransformer.transformRequest(customerRequest);
        Test.stopTest();

        List<Object> parsedList = (List<Object>) JSON.deserializeUntyped(jsonResult);
        Map<String, Object> parsed = (Map<String, Object>) parsedList[0];
        System.assertEquals('CUST-002', parsed.get('customerCode'), 'customerCode should be present');
        System.assertEquals(null, parsed.get('name'), 'blank name should be omitted');
        System.assertEquals(null, parsed.get('emailAddress'), 'blank emailAddress should be omitted');
    }

    @isTest
    static void transformRequestThrowsWhenNullTest() {
        Boolean exceptionWasThrown = false;

        Test.startTest();
        try {
            AvalaraCreateCustomerTransformer.transformRequest(null);
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('cannot be null'), 'Should indicate null request');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for null request');
    }

    // ─── transformResponse Tests ───

    @isTest
    static void transformResponseParsesCustomerDataTest() {
        String responseJson = buildCustomerResponseJson();

        Test.startTest();
        AvalaraCreateCustomer.Response response = AvalaraCreateCustomerTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(12345, response.id, 'id should be parsed');
        System.assertEquals('CUST-001', response.customerCode, 'customerCode should be parsed');
        System.assertEquals('Test Customer', response.name, 'name should be parsed');
        System.assertEquals('test@example.com', response.emailAddress, 'emailAddress should be parsed');
        System.assertEquals('NY', response.region, 'region should be parsed');
    }

    @isTest
    static void transformResponseThrowsWhenBlankTest() {
        Boolean exceptionWasThrown = false;

        Test.startTest();
        try {
            AvalaraCreateCustomerTransformer.transformResponse('');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('blank'), 'Should indicate blank response');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for blank response');
    }

    @isTest
    static void transformResponseThrowsWhenEmptyArrayTest() {
        Boolean exceptionWasThrown = false;

        Test.startTest();
        try {
            AvalaraCreateCustomerTransformer.transformResponse('[]');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('empty array'), 'Should indicate empty array');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for empty array');
    }

    // ─── Test Data Helpers ───

    private static AvalaraCreateCustomer.Request buildCustomerRequest() {
        AvalaraCreateCustomer.Request customerRequest = new AvalaraCreateCustomer.Request();
        customerRequest.customerCode = 'CUST-001';
        customerRequest.name = 'Test Customer';
        customerRequest.line1 = '350 Fifth Avenue';
        customerRequest.city = 'New York';
        customerRequest.region = 'NY';
        customerRequest.postalCode = '10118';
        customerRequest.country = 'US';
        customerRequest.emailAddress = 'test@example.com';
        return customerRequest;
    }

    private static String buildCustomerResponseJson() {
        return '[{'
            + '"id":12345,'
            + '"customerCode":"CUST-001",'
            + '"name":"Test Customer",'
            + '"emailAddress":"test@example.com",'
            + '"line1":"350 Fifth Avenue",'
            + '"city":"New York",'
            + '"region":"NY",'
            + '"postalCode":"10118",'
            + '"country":"US"'
            + '}]';
    }
}
