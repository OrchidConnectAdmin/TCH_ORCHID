@isTest
private class AvalaraListCertificatesTransformerTest {

    // ─── transformResponse Tests ───

    @isTest
    static void transformResponseParsesCertificatesTest() {
        String responseJson = buildCertificatesResponseJson();

        Test.startTest();
        AvalaraListCertificates.Response response = AvalaraListCertificatesTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(2, response.recordsetCount, 'recordsetCount should be 2');
        System.assertEquals(2, response.certificates.size(), 'Should parse 2 certificates');

        AvalaraListCertificates.Certificate cert1 = response.certificates[0];
        System.assertEquals(1001, cert1.id, 'First certificate id should be parsed');
        System.assertEquals('COMPLETE', cert1.status, 'First certificate status should be parsed');
        System.assertEquals('2026-01-15', cert1.signedDate, 'signedDate should be parsed');
        System.assertEquals('2027-01-15', cert1.expirationDate, 'expirationDate should be parsed');
        System.assertEquals('Texas', cert1.exposureZoneName, 'exposureZone name should be extracted');
        System.assertEquals('TAXABLE', cert1.exemptionReasonName, 'exemptionReason name should be extracted');

        AvalaraListCertificates.Certificate cert2 = response.certificates[1];
        System.assertEquals(1002, cert2.id, 'Second certificate id should be parsed');
        System.assertEquals('PENDING', cert2.status, 'Second certificate status should be parsed');
    }

    @isTest
    static void transformResponseHandlesEmptyValueArrayTest() {
        String responseJson = '{"@recordsetCount":0,"value":[]}';

        Test.startTest();
        AvalaraListCertificates.Response response = AvalaraListCertificatesTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(0, response.recordsetCount, 'recordsetCount should be 0');
        System.assertEquals(0, response.certificates.size(), 'Should have no certificates');
    }

    @isTest
    static void transformResponseHandlesNullValueTest() {
        String responseJson = '{"@recordsetCount":0}';

        Test.startTest();
        AvalaraListCertificates.Response response = AvalaraListCertificatesTransformer.transformResponse(responseJson);
        Test.stopTest();

        System.assertEquals(0, response.recordsetCount, 'recordsetCount should be 0');
        System.assertEquals(0, response.certificates.size(), 'Should have empty list when value is null');
    }

    @isTest
    static void transformResponseHandlesMissingNestedObjectsTest() {
        String responseJson = '{"@recordsetCount":1,"value":[{'
            + '"id":2001,"status":"COMPLETE","signedDate":"2026-03-01","expirationDate":"2027-03-01"'
            + '}]}';

        Test.startTest();
        AvalaraListCertificates.Response response = AvalaraListCertificatesTransformer.transformResponse(responseJson);
        Test.stopTest();

        AvalaraListCertificates.Certificate cert = response.certificates[0];
        System.assertEquals(null, cert.exposureZoneName, 'exposureZoneName should be null when object is missing');
        System.assertEquals(null, cert.exemptionReasonName, 'exemptionReasonName should be null when object is missing');
    }

    @isTest
    static void transformResponseThrowsWhenBlankTest() {
        Boolean exceptionWasThrown = false;

        Test.startTest();
        try {
            AvalaraListCertificatesTransformer.transformResponse('');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('blank'), 'Should indicate blank response');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for blank response');
    }

    // ─── Test Data Helpers ───

    private static String buildCertificatesResponseJson() {
        return '{"@recordsetCount":2,"value":['
            + '{"id":1001,"status":"COMPLETE","signedDate":"2026-01-15","expirationDate":"2027-01-15",'
            + '"exposureZone":{"id":1,"name":"Texas"},'
            + '"exemptionReason":{"id":5,"name":"TAXABLE"}},'
            + '{"id":1002,"status":"PENDING","signedDate":"2026-05-10","expirationDate":null,'
            + '"exposureZone":{"id":2,"name":"New York"},'
            + '"exemptionReason":{"id":3,"name":"RESALE"}}'
            + ']}';
    }
}
