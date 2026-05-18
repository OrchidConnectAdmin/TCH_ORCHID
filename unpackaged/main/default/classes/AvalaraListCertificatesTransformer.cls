/**
 * Transformer for the Avalara ListCertificatesForCustomer API operation.
 * Converts the JSON response into AvalaraListCertificates inner classes.
 * The API returns a paginated envelope: { "@recordsetCount": N, "value": [...] }
 */
public with sharing class AvalaraListCertificatesTransformer {

    public static AvalaraListCertificates.Response transformResponse(String jsonResponseBody) {
        if (String.isBlank(jsonResponseBody)) {
            throw new AvalaraAuthProviderService.AvalaraException('ListCertificates response body is blank.');
        }

        Map<String, Object> rawResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonResponseBody);
        return buildResponse(rawResponse);
    }

    private static AvalaraListCertificates.Response buildResponse(Map<String, Object> rawResponse) {
        AvalaraListCertificates.Response response = new AvalaraListCertificates.Response();
        response.recordsetCount = (Integer) rawResponse.get('@recordsetCount');
        response.certificates = new List<AvalaraListCertificates.Certificate>();

        List<Object> rawCertificates = (List<Object>) rawResponse.get('value');
        if (rawCertificates == null) {
            return response;
        }

        for (Object rawCert : rawCertificates) {
            response.certificates.add(buildCertificate((Map<String, Object>) rawCert));
        }

        return response;
    }

    private static AvalaraListCertificates.Certificate buildCertificate(Map<String, Object> rawCert) {
        AvalaraListCertificates.Certificate cert = new AvalaraListCertificates.Certificate();
        cert.id = (Integer) rawCert.get('id');
        cert.status = (String) rawCert.get('status');
        cert.signedDate = (String) rawCert.get('signedDate');
        cert.expirationDate = (String) rawCert.get('expirationDate');
        cert.exposureZoneName = extractNestedName(rawCert, 'exposureZone');
        cert.exemptionReasonName = extractNestedName(rawCert, 'exemptionReason');
        return cert;
    }

    private static String extractNestedName(Map<String, Object> source, String fieldName) {
        Object nested = source.get(fieldName);
        if (nested instanceof Map<String, Object>) {
            return (String) ((Map<String, Object>) nested).get('name');
        }
        return null;
    }
}
