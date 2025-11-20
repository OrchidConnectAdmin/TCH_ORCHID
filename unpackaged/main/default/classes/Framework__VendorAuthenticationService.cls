/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class VendorAuthenticationService {
    global VendorAuthenticationService() {

    }
    global VendorAuthenticationService(Framework.Api.ServiceConnection serviceConnection) {

    }
    global virtual String buildAuthHeader(String url, String method, Map<String,String> signatureParams, String secret) {
        return null;
    }
    global virtual String buildAuthorizationCodeUrl(Map<String,String> parameters) {
        return null;
    }
    global virtual System.PageReference buildTokenUrl() {
        return null;
    }
    global virtual String extractAccessToken(String messageBody) {
        return null;
    }
    global Framework.VendorAuthenticationService.AuthType getApiAuthType() {
        return null;
    }
    global virtual Framework.Api.ServiceConnection getApiServiceConnection() {
        return null;
    }
    global String getAuthCodeUrl() {
        return null;
    }
    global static List<Framework.VendorAuthenticationService.AuthConfig> getAuthConfig(Framework.VendorAuthenticationService.AuthType authType) {
        return null;
    }
    global static List<Framework.VendorAuthenticationService.AuthType> getAuthTypes() {
        return null;
    }
    global String getHttpMethodGetToken() {
        return null;
    }
    global String getRedirectUrl() {
        return null;
    }
    global virtual String getRedirectUrl(String connectionId) {
        return null;
    }
    global String getRefreshTokenUrl() {
        return null;
    }
    global String getTokenUrl() {
        return null;
    }
    global void setApiAuthType(Framework.VendorAuthenticationService.AuthType apiAuthType) {

    }
    global void setApiServiceConnection(Framework.Api.ServiceConnection apiServiceConnectionObj) {

    }
    global void setAuthCodeUrl(String url) {

    }
    global void setFailureLoginRedirect(System.PageReference failurePage) {

    }
    global void setHttpMethodGetToken(String httpMethod) {

    }
    global void setRefreshTokenUrl(String url) {

    }
    global void setSuccessfulLoginRedirect(System.PageReference successPage) {

    }
    global void setTokenUrl(String url) {

    }
global interface AuthConfig {
    String getDefaultValue();
    String getName();
    String getType();
    Boolean isRequired();
}
global enum AuthType {Basic, None, OAuth, OAuth1A, OAuth2}
}
