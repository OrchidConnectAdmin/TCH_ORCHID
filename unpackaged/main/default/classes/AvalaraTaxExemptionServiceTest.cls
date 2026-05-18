@isTest
private class AvalaraTaxExemptionServiceTest {

    // ─── Mock Implementations ───

    private class CreateCustomerAndInviteMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            String endpoint = request.getEndpoint();
            if (endpoint.contains('/customers') && !endpoint.contains('/certexpressinvites')) {
                response.setBody('[{'
                    + '"id":12345,'
                    + '"customerCode":"CUST-001",'
                    + '"name":"Test Account",'
                    + '"emailAddress":"test@example.com"'
                    + '}]');
            } else if (endpoint.contains('/certexpressinvites')) {
                response.setBody('[{'
                    + '"status":"Ready",'
                    + '"invitation":{'
                    + '"id":99999,'
                    + '"companyId":312140,'
                    + '"customerCode":"CUST-001",'
                    + '"requestLink":"https://sbx.certexpress.com/?r=test-token"'
                    + '}'
                    + '}]');
            }

            return response;
        }
    }

    private class InviteOnlyMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('[{'
                + '"status":"Ready",'
                + '"invitation":{'
                + '"id":88888,'
                + '"companyId":312140,'
                + '"customerCode":"CUST-001",'
                + '"requestLink":"https://sbx.certexpress.com/?r=new-invite"'
                + '}'
                + '}]');
            return response;
        }
    }

    private class ListCertificatesAndInviteMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            if (request.getMethod() == 'GET') {
                response.setBody('{"@recordsetCount":1,"value":['
                    + '{"id":1001,"status":"COMPLETE","signedDate":"2026-01-15","expirationDate":"2027-01-15",'
                    + '"exposureZone":{"id":1,"name":"Texas"},'
                    + '"exemptionReason":{"id":5,"name":"TAXABLE"}}'
                    + ']}');
            } else {
                response.setBody('[{'
                    + '"status":"Ready",'
                    + '"invitation":{'
                    + '"id":77777,'
                    + '"companyId":312140,'
                    + '"customerCode":"CUST-001",'
                    + '"requestLink":"https://sbx.certexpress.com/?r=registered-invite"'
                    + '}'
                    + '}]');
            }

            return response;
        }
    }

    // ─── Test Data ───

    @TestSetup
    static void setupTestData() {
        Account acc = new Account(
            Name = 'Test Account',
            ShippingStreet = '350 Fifth Avenue',
            ShippingCity = 'New York',
            ShippingState = 'New York',
            ShippingPostalCode = '10118',
            ShippingCountry = 'United States'
        );
        insert acc;

        Contact ct = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            AccountId = acc.Id,
            MailingStreet = '742 Evergreen Terrace',
            MailingCity = 'Springfield',
            MailingState = 'Illinois',
            MailingPostalCode = '62704',
            MailingCountry = 'United States'
        );
        insert ct;
    }

    // ─── getExemptionInfo Tests ───

    @isTest
    static void should_throw_when_user_has_no_contact() {
        Boolean exceptionWasThrown = false;

        Test.startTest();
        try {
            AvalaraTaxExemptionService.getExemptionInfo();
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('No Contact'), 'Should indicate no Contact linked');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw when running user has no Contact');
    }

    @isTest
    static void should_return_unregistered_info_for_community_user() {
        User communityUser = createCommunityUser();
        if (communityUser == null) {
            return;
        }

        System.runAs(communityUser) {
            Test.startTest();
            AvalaraTaxExemptionService.ExemptionInfo info = AvalaraTaxExemptionService.getExemptionInfo();
            Test.stopTest();

            System.assertEquals(false, info.isRegistered, 'Should not be registered when Avalara_Customer_Id__c is blank');
            System.assertNotEquals(null, info.contactId, 'contactId should be populated');
            System.assertNotEquals(null, info.accountId, 'accountId should be populated');
            System.assertEquals('john.doe@example.com', info.customerEmail, 'customerEmail should come from Contact');
            System.assert(info.addressOptions.size() > 0, 'Should have at least one address option');
            System.assertEquals(0, info.certificates.size(), 'Should have no certificates when not registered');
        }
    }

    @isTest
    static void should_return_registered_info_with_certificates() {
        User communityUser = createCommunityUser();
        if (communityUser == null) {
            return;
        }

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        acc.Avalara_Customer_Id__c = '12345';
        update acc;

        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new ListCertificatesAndInviteMock());

        System.runAs(communityUser) {
            Test.startTest();
            AvalaraTaxExemptionService.ExemptionInfo info = AvalaraTaxExemptionService.getExemptionInfo();
            Test.stopTest();

            System.assertEquals(true, info.isRegistered, 'Should be registered when Avalara_Customer_Id__c is populated');
            System.assertEquals(1, info.certificates.size(), 'Should have 1 certificate from mock');
            System.assertEquals('COMPLETE', info.certificates[0].status, 'Certificate status should be parsed');
            System.assertEquals('Texas', info.certificates[0].exposureZone, 'exposureZone should be parsed');
        }
    }

    // ─── registerAndInvite Tests ───

    @isTest
    static void should_return_error_when_user_has_no_contact_on_register() {
        Test.startTest();
        AvalaraTaxExemptionService.RegistrationResult result = AvalaraTaxExemptionService.registerAndInvite(
            'Test', '350 Fifth Ave', 'New York', 'NY', '10118', 'US', 'test@example.com'
        );
        Test.stopTest();

        System.assertEquals(false, result.success, 'Should fail when user has no Contact');
        System.assert(result.errorMessage.contains('No Contact'), 'Should contain error about Contact');
    }

    @isTest
    static void should_register_new_customer_and_return_invite_url() {
        User communityUser = createCommunityUser();
        if (communityUser == null) {
            return;
        }

        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new CreateCustomerAndInviteMock());

        System.runAs(communityUser) {
            Test.startTest();
            AvalaraTaxExemptionService.RegistrationResult result = AvalaraTaxExemptionService.registerAndInvite(
                'Test Account', '350 Fifth Avenue', 'New York', 'NY', '10118', 'US', 'john.doe@example.com'
            );
            Test.stopTest();

            System.assertEquals(true, result.success, 'Should succeed');
            System.assert(result.certExpressUrl.contains('certexpress.com'), 'Should return CertExpress URL');
        }

        Account acc = [SELECT Avalara_Customer_Id__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals('12345', acc.Avalara_Customer_Id__c, 'Should persist Avalara Customer ID on Account');
    }

    @isTest
    static void should_skip_create_customer_when_already_registered() {
        User communityUser = createCommunityUser();
        if (communityUser == null) {
            return;
        }

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        acc.Avalara_Customer_Id__c = '12345';
        update acc;

        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new InviteOnlyMock());

        System.runAs(communityUser) {
            Test.startTest();
            AvalaraTaxExemptionService.RegistrationResult result = AvalaraTaxExemptionService.registerAndInvite(
                'Test Account', '350 Fifth Avenue', 'New York', 'NY', '10118', 'US', 'john.doe@example.com'
            );
            Test.stopTest();

            System.assertEquals(true, result.success, 'Should succeed without calling CreateCustomers');
            System.assert(result.certExpressUrl.contains('new-invite'), 'Should return new invite URL');
        }
    }

    // ─── requestNewExemption Tests ───

    @isTest
    static void should_return_error_when_user_has_no_contact_on_new_exemption() {
        Test.startTest();
        AvalaraTaxExemptionService.RegistrationResult result = AvalaraTaxExemptionService.requestNewExemption('test@example.com');
        Test.stopTest();

        System.assertEquals(false, result.success, 'Should fail when user has no Contact');
        System.assert(result.errorMessage.contains('No Contact'), 'Should contain error about Contact');
    }

    @isTest
    static void should_generate_new_invite_for_registered_user() {
        User communityUser = createCommunityUser();
        if (communityUser == null) {
            return;
        }

        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new InviteOnlyMock());

        System.runAs(communityUser) {
            Test.startTest();
            AvalaraTaxExemptionService.RegistrationResult result = AvalaraTaxExemptionService.requestNewExemption('john.doe@example.com');
            Test.stopTest();

            System.assertEquals(true, result.success, 'Should succeed');
            System.assert(result.certExpressUrl.contains('certexpress.com'), 'Should return CertExpress URL');
        }
    }

    // ─── Community User Helper ───

    private static User createCommunityUser() {
        List<Profile> profiles = [
            SELECT Id FROM Profile
            WHERE Name IN ('Fonteva Customer Community Login User', 'Customer Community Login User', 'Customer Community User')
            LIMIT 1
        ];

        if (profiles.isEmpty()) {
            return null;
        }

        Contact ct = [SELECT Id, Email FROM Contact WHERE LastName = 'Doe' LIMIT 1];

        try {
            User communityUser = new User(
                ProfileId = profiles[0].Id,
                ContactId = ct.Id,
                Username = 'avalara.test.' + System.currentTimeMillis() + '@test.com',
                Email = ct.Email,
                FirstName = 'John',
                LastName = 'Doe',
                Alias = 'jdoe',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US'
            );
            insert communityUser;
            return communityUser;
        } catch (DmlException e) {
            return null;
        }
    }
}
