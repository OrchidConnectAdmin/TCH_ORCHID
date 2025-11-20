global without sharing class FON_CreateOrganizationController {
    @AuraEnabled
    public static Object createOrganization(String body) {
        String endpoint = 'callout:TCH_Sandbox/services/data/v49.0/sobjects/Account';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('content-type', 'application/json');
        request.setBody(body);

        Http http = new Http();
        HttpResponse response = http.send(request);
        return JSON.deserializeUntyped(response.getBody());
    }
}