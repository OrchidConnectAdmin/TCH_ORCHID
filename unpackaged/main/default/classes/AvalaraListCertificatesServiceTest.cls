@isTest
private class AvalaraListCertificatesServiceTest {

    // ─── Mock Implementations ───

    private class ListCertificatesSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"@recordsetCount":1,"value":['
                + '{"id":1001,"status":"COMPLETE","signedDate":"2026-01-15","expirationDate":"2027-01-15",'
                + '"exposureZone":{"id":1,"name":"Texas"},'
                + '"exemptionReason":{"id":5,"name":"TAXABLE"}}'
                + ']}');
            return response;
        }
    }

    private class ListCertificatesEmptyMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"@recordsetCount":0,"value":[]}');
            return response;
        }
    }

    // ─── execute Tests ───

    @isTest
    static void executeReturnsCertificatesTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new ListCertificatesSuccessMock());

        Test.startTest();
        AvalaraListCertificates.Response response = AvalaraListCertificatesService.execute('312140', 'CUST-001');
        Test.stopTest();

        System.assertEquals(1, response.recordsetCount, 'recordsetCount should be 1');
        System.assertEquals(1, response.certificates.size(), 'Should return 1 certificate');
        System.assertEquals(1001, response.certificates[0].id, 'Certificate id should be parsed');
        System.assertEquals('Texas', response.certificates[0].exposureZoneName, 'exposureZone should be extracted');
    }

    @isTest
    static void executeReturnsEmptyListTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new ListCertificatesEmptyMock());

        Test.startTest();
        AvalaraListCertificates.Response response = AvalaraListCertificatesService.execute('312140', 'CUST-001');
        Test.stopTest();

        System.assertEquals(0, response.recordsetCount, 'recordsetCount should be 0');
        System.assertEquals(0, response.certificates.size(), 'Should return empty list');
    }
}
