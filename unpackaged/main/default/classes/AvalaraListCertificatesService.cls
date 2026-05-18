/**
 * Service for the Avalara ListCertificatesForCustomer API operation.
 * Retrieves all exemption certificates associated with a customer.
 */
public with sharing class AvalaraListCertificatesService {

    private static final String SERVICE_DEVELOPER_NAME = 'List_Certificates_For_Customer';

    /**
     * Lists all certificates for a customer in Avalara's ECM.
     * @param companyId the numeric Avalara Company ID
     * @param customerCode the customer identifier in Avalara
     * @return the response with certificate list and count
     */
    public static AvalaraListCertificates.Response execute(String companyId, String customerCode) {
        HttpResponse httpResponse = AvalaraAuthProviderService.executeWithPathVariables(
            SERVICE_DEVELOPER_NAME,
            new Map<String, String>{
                'companyId' => companyId,
                'customerCode' => customerCode
            }
        );
        return AvalaraListCertificatesTransformer.transformResponse(httpResponse.getBody());
    }
}
