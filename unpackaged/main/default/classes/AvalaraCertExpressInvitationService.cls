/**
 * Service for the Avalara CreateCertExpressInvitation API operation.
 * Orchestrates the CertExpress invitation flow: resolves path variables,
 * transforms the request, calls the API, and transforms the response.
 */
public with sharing class AvalaraCertExpressInvitationService {

    private static final String SERVICE_DEVELOPER_NAME = 'Create_CertExpress_Invitation';

    /**
     * Generates a CertExpress portal invitation for a customer.
     * Returns the portal URL where the customer can upload exemption certificates.
     * @param invitationRequest the invitation data (recipient, delivery method)
     * @param companyId the numeric Avalara Company ID (from Avalara_Config__mdt.Company_Id__c)
     * @param customerCode the customer identifier in Avalara
     * @return the invitation response with the CertExpress portal URL
     */
    public static AvalaraCertExpressInvitation.Response execute(
        AvalaraCertExpressInvitation.Request invitationRequest,
        String companyId,
        String customerCode
    ) {
        String requestJson = AvalaraCertExpressInvitationTransformer.transformRequest(invitationRequest);

        AvalaraAuthProviderService.AvalaraCalloutRequest calloutRequest = new AvalaraAuthProviderService.AvalaraCalloutRequest();
        calloutRequest.serviceDeveloperName = SERVICE_DEVELOPER_NAME;
        calloutRequest.pathVariables = new Map<String, String>{
            'companyId' => companyId,
            'customerCode' => customerCode
        };
        calloutRequest.jsonBody = requestJson;

        HttpResponse httpResponse = AvalaraAuthProviderService.executeRequest(calloutRequest);
        return AvalaraCertExpressInvitationTransformer.transformResponse(httpResponse.getBody());
    }
}
