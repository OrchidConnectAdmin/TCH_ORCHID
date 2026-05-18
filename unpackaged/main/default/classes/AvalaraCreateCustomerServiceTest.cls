/**
 * Test class for AvalaraCreateCustomerService.
 * Covers: end-to-end customer registration flow with HttpCalloutMock.
 */
@isTest
private class AvalaraCreateCustomerServiceTest {

    // ─── Mock Implementations ───

    private class CreateCustomerSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('[{'
                + '"id":12345,'
                + '"customerCode":"CUST-001",'
                + '"name":"Test Customer",'
                + '"emailAddress":"test@example.com",'
                + '"line1":"350 Fifth Avenue",'
                + '"city":"New York",'
                + '"region":"NY",'
                + '"postalCode":"10118",'
                + '"country":"US"'
                + '}]');
            return response;
        }
    }

    // ─── execute Tests ───

    @isTest
    static void executeCreatesCustomerSuccessfullyTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new CreateCustomerSuccessMock());

        AvalaraCreateCustomer.Request customerRequest = buildCustomerRequest();

        Test.startTest();
        AvalaraCreateCustomer.Response response = AvalaraCreateCustomerService.execute(customerRequest, '999999');
        Test.stopTest();

        System.assertEquals(12345, response.id, 'Customer ID should be returned');
        System.assertEquals('CUST-001', response.customerCode, 'customerCode should be echoed back');
        System.assertEquals('Test Customer', response.name, 'name should be echoed back');
        System.assertEquals('test@example.com', response.emailAddress, 'emailAddress should be echoed back');
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
}
