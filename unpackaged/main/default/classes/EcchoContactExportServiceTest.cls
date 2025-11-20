@IsTest
private class EcchoContactExportServiceTest {

    @IsTest
    static void testEcchoContactExport_GetRequest() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact c1 = new Contact(
            FirstName = 'Test',
            LastName = 'User1',
            Email = 'test1@example.com',
            AccountId = acc.Id,
            Contact_is_Inactive__c = false,
            Corp_SF_Tag_Sponsoring_Organization__c = true
        );

        Contact c2 = new Contact(
            FirstName = 'Test',
            LastName = 'User2',
            Email = 'test2@example.com',
            AccountId = acc.Id,
            Contact_is_Inactive__c = false,
            Corp_SF_Tag_Associate_Member__c = true
        );

        insert new List<Contact>{ c1, c2 };

        // Re-query to retrieve LastModifiedDate
        List<Contact> reloaded = [
            SELECT Id, LastModifiedDate FROM Contact
            WHERE Email IN ('test1@example.com', 'test2@example.com')
            ORDER BY LastModifiedDate ASC
        ];

        Contact first = reloaded[0];

        // Simulate a REST request context with afterDate and afterId
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/ecchoContacts';
        req.httpMethod = 'GET';
        req.addParameter('pagesize', '100');
        req.addParameter('afterDate', first.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss'));
        req.addParameter('afterId', first.Id);

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        EcchoContactExportService.doGet();
        Test.stopTest();

        // Basic validation that a response was returned
        System.assertNotEquals(null, RestContext.response.responseBody, 'Response body should not be null');
        System.assertEquals(200, RestContext.response.statusCode, 'Expected HTTP 200 OK');

        String jsonResponse = RestContext.response.responseBody.toString();
        System.assert(jsonResponse.contains('FirstName'), 'Response should contain contact fields');
        System.assert(jsonResponse.contains('User1') || jsonResponse.contains('User2'), 'Expected contact data to be serialized');
    }

    @IsTest
    static void testContactCountEndpoint() {
        // Create a test Account and matching Contact
        Account acc = new Account(Name = 'Count Test Account');
        insert acc;

        Contact c = new Contact(
            FirstName = 'Jim',
            LastName = 'Beam',
            Email = 'jim.beam@example.com',
            AccountId = acc.Id,
            Contact_is_Inactive__c = false,
            Corp_SF_Tag_Associate_Member__c = true
        );
        insert c;

        // Simulate request to /count route
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/ecchoContacts/count';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        EcchoContactExportService.doGet();
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        System.assert(body.contains('total'), 'Expected "total" key in response');
        System.assert(RestContext.response.statusCode == 200, 'Expected HTTP 200 OK');
    }
}