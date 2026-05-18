/**
 * Transformer for the Avalara CreateCertExpressInvitation API operation.
 * Converts between AvalaraCertExpressInvitation inner classes and JSON payloads.
 * Note: the API expects a JSON array and returns a JSON array.
*/
public with sharing class AvalaraCertExpressInvitationTransformer {

    /**
     * Transforms a CertExpressInvitation Request into a JSON string for the API callout.
     * Wraps the single invitation in an array as required by the Avalara API.
     * @param invitationRequest the CertExpress invitation request data
     * @return JSON string representation of the request (array format)
    */
    public static String transformRequest(AvalaraCertExpressInvitation.Request invitationRequest) {
        if (invitationRequest == null) {
            throw new AvalaraAuthProviderService.AvalaraException('CertExpress invitation request cannot be null.');
        }

        Map<String, Object> payload = buildRequestPayload(invitationRequest);
        return JSON.serialize(new List<Map<String, Object>>{ payload });
    }

    /**
     * Transforms a JSON response string from the API into a CertExpressInvitation Response.
     * The API returns an array; this extracts the first element.
     * @param jsonResponseBody the raw JSON response body from the Avalara API
     * @return parsed Response with the CertExpress portal URL
    */
    public static AvalaraCertExpressInvitation.Response transformResponse(String jsonResponseBody) {
        if (String.isBlank(jsonResponseBody)) {
            throw new AvalaraAuthProviderService.AvalaraException('CertExpress invitation response body is blank.');
        }

        List<Object> rawList = (List<Object>) JSON.deserializeUntyped(jsonResponseBody);
        if (rawList == null || rawList.isEmpty()) {
            throw new AvalaraAuthProviderService.AvalaraException('CertExpress invitation response returned empty array.');
        }

        return buildResponseFromRawMap((Map<String, Object>) rawList[0]);
    }

    // ─── Request Building ───

    private static Map<String, Object> buildRequestPayload(AvalaraCertExpressInvitation.Request invitationRequest) {
        Map<String, Object> payload = new Map<String, Object>();

        addIfNotBlank(payload, 'recipient', invitationRequest.recipient);
        addIfNotBlank(payload, 'coverLetterTitle', invitationRequest.coverLetterTitle);
        addIfNotBlank(payload, 'deliveryMethod', invitationRequest.deliveryMethod);

        return payload;
    }

    private static void addIfNotBlank(Map<String, Object> targetMap, String fieldName, String fieldValue) {
        if (String.isNotBlank(fieldValue)) {
            targetMap.put(fieldName, fieldValue);
        }
    }

    // ─── Response Building ───

    private static AvalaraCertExpressInvitation.Response buildResponseFromRawMap(Map<String, Object> rawResponse) {
        AvalaraCertExpressInvitation.Response response = new AvalaraCertExpressInvitation.Response();
        response.status = (String) rawResponse.get('status');

        Map<String, Object> invitation = (Map<String, Object>) rawResponse.get('invitation');
        if (invitation != null) {
            response.id = (Integer) invitation.get('id');
            response.companyId = (Integer) invitation.get('companyId');
            response.customerCode = (String) invitation.get('customerCode');
            response.requestLink = (String) invitation.get('requestLink');
        }

        return response;
    }
}
