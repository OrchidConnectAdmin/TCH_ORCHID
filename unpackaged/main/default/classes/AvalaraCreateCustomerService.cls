/**
 * Service for the Avalara CreateCustomers API operation.
 * Orchestrates customer registration: resolves companyId from config,
 * transforms the request, calls the API, and transforms the response.
*/
public with sharing class AvalaraCreateCustomerService {

    private static final String SERVICE_DEVELOPER_NAME = 'Create_Customers';

    /**
     * Registers a customer in Avalara's ECM system.
     * @param customerRequest the customer data to register
     * @param companyId the numeric Avalara Company ID (from Avalara_Config__mdt.Company_Id__c)
     * @return the created customer response with Avalara-assigned ID
    */
    public static AvalaraCreateCustomer.Response execute(AvalaraCreateCustomer.Request customerRequest, String companyId) {
        String requestJson = AvalaraCreateCustomerTransformer.transformRequest(customerRequest);

        AvalaraAuthProviderService.AvalaraCalloutRequest calloutRequest = new AvalaraAuthProviderService.AvalaraCalloutRequest();
        calloutRequest.serviceDeveloperName = SERVICE_DEVELOPER_NAME;
        calloutRequest.pathVariables = new Map<String, String>{
            'companyId' => companyId
        };
        calloutRequest.jsonBody = requestJson;

        HttpResponse httpResponse = AvalaraAuthProviderService.executeRequest(calloutRequest);
        return AvalaraCreateCustomerTransformer.transformResponse(httpResponse.getBody());
    }
}
