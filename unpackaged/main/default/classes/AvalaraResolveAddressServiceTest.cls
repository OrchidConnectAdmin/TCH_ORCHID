/**
 * Test class for AvalaraResolveAddressService.
 * Covers: end-to-end address validation flow with HttpCalloutMock,
 * verifying the Service orchestrates Transformer and AuthProviderService correctly.
*/
@isTest
private class AvalaraResolveAddressServiceTest {

    // ─── Mock Implementations ───

    /**
     * Mock that returns a successful ResolveAddress response matching real Avalara output.
    */
    private class ResolveAddressSuccessMock implements HttpCalloutMock {
        /** Responds with a 200 and a full resolved address JSON with all fields.*/
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"address":{"line1":"1600 Pennsylvania Avenue NW","city":"Washington","region":"DC","country":"US","postalCode":"20500"},'
                + '"validatedAddresses":[{"addressType":"StreetOrResidentialAddress","line1":"1600 PENNSYLVANIA AVE NW","line2":"","line3":"","city":"WASHINGTON","region":"DC","country":"US","postalCode":"20500-0005","latitude":38.897199,"longitude":-77.036548}],'
                + '"coordinates":{"latitude":38.897199,"longitude":-77.036548},'
                + '"resolutionQuality":"Intersection",'
                + '"taxAuthorities":[{"avalaraId":"2001060346","jurisdictionName":"UNITED STATES","jurisdictionType":"Country","signatureCode":"USA0"},{"avalaraId":"14","jurisdictionName":"DISTRICT OF COLUMBIA","jurisdictionType":"State","signatureCode":"AKUW"}]'
                + '}');
            return response;
        }
    }

    /**
     * Mock that returns an error response matching real Avalara output for invalid addresses.
    */
    private class ResolveAddressWithErrorsMock implements HttpCalloutMock {
        /** Responds with a 200 and error messages for an unresolvable address.*/
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"address":{"line1":"999 Fake Street","city":"Nowheresville","region":"ZZ","country":"US","postalCode":"00000"},'
                + '"validatedAddresses":[{"addressType":"UnknownAddressType","line1":"999 Fake Street","line2":"","line3":"","city":"Nowheresville","region":"ZZ","country":"US","postalCode":"00000"}],'
                + '"resolutionQuality":"External",'
                + '"messages":[{"summary":"Address not geocoded.","details":"Address cannot be geocoded.","refersTo":"Address","severity":"Error","source":"Avalara.AvaTax.Common"}]'
                + '}');
            return response;
        }
    }

    // ─── execute Tests ───

    /**
     * Verifies that execute returns a fully populated response for a valid address.
    */
    @isTest
    static void executeWithValidAddressReturnsFullResponseTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new ResolveAddressSuccessMock());

        AvalaraResolveAddress.Request addressRequest = buildWhiteHouseAddressRequest();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressService.execute(addressRequest);
        Test.stopTest();

        System.assertEquals('Intersection', response.resolutionQuality, 'Quality should be Intersection');
        System.assertEquals(1, response.validatedAddresses.size(), 'Should have one validated address');
        System.assertEquals('StreetOrResidentialAddress', response.validatedAddresses[0].addressType, 'addressType should be parsed');
        System.assertNotEquals(null, response.inputAddress, 'inputAddress should be present');
        System.assertNotEquals(null, response.coordinates, 'coordinates should be present');
        System.assertEquals(2, response.taxAuthorities.size(), 'Should have two tax authorities');
        System.assertEquals(0, response.messages.size(), 'Should have no messages for valid address');
    }

    /**
     * Verifies that execute returns error messages with refersTo for an invalid address.
    */
    @isTest
    static void executeWithInvalidAddressReturnsErrorsTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new ResolveAddressWithErrorsMock());

        AvalaraResolveAddress.Request addressRequest = buildInvalidAddressRequest();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressService.execute(addressRequest);
        Test.stopTest();

        System.assertEquals('External', response.resolutionQuality, 'Quality should be External');
        System.assertEquals('UnknownAddressType', response.validatedAddresses[0].addressType, 'addressType should be Unknown');
        System.assertEquals(1, response.messages.size(), 'Should have one error message');
        System.assertEquals('Error', response.messages[0].severity, 'Message should be an error');
        System.assertEquals('Address', response.messages[0].refersTo, 'refersTo should be parsed');
    }

    // ─── Test Data Helpers ───

    /**
     * Builds a request for the White House address (known-good).
     * @return populated Request
    */
    private static AvalaraResolveAddress.Request buildWhiteHouseAddressRequest() {
        AvalaraResolveAddress.Request addressRequest = new AvalaraResolveAddress.Request();
        addressRequest.line1 = '1600 Pennsylvania Avenue NW';
        addressRequest.city = 'Washington';
        addressRequest.region = 'DC';
        addressRequest.postalCode = '20500';
        addressRequest.country = 'US';
        return addressRequest;
    }

    /**
     * Builds a request for an invalid address.
     * @return populated Request with fake address data
    */
    private static AvalaraResolveAddress.Request buildInvalidAddressRequest() {
        AvalaraResolveAddress.Request addressRequest = new AvalaraResolveAddress.Request();
        addressRequest.line1 = '999 Fake Street That Does Not Exist';
        addressRequest.city = 'Nowheresville';
        addressRequest.region = 'ZZ';
        addressRequest.postalCode = '00000';
        addressRequest.country = 'US';
        return addressRequest;
    }
}
