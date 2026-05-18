/**
 * Centralized HTTP client for all Avalara AvaTax REST API v2 callouts.
 * Resolves endpoint paths from Avalara_Service__mdt records by DeveloperName.
 * Dynamically selects the correct Named Credential (Sandbox vs Production)
 * based on Organization.IsSandbox. Authentication (accountId + licenseKey)
 * is handled entirely by the Named Credential via Basic Auth header.
 */
public without sharing class AvalaraAuthProviderService {

    private static final String SANDBOX_NAMED_CREDENTIAL = 'callout:Avalara_AvaTax_Sandbox';
    private static final String PRODUCTION_NAMED_CREDENTIAL = 'callout:Avalara_AvaTax_Production';
    private static final String AVALARA_CLIENT_HEADER_VALUE = 'TCH_Fonteva;1.0;Salesforce;avalara-tch';
    private static final Integer CALLOUT_TIMEOUT_MILLISECONDS = 30000;
    private static final Integer MAX_ERROR_BODY_LENGTH = 2000;

    @TestVisible
    private static Boolean isSandboxOverride;

    private static Boolean cachedIsSandbox;
    private static Map<String, Avalara_Service__mdt> cachedServices;

    /**
     * Executes an Avalara API callout resolved from a service DeveloperName.
     * Looks up the Avalara_Service__mdt record to get HTTP method and resource path.
     * @param serviceDeveloperName the DeveloperName of the Avalara_Service__mdt record (e.g., 'Ping', 'Create_Transaction')
     * @return HttpResponse from the Avalara API
     */
    public static HttpResponse execute(String serviceDeveloperName) {
        Avalara_Service__mdt serviceConfig = getServiceConfig(serviceDeveloperName);

        CalloutParams params = new CalloutParams();
        params.httpMethod = serviceConfig.HTTP_Method__c;
        params.apiPath = serviceConfig.Resource_Path__c;
        return executeCallout(params);
    }

    /**
     * Executes an Avalara API callout with a JSON request body, resolved from a service DeveloperName.
     * @param serviceDeveloperName the DeveloperName of the Avalara_Service__mdt record
     * @param jsonBody the JSON request body
     * @return HttpResponse from the Avalara API
     */
    public static HttpResponse executeWithBody(String serviceDeveloperName, String jsonBody) {
        Avalara_Service__mdt serviceConfig = getServiceConfig(serviceDeveloperName);

        CalloutParams params = new CalloutParams();
        params.httpMethod = serviceConfig.HTTP_Method__c;
        params.apiPath = serviceConfig.Resource_Path__c;
        params.requestBody = jsonBody;
        return executeCallout(params);
    }

    /**
     * Executes an Avalara API callout with path variable substitution, resolved from a service DeveloperName.
     * Replaces {placeholder} tokens in the resource path with values from the provided map.
     * @param serviceDeveloperName the DeveloperName of the Avalara_Service__mdt record
     * @param pathVariables map of placeholder names to values (e.g., {'companyCode' => 'TCH_PROD', 'transactionCode' => 'ABC123'})
     * @return HttpResponse from the Avalara API
     */
    public static HttpResponse executeWithPathVariables(String serviceDeveloperName, Map<String, String> pathVariables) {
        Avalara_Service__mdt serviceConfig = getServiceConfig(serviceDeveloperName);

        CalloutParams params = new CalloutParams();
        params.httpMethod = serviceConfig.HTTP_Method__c;
        params.apiPath = replacePathVariables(serviceConfig.Resource_Path__c, pathVariables);
        return executeCallout(params);
    }

    /**
     * Executes an Avalara API callout with path variables and a JSON body.
     * @param calloutRequest encapsulates the service name, path variables, and optional body
     * @return HttpResponse from the Avalara API
     */
    public static HttpResponse executeRequest(AvalaraCalloutRequest calloutRequest) {
        Avalara_Service__mdt serviceConfig = getServiceConfig(calloutRequest.serviceDeveloperName);
        String resolvedPath = serviceConfig.Resource_Path__c;

        if (calloutRequest.pathVariables != null && !calloutRequest.pathVariables.isEmpty()) {
            resolvedPath = replacePathVariables(resolvedPath, calloutRequest.pathVariables);
        }

        CalloutParams params = new CalloutParams();
        params.httpMethod = serviceConfig.HTTP_Method__c;
        params.apiPath = resolvedPath;
        params.requestBody = calloutRequest.jsonBody;
        return executeCallout(params);
    }

    /**
     * Determines if the current Salesforce org is a Sandbox.
     * Uses request-scoped cache to avoid duplicate SOQL queries.
     * @return true if the org is a Sandbox, false if Production
     */
    public static Boolean isSandboxOrganization() {
        if (isSandboxOverride != null) {
            return isSandboxOverride;
        }
        if (cachedIsSandbox != null) {
            return cachedIsSandbox;
        }

        cachedIsSandbox = queryOrganizationIsSandbox();
        return cachedIsSandbox;
    }

    /**
     * Returns the Named Credential callout prefix for the current org environment.
     * Sandbox orgs use Avalara_AvaTax_Sandbox; Production orgs use Avalara_AvaTax_Production.
     * @return the callout Named Credential string
     */
    public static String getNamedCredential() {
        if (isSandboxOrganization()) {
            return SANDBOX_NAMED_CREDENTIAL;
        }
        return PRODUCTION_NAMED_CREDENTIAL;
    }

    /**
     * Retrieves a service configuration from Avalara_Service__mdt by DeveloperName.
     * Uses request-scoped cache to load all records once per transaction.
     * @param serviceDeveloperName the DeveloperName of the service record
     * @return the matching Avalara_Service__mdt record
     */
    @TestVisible
    private static Avalara_Service__mdt getServiceConfig(String serviceDeveloperName) {
        if (cachedServices == null) {
            cachedServices = loadAllServiceConfigs();
        }

        if (!cachedServices.containsKey(serviceDeveloperName)) {
            throw new AvalaraException(
                'Avalara service not found: ' + serviceDeveloperName
                + '. Create an Avalara_Service__mdt record with this DeveloperName.'
            );
        }

        return cachedServices.get(serviceDeveloperName);
    }

    /**
     * Loads all Avalara_Service__mdt records into a map keyed by DeveloperName.
     * @return map of DeveloperName to Avalara_Service__mdt records
     */
    private static Map<String, Avalara_Service__mdt> loadAllServiceConfigs() {
        Map<String, Avalara_Service__mdt> servicesByDeveloperName = new Map<String, Avalara_Service__mdt>();

        for (Avalara_Service__mdt service : [
            SELECT DeveloperName, HTTP_Method__c, Resource_Path__c, API_Reference__c
            FROM Avalara_Service__mdt
            WITH SYSTEM_MODE
        ]) {
            servicesByDeveloperName.put(service.DeveloperName, service);
        }

        return servicesByDeveloperName;
    }

    /**
     * Replaces {placeholder} tokens in a resource path with values from the provided map.
     * @param resourcePath the path template (e.g., '/api/v2/companies/{companyCode}/transactions/{transactionCode}/commit')
     * @param pathVariables map of placeholder names to values
     * @return the resolved path with all placeholders replaced
     */
    @TestVisible
    private static String replacePathVariables(String resourcePath, Map<String, String> pathVariables) {
        String resolvedPath = resourcePath;
        for (String variableName : pathVariables.keySet()) {
            resolvedPath = resolvedPath.replace('{' + variableName + '}', pathVariables.get(variableName));
        }
        return resolvedPath;
    }

    /**
     * Executes an HTTP callout to the Avalara API using the environment-specific Named Credential.
     * Builds the request, sends it, and validates the response.
     * @param params the callout parameters (method, path, optional body)
     * @return HttpResponse from the Avalara API
     */
    private static HttpResponse executeCallout(CalloutParams params) {
        HttpRequest request = buildHttpRequest(params);
        HttpResponse response = new Http().send(request);
        validateResponse(response);
        return response;
    }

    /**
     * Builds an HttpRequest with the dynamically resolved Named Credential endpoint, headers, and optional body.
     * @param params the callout parameters
     * @return configured HttpRequest ready to send
     */
    private static HttpRequest buildHttpRequest(CalloutParams params) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(getNamedCredential() + params.apiPath);
        request.setMethod(params.httpMethod);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('X-Avalara-Client', AVALARA_CLIENT_HEADER_VALUE);
        request.setTimeout(CALLOUT_TIMEOUT_MILLISECONDS);

        if (String.isNotBlank(params.requestBody)) {
            request.setBody(params.requestBody);
        }

        return request;
    }

    /**
     * Validates the HTTP response and throws an AvalaraException if the status code indicates an error.
     * Logs the full error detail server-side; the exception message is sanitized for UI safety.
     * @param response the HttpResponse to validate
     */
    private static void validateResponse(HttpResponse response) {
        if (response.getStatusCode() < 400) {
            return;
        }

        String errorDetail = parseErrorDetail(response.getBody());
        System.debug(LoggingLevel.ERROR, 'Avalara API error ' + response.getStatusCode() + ': ' + errorDetail);
        throw new AvalaraException(
            'Avalara API error (HTTP ' + response.getStatusCode() + '): ' + errorDetail
        );
    }

    /**
     * Parses the error message from an Avalara API error response body.
     * Handles blank bodies, oversized bodies, malformed JSON, and missing error keys gracefully.
     * @param responseBody the raw response body string
     * @return a human-readable error detail string for logging
     */
    @TestVisible
    private static String parseErrorDetail(String responseBody) {
        if (String.isBlank(responseBody) || responseBody.length() > MAX_ERROR_BODY_LENGTH) {
            return 'No response body';
        }

        try {
            return extractErrorMessageFromJson(responseBody);
        } catch (Exception deserializationException) {
            return 'Unparseable response: ' + responseBody.left(200);
        }
    }

    /**
     * Extracts the error message from a JSON error response body.
     * Expects Avalara's standard format: {"error": {"message": "..."}}
     * @param jsonBody the JSON string to parse
     * @return the error message or the raw body if no error key is found
     */
    private static String extractErrorMessageFromJson(String jsonBody) {
        Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);

        if (!parsedResponse.containsKey('error')) {
            return jsonBody;
        }

        Map<String, Object> errorNode = (Map<String, Object>) parsedResponse.get('error');
        return (String) errorNode.get('message');
    }

    /**
     * Queries the Organization object to determine if the current org is a Sandbox.
     * @return true if IsSandbox = true
     */
    private static Boolean queryOrganizationIsSandbox() {
        Organization orgInfo = [
            SELECT IsSandbox
            FROM Organization
            WITH SYSTEM_MODE
            LIMIT 1
        ];
        return orgInfo.IsSandbox;
    }

    /**
     * Encapsulates a full callout request with service name, path variables, and optional body.
     */
    public class AvalaraCalloutRequest {
        /** The DeveloperName of the Avalara_Service__mdt record */
        public String serviceDeveloperName;
        /** Map of path variable placeholders to values (e.g., {'companyCode' => 'TCH'}) */
        public Map<String, String> pathVariables;
        /** The optional JSON request body */
        public String jsonBody;
    }

    /**
     * Internal callout parameters resolved from service config.
     */
    private class CalloutParams {
        /** The HTTP method (GET, POST, etc.) */
        public String httpMethod;
        /** The resolved API path */
        public String apiPath;
        /** The optional JSON request body */
        public String requestBody;
    }

    /**
     * Custom exception for Avalara API errors and configuration issues.
     */
    public class AvalaraException extends Exception {}
}
