/**
 * Test class for AvalaraCertExpressInvitationTransformer.
 * Covers: request serialization (all fields, array wrapping),
 * response deserialization (requestLink, status), and edge cases.
 */
@isTest
private class AvalaraCertExpressInviteTransformerTest {

    // ─── transformRequest Tests ───

    @isTest
    static void transformRequestSerializesAllFieldsTest() {
        AvalaraCertExpressInvitation.Request invitationRequest = buildInvitationRequest();

        Test.startTest();
        String jsonResult = AvalaraCertExpressInvitationTransformer.transformRequest(invitationRequest);
        Test.stopTest();

        List<Object> parsedList = (List<Object>) JSON.deserializeUntyped(jsonResult);
        System.assertEquals(1, parsedList.size(), 'Should be wrapped in an array with one element');

        Map<String, Object> parsed = (Map<String, Object>) parsedList[0];
        System.assertEquals('test@example.com', parsed.get('recipient'), 'recipient should be serialized');
        System.assertEquals('STANDARD_REQUEST', parsed.get('coverLetterTitle'), 'coverLetterTitle should be serialized');
        System.assertEquals('Email', parsed.get('deliveryMethod'), 'deliveryMethod should be serialized');
    }

    @isTest
    static void transformRequestOmitsBlankFieldsTest() {
        AvalaraCertExpressInvitation.Request invitationRequest = new AvalaraCertExpressInvitation.Request();

        Test.startTest();
        String jsonResult = AvalaraCertExpressInvitationTransformer.transformRequest(invitationRequest);
        Test.stopTest();

        List<Object> parsedList = (List<Object>) JSON.deserializeUntyped(jsonResult);
        Map<String, Object> parsed = (Map<String, Object>) parsedList[0];
        System.assertEquals(null, parsed.get('recipient'), 'blank recipient should be omitted');
    }

    @isTest
    static void transformRequestThrowsWhenNullTest() {
        Boolean exceptionWasThrown = false;

        Test.startTest();
        try {
            AvalaraCertExpressInvitationTransformer.transformRequest(null);
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('cannot be null'), 'Should indicate null request');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for null request');
    }

    // ─── transformResponse Tests ───

    @isTest
    static void transformResponseParsesInvitationDataTest() {
        String responseJson = buildInvitationResponseJson();

        Test.startTest();
        AvalaraCertExpressInvitation.Response response = AvalaraCertExpressInvitationTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(99999, response.id, 'id should be parsed');
        System.assertEquals(12345, response.companyId, 'companyId should be parsed');
        System.assertEquals('CUST-001', response.customerCode, 'customerCode should be parsed');
        System.assertEquals('https://sbx.certexpress.com/?r=test-token', response.requestLink, 'requestLink should be parsed');
        System.assertEquals('Ready', response.status, 'status should be parsed');
    }

    @isTest
    static void transformResponseThrowsWhenBlankTest() {
        Boolean exceptionWasThrown = false;

        Test.startTest();
        try {
            AvalaraCertExpressInvitationTransformer.transformResponse('');
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
            AvalaraCertExpressInvitationTransformer.transformResponse('[]');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('empty array'), 'Should indicate empty array');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for empty array');
    }

    // ─── Test Data Helpers ───

    private static AvalaraCertExpressInvitation.Request buildInvitationRequest() {
        AvalaraCertExpressInvitation.Request invitationRequest = new AvalaraCertExpressInvitation.Request();
        invitationRequest.recipient = 'test@example.com';
        invitationRequest.coverLetterTitle = 'STANDARD_REQUEST';
        invitationRequest.deliveryMethod = 'Email';
        return invitationRequest;
    }

    private static String buildInvitationResponseJson() {
        return '[{'
            + '"status":"Ready",'
            + '"invitation":{'
            + '"id":99999,'
            + '"companyId":12345,'
            + '"customerCode":"CUST-001",'
            + '"requestLink":"https://sbx.certexpress.com/?r=test-token"'
            + '}'
            + '}]';
    }
}
