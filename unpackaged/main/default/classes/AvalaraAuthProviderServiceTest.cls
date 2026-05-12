/**
 * Test class for AvalaraAuthProviderService.
 * Covers: execute by service name, executeWithBody, executeWithPathVariables, executeRequest,
 * error handling (401, 500 malformed, 503 empty), error parsing, path variable substitution,
 * and dynamic Named Credential selection by org type.
 */
@isTest
private class AvalaraAuthProviderServiceTest {

    // ─── Mock Implementations ───

    /**
     * Mock that returns a successful response and validates outbound request headers.
     */
    private class SuccessWithHeaderValidationMock implements HttpCalloutMock {
        /** Responds with a 200 and validates Content-Type and X-Avalara-Client headers. */
        public HttpResponse respond(HttpRequest request) {
            System.assertEquals('application/json', request.getHeader('Content-Type'), 'Content-Type header must be set');
            System.assert(String.isNotBlank(request.getHeader('X-Avalara-Client')), 'X-Avalara-Client header must be set');

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"version":"24.6.3","authenticated":true}');
            return response;
        }
    }

    /**
     * Mock that returns a 401 Unauthorized with a standard Avalara error JSON body.
     */
    private class UnauthorizedErrorMock implements HttpCalloutMock {
        /** Responds with a 401 and standard Avalara error JSON. */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(401);
            response.setBody('{"error":{"code":"AuthenticationException","message":"The user or account could not be authenticated."}}');
            return response;
        }
    }

    /**
     * Mock that returns a 500 with a non-JSON body to test malformed error handling.
     */
    private class MalformedErrorBodyMock implements HttpCalloutMock {
        /** Responds with a 500 and non-JSON body. */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setBody('this is not json');
            return response;
        }
    }

    /**
     * Mock that returns a 503 with an empty body to test blank error handling.
     */
    private class EmptyErrorBodyMock implements HttpCalloutMock {
        /** Responds with a 503 and empty body. */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(503);
            response.setBody('');
            return response;
        }
    }

    /**
     * Mock that returns a successful POST response and validates the request body is present.
     */
    private class PostSuccessWithBodyValidationMock implements HttpCalloutMock {
        /** Responds with a 200 and validates that the request has a body. */
        public HttpResponse respond(HttpRequest request) {
            System.assert(String.isNotBlank(request.getBody()), 'POST request should have a body');

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"totalTax":6.00}');
            return response;
        }
    }

    // ─── execute Tests ───

    /**
     * Verifies that execute resolves the Ping service and returns a successful response.
     */
    @isTest
    static void executeWithPingServiceReturnsSuccessTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new SuccessWithHeaderValidationMock());

        Test.startTest();
        HttpResponse response = AvalaraAuthProviderService.execute('Ping');
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode(), 'Ping should return 200');
    }

    /**
     * Verifies that execute throws AvalaraException for a non-existent service name.
     */
    @isTest
    static void executeWithInvalidServiceThrowsExceptionTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;

        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraAuthProviderService.execute('Non_Existent_Service');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('Non_Existent_Service'), 'Error should contain the service name');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'AvalaraException should be thrown for invalid service');
    }

    // ─── executeWithBody Tests ───

    /**
     * Verifies that executeWithBody sends the JSON body and returns a successful response.
     */
    @isTest
    static void executeWithBodySendsJsonAndReturnsSuccessTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new PostSuccessWithBodyValidationMock());

        Test.startTest();
        HttpResponse response = AvalaraAuthProviderService.executeWithBody('Create_Transaction', '{"type":"SalesOrder"}');
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode(), 'POST should return 200');
    }

    // ─── executeWithPathVariables Tests ───

    /**
     * Verifies that executeWithPathVariables replaces path placeholders correctly.
     */
    @isTest
    static void executeWithPathVariablesResolvesPlaceholdersTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new SuccessWithHeaderValidationMock());

        Map<String, String> pathVariables = new Map<String, String>{
            'companyCode' => 'TCH_PROD',
            'transactionCode' => 'ABC123'
        };

        Test.startTest();
        HttpResponse response = AvalaraAuthProviderService.executeWithPathVariables('Commit_Transaction', pathVariables);
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode(), 'Should return 200 after path variable substitution');
    }

    // ─── executeRequest Tests ───

    /**
     * Verifies that executeRequest handles path variables and body together.
     */
    @isTest
    static void executeRequestWithPathVariablesAndBodyReturnsSuccessTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new PostSuccessWithBodyValidationMock());

        AvalaraAuthProviderService.AvalaraCalloutRequest calloutRequest = new AvalaraAuthProviderService.AvalaraCalloutRequest();
        calloutRequest.serviceDeveloperName = 'Commit_Transaction';
        calloutRequest.pathVariables = new Map<String, String>{
            'companyCode' => 'TCH_PROD',
            'transactionCode' => 'ABC123'
        };
        calloutRequest.jsonBody = '{"commit":true}';

        Test.startTest();
        HttpResponse response = AvalaraAuthProviderService.executeRequest(calloutRequest);
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode(), 'executeRequest should return 200');
    }

    // ─── Error Handling Tests ───

    /**
     * Verifies that a 401 response throws AvalaraException with sanitized message.
     */
    @isTest
    static void executeWith401ThrowsSanitizedExceptionTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new UnauthorizedErrorMock());

        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraAuthProviderService.execute('Ping');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('401'), 'Error message should contain status code');
            System.assert(!avalaraError.getMessage().contains('could not be authenticated'), 'Error message should NOT leak API detail');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'AvalaraException should be thrown on 401 response');
    }

    /**
     * Verifies that a 500 with malformed JSON body still throws AvalaraException gracefully.
     */
    @isTest
    static void executeWithMalformedErrorBodyThrowsExceptionTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new MalformedErrorBodyMock());

        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraAuthProviderService.execute('Ping');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('500'), 'Error message should contain status code');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'AvalaraException should be thrown for malformed error body');
    }

    /**
     * Verifies that a 503 with empty body still throws AvalaraException gracefully.
     */
    @isTest
    static void executeWithEmptyErrorBodyThrowsExceptionTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new EmptyErrorBodyMock());

        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraAuthProviderService.execute('Ping');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('503'), 'Error message should contain status code');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'AvalaraException should be thrown for empty error body');
    }

    // ─── Named Credential Selection Tests ───

    /**
     * Verifies that sandbox orgs resolve to the Sandbox Named Credential.
     */
    @isTest
    static void sandboxOrgUsesSandboxNamedCredentialTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;

        Test.startTest();
        String namedCredential = AvalaraAuthProviderService.getNamedCredential();
        Test.stopTest();

        System.assert(namedCredential.contains('Sandbox'), 'Sandbox org should use Sandbox Named Credential');
    }

    /**
     * Verifies that production orgs resolve to the Production Named Credential.
     */
    @isTest
    static void productionOrgUsesProductionNamedCredentialTest() {
        AvalaraAuthProviderService.isSandboxOverride = false;

        Test.startTest();
        String namedCredential = AvalaraAuthProviderService.getNamedCredential();
        Test.stopTest();

        System.assert(namedCredential.contains('Production'), 'Production org should use Production Named Credential');
    }

    // ─── Path Variable Substitution Tests ───

    /**
     * Verifies that replacePathVariables substitutes all placeholders correctly.
     */
    @isTest
    static void replacePathVariablesSubstitutesAllPlaceholdersTest() {
        Map<String, String> pathVariables = new Map<String, String>{
            'companyCode' => 'TCH',
            'transactionCode' => 'TX001'
        };

        Test.startTest();
        String resolvedPath = AvalaraAuthProviderService.replacePathVariables(
            '/api/v2/companies/{companyCode}/transactions/{transactionCode}/commit',
            pathVariables
        );
        Test.stopTest();

        System.assertEquals('/api/v2/companies/TCH/transactions/TX001/commit', resolvedPath, 'All placeholders should be replaced');
    }

    // ─── parseErrorDetail Tests ───

    /**
     * Verifies that parseErrorDetail extracts the message from a valid Avalara error JSON.
     */
    @isTest
    static void parseErrorDetailExtractsMessageFromValidJsonTest() {
        String errorDetail = AvalaraAuthProviderService.parseErrorDetail('{"error":{"message":"Test error"}}');

        System.assertEquals('Test error', errorDetail, 'Should extract message from error JSON');
    }

    /**
     * Verifies that parseErrorDetail handles non-JSON body gracefully.
     */
    @isTest
    static void parseErrorDetailHandlesNonJsonBodyTest() {
        String errorDetail = AvalaraAuthProviderService.parseErrorDetail('not json');

        System.assert(errorDetail.contains('Unparseable'), 'Should indicate unparseable response');
    }

    /**
     * Verifies that parseErrorDetail returns a default message for blank body.
     */
    @isTest
    static void parseErrorDetailReturnsDefaultForBlankBodyTest() {
        String errorDetail = AvalaraAuthProviderService.parseErrorDetail('');

        System.assertEquals('No response body', errorDetail, 'Should indicate no body');
    }
}
