/**
 * Test class for AvalaraCertExpressInvitationService.
 * Covers: end-to-end CertExpress invitation flow with HttpCalloutMock.
 */
@isTest
private class AvalaraCertExpressInvitationServiceTest {

    // ─── Mock Implementations ───

    private class CertExpressInvitationSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('[{'
                + '"status":"Ready",'
                + '"invitation":{'
                + '"id":99999,'
                + '"companyId":12345,'
                + '"customerCode":"CUST-001",'
                + '"requestLink":"https://sbx.certexpress.com/?r=test-token"'
                + '}'
                + '}]');
            return response;
        }
    }

    // ─── execute Tests ───

    @isTest
    static void executeGeneratesInvitationLinkTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new CertExpressInvitationSuccessMock());

        AvalaraCertExpressInvitation.Request invitationRequest = buildInvitationRequest();

        Test.startTest();
        AvalaraCertExpressInvitation.Response response = AvalaraCertExpressInvitationService.execute(
            invitationRequest, '12345', 'CUST-001'
        );
        Test.stopTest();

        System.assertEquals(99999, response.id, 'Invitation ID should be returned');
        System.assertEquals('CUST-001', response.customerCode, 'customerCode should be echoed back');
        System.assert(response.requestLink.contains('certexpress.com'), 'requestLink should contain CertExpress URL');
        System.assertEquals('Ready', response.status, 'status should be Ready');
    }

    // ─── Test Data Helpers ───

    private static AvalaraCertExpressInvitation.Request buildInvitationRequest() {
        AvalaraCertExpressInvitation.Request invitationRequest = new AvalaraCertExpressInvitation.Request();
        invitationRequest.recipient = 'test@example.com';
        invitationRequest.coverLetterTitle = 'STANDARD_REQUEST';
        invitationRequest.deliveryMethod = 'Email';
        return invitationRequest;
    }
}
