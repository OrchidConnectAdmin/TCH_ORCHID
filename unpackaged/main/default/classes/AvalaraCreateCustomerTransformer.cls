/**
 * Transformer for the Avalara CreateCustomers API operation.
 * Converts between AvalaraCreateCustomer inner classes and JSON payloads.
 * Note: the API expects a JSON array (list of customers) and returns a JSON array.
 */
public with sharing class AvalaraCreateCustomerTransformer {

    /**
     * Transforms a CreateCustomer Request into a JSON string for the API callout.
     * Wraps the single customer in an array as required by the Avalara API.
     * @param customerRequest the customer registration request data
     * @return JSON string representation of the request (array format)
     */
    public static String transformRequest(AvalaraCreateCustomer.Request customerRequest) {
        if (customerRequest == null) {
            throw new AvalaraAuthProviderService.AvalaraException('Customer request cannot be null.');
        }

        Map<String, Object> payload = buildRequestPayload(customerRequest);
        return JSON.serialize(new List<Map<String, Object>>{ payload });
    }

    /**
     * Transforms a JSON response string from the API into a CreateCustomer Response.
     * The API returns an array; this extracts the first element.
     * @param jsonResponseBody the raw JSON response body from the Avalara API
     * @return parsed Response with customer data
     */
    public static AvalaraCreateCustomer.Response transformResponse(String jsonResponseBody) {
        if (String.isBlank(jsonResponseBody)) {
            throw new AvalaraAuthProviderService.AvalaraException('Customer response body is blank.');
        }

        List<Object> rawList = (List<Object>) JSON.deserializeUntyped(jsonResponseBody);
        if (rawList == null || rawList.isEmpty()) {
            throw new AvalaraAuthProviderService.AvalaraException('Customer response returned empty array.');
        }

        return buildResponseFromRawMap((Map<String, Object>) rawList[0]);
    }

    // ─── Request Building ───

    private static Map<String, Object> buildRequestPayload(AvalaraCreateCustomer.Request customerRequest) {
        Map<String, Object> payload = new Map<String, Object>();

        payload.put('customerCode', customerRequest.customerCode);
        addIfNotBlank(payload, 'name', customerRequest.name);
        addIfNotBlank(payload, 'line1', customerRequest.line1);
        addIfNotBlank(payload, 'city', customerRequest.city);
        addIfNotBlank(payload, 'region', customerRequest.region);
        addIfNotBlank(payload, 'postalCode', customerRequest.postalCode);
        addIfNotBlank(payload, 'country', customerRequest.country);
        addIfNotBlank(payload, 'emailAddress', customerRequest.emailAddress);

        return payload;
    }

    private static void addIfNotBlank(Map<String, Object> targetMap, String fieldName, String fieldValue) {
        if (String.isNotBlank(fieldValue)) {
            targetMap.put(fieldName, fieldValue);
        }
    }

    // ─── Response Building ───

    private static AvalaraCreateCustomer.Response buildResponseFromRawMap(Map<String, Object> rawResponse) {
        AvalaraCreateCustomer.Response response = new AvalaraCreateCustomer.Response();

        response.id = (Integer) rawResponse.get('id');
        response.customerCode = (String) rawResponse.get('customerCode');
        response.name = (String) rawResponse.get('name');
        response.emailAddress = (String) rawResponse.get('emailAddress');
        response.line1 = (String) rawResponse.get('line1');
        response.city = (String) rawResponse.get('city');
        response.region = (String) rawResponse.get('region');
        response.postalCode = (String) rawResponse.get('postalCode');
        response.country = (String) rawResponse.get('country');

        return response;
    }
}
