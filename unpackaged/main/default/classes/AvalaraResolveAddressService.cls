/**
 * Service for the Avalara ResolveAddress API operation.
 * Orchestrates the address validation flow: transforms the request,
 * calls the Avalara API via AvalaraAuthProviderService, and transforms the response.
*/
public with sharing class AvalaraResolveAddressService {

    private static final String SERVICE_DEVELOPER_NAME = 'Resolve_Address';

    /**
     * Validates an address against Avalara's address resolution engine.
     * Returns the normalized address, geolocation coordinates, and validation messages.
     * @param addressRequest the address to validate
     * @return the validated address response with normalized data and quality indicator
    */
    public static AvalaraResolveAddress.Response execute(AvalaraResolveAddress.Request addressRequest) {
        String requestJson = AvalaraResolveAddressTransformer.transformRequest(addressRequest);
        HttpResponse httpResponse = AvalaraAuthProviderService.executeWithBody(SERVICE_DEVELOPER_NAME, requestJson);
        return AvalaraResolveAddressTransformer.transformResponse(httpResponse.getBody());
    }
}
