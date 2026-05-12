/**
 * Test class for AvalaraResolveAddressTransformer.
 * Covers: request serialization, response deserialization (all fields),
 * null/blank handling, and partial response parsing.
 */
@isTest
private class AvalaraResolveAddressTransformerTest {

    // ─── transformRequest Tests ───

    /**
     * Verifies that transformRequest serializes all populated fields into JSON.
     */
    @isTest
    static void transformRequestSerializesAllFieldsTest() {
        AvalaraResolveAddress.Request addressRequest = buildValidAddressRequest();

        Test.startTest();
        String jsonResult = AvalaraResolveAddressTransformer.transformRequest(addressRequest);
        Test.stopTest();

        Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        System.assertEquals('1600 Pennsylvania Avenue NW', parsedResult.get('line1'), 'line1 should be serialized');
        System.assertEquals('Washington', parsedResult.get('city'), 'city should be serialized');
        System.assertEquals('DC', parsedResult.get('region'), 'region should be serialized');
        System.assertEquals('20500', parsedResult.get('postalCode'), 'postalCode should be serialized');
        System.assertEquals('US', parsedResult.get('country'), 'country should be serialized');
    }

    /**
     * Verifies that transformRequest omits blank fields from JSON.
     */
    @isTest
    static void transformRequestOmitsBlankFieldsTest() {
        AvalaraResolveAddress.Request addressRequest = new AvalaraResolveAddress.Request();
        addressRequest.postalCode = '20500';
        addressRequest.country = 'US';

        Test.startTest();
        String jsonResult = AvalaraResolveAddressTransformer.transformRequest(addressRequest);
        Test.stopTest();

        Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(jsonResult);
        System.assertEquals(false, parsedResult.containsKey('line1'), 'Blank line1 should be omitted');
        System.assertEquals(false, parsedResult.containsKey('city'), 'Blank city should be omitted');
        System.assertEquals('20500', parsedResult.get('postalCode'), 'postalCode should be present');
    }

    /**
     * Verifies that transformRequest throws when request is null.
     */
    @isTest
    static void transformRequestThrowsWhenNullTest() {
        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraResolveAddressTransformer.transformRequest(null);
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('cannot be null'), 'Should indicate null request');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for null request');
    }

    // ─── transformResponse: Valid Address Tests ───

    /**
     * Verifies that transformResponse parses validated address with addressType, line3, and coordinates.
     */
    @isTest
    static void transformResponseParsesValidAddressWithAllFieldsTest() {
        String validResponseJson = buildSuccessResponseJson();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(validResponseJson);
        Test.stopTest();

        System.assertEquals(1, response.validatedAddresses.size(), 'Should have one validated address');

        AvalaraResolveAddress.Address validatedAddress = response.validatedAddresses[0];
        System.assertEquals('StreetOrResidentialAddress', validatedAddress.addressType, 'addressType should be parsed');
        System.assertEquals('1600 PENNSYLVANIA AVE NW', validatedAddress.line1, 'line1 should be normalized');
        System.assertEquals('', validatedAddress.line3, 'line3 should be parsed even if empty');
        System.assertEquals('WASHINGTON', validatedAddress.city, 'city should be normalized');
        System.assertEquals('20500-0005', validatedAddress.postalCode, 'postalCode should include +4');
        System.assertNotEquals(null, validatedAddress.latitude, 'latitude should be present');
    }

    /**
     * Verifies that transformResponse parses the input address echoed back by the API.
     */
    @isTest
    static void transformResponseParsesInputAddressTest() {
        String validResponseJson = buildSuccessResponseJson();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(validResponseJson);
        Test.stopTest();

        System.assertNotEquals(null, response.inputAddress, 'inputAddress should not be null');
        System.assertEquals('1600 Pennsylvania Avenue NW', response.inputAddress.line1, 'Input line1 should match original');
        System.assertEquals('DC', response.inputAddress.region, 'Input region should match original');
    }

    /**
     * Verifies that transformResponse parses top-level coordinates.
     */
    @isTest
    static void transformResponseParsesCoordinatesTest() {
        String validResponseJson = buildSuccessResponseJson();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(validResponseJson);
        Test.stopTest();

        System.assertNotEquals(null, response.coordinates, 'coordinates should not be null');
        System.assertEquals(38.897199, response.coordinates.latitude, 'latitude should match');
        System.assertEquals(-77.036548, response.coordinates.longitude, 'longitude should match');
    }

    /**
     * Verifies that transformResponse parses the resolution quality field.
     */
    @isTest
    static void transformResponseParsesResolutionQualityTest() {
        String validResponseJson = buildSuccessResponseJson();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(validResponseJson);
        Test.stopTest();

        System.assertEquals('Intersection', response.resolutionQuality, 'resolutionQuality should be parsed');
    }

    /**
     * Verifies that transformResponse parses tax authorities.
     */
    @isTest
    static void transformResponseParsesTaxAuthoritiesTest() {
        String validResponseJson = buildSuccessResponseJson();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(validResponseJson);
        Test.stopTest();

        System.assertEquals(2, response.taxAuthorities.size(), 'Should have two tax authorities');

        AvalaraResolveAddress.TaxAuthority countryAuthority = response.taxAuthorities[0];
        System.assertEquals('UNITED STATES', countryAuthority.jurisdictionName, 'First authority should be country');
        System.assertEquals('Country', countryAuthority.jurisdictionType, 'jurisdictionType should be Country');
        System.assertEquals('2001060346', countryAuthority.avalaraId, 'avalaraId should be parsed');

        AvalaraResolveAddress.TaxAuthority stateAuthority = response.taxAuthorities[1];
        System.assertEquals('DISTRICT OF COLUMBIA', stateAuthority.jurisdictionName, 'Second authority should be state');
        System.assertEquals('State', stateAuthority.jurisdictionType, 'jurisdictionType should be State');
    }

    // ─── transformResponse: Error/Warning Tests ───

    /**
     * Verifies that transformResponse parses validation messages with refersTo field.
     */
    @isTest
    static void transformResponseParsesMessagesWithRefersToTest() {
        String errorResponseJson = buildErrorResponseJson();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(errorResponseJson);
        Test.stopTest();

        System.assertEquals(2, response.messages.size(), 'Should have two error messages');

        AvalaraResolveAddress.Message firstMessage = response.messages[0];
        System.assertEquals('Error', firstMessage.severity, 'severity should be Error');
        System.assertEquals('Address', firstMessage.refersTo, 'refersTo should be Address');
        System.assertEquals('Avalara.AvaTax.Common', firstMessage.source, 'source should be parsed');

        AvalaraResolveAddress.Message secondMessage = response.messages[1];
        System.assertEquals('Address.Line0', secondMessage.refersTo, 'refersTo should be Address.Line0');
    }

    /**
     * Verifies that transformResponse parses error response input address and addressType.
     */
    @isTest
    static void transformResponseParsesErrorResponseAddressTypeTest() {
        String errorResponseJson = buildErrorResponseJson();

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(errorResponseJson);
        Test.stopTest();

        System.assertEquals('External', response.resolutionQuality, 'Quality should be External for unresolved');
        System.assertEquals(1, response.validatedAddresses.size(), 'Should echo back the address');
        System.assertEquals('UnknownAddressType', response.validatedAddresses[0].addressType, 'addressType should be Unknown');
    }

    // ─── transformResponse: Edge Cases ───

    /**
     * Verifies that transformResponse handles response with no validated addresses.
     */
    @isTest
    static void transformResponseHandlesNoAddressesTest() {
        String emptyAddressResponse = '{"validatedAddresses":null,"resolutionQuality":"NotCoded","messages":[]}';

        Test.startTest();
        AvalaraResolveAddress.Response response = AvalaraResolveAddressTransformer.transformResponse(emptyAddressResponse);
        Test.stopTest();

        System.assertEquals(0, response.validatedAddresses.size(), 'Should return empty address list');
        System.assertEquals('NotCoded', response.resolutionQuality, 'resolutionQuality should still be parsed');
        System.assertEquals(null, response.inputAddress, 'inputAddress should be null when not present');
        System.assertEquals(null, response.coordinates, 'coordinates should be null when not present');
        System.assertEquals(0, response.taxAuthorities.size(), 'taxAuthorities should be empty when not present');
    }

    /**
     * Verifies that transformResponse throws when body is blank.
     */
    @isTest
    static void transformResponseThrowsWhenBlankTest() {
        Test.startTest();
        Boolean exceptionWasThrown = false;
        try {
            AvalaraResolveAddressTransformer.transformResponse('');
        } catch (AvalaraAuthProviderService.AvalaraException avalaraError) {
            exceptionWasThrown = true;
            System.assert(avalaraError.getMessage().contains('blank'), 'Should indicate blank response');
        }
        Test.stopTest();

        System.assert(exceptionWasThrown, 'Should throw for blank response');
    }

    // ─── Test Data Helpers ───

    /**
     * Builds a valid address request for the White House.
     * @return populated Request with known-good address
     */
    private static AvalaraResolveAddress.Request buildValidAddressRequest() {
        AvalaraResolveAddress.Request addressRequest = new AvalaraResolveAddress.Request();
        addressRequest.line1 = '1600 Pennsylvania Avenue NW';
        addressRequest.city = 'Washington';
        addressRequest.region = 'DC';
        addressRequest.postalCode = '20500';
        addressRequest.country = 'US';
        return addressRequest;
    }

    /**
     * Builds a full success JSON response matching the real Avalara API output.
     * @return JSON string with address, validatedAddresses, coordinates, taxAuthorities
     */
    private static String buildSuccessResponseJson() {
        return '{'
            + '"address":{'
            + '"line1":"1600 Pennsylvania Avenue NW",'
            + '"city":"Washington",'
            + '"region":"DC",'
            + '"country":"US",'
            + '"postalCode":"20500"'
            + '},'
            + '"validatedAddresses":[{'
            + '"addressType":"StreetOrResidentialAddress",'
            + '"line1":"1600 PENNSYLVANIA AVE NW",'
            + '"line2":"",'
            + '"line3":"",'
            + '"city":"WASHINGTON",'
            + '"region":"DC",'
            + '"country":"US",'
            + '"postalCode":"20500-0005",'
            + '"latitude":38.897199,'
            + '"longitude":-77.036548'
            + '}],'
            + '"coordinates":{'
            + '"latitude":38.897199,'
            + '"longitude":-77.036548'
            + '},'
            + '"resolutionQuality":"Intersection",'
            + '"taxAuthorities":['
            + '{"avalaraId":"2001060346","jurisdictionName":"UNITED STATES","jurisdictionType":"Country","signatureCode":"USA0"},'
            + '{"avalaraId":"14","jurisdictionName":"DISTRICT OF COLUMBIA","jurisdictionType":"State","signatureCode":"AKUW"}'
            + ']'
            + '}';
    }

    /**
     * Builds an error JSON response matching the real Avalara API output for invalid addresses.
     * @return JSON string with address, validatedAddresses (echoed), and error messages with refersTo
     */
    private static String buildErrorResponseJson() {
        return '{'
            + '"address":{'
            + '"line1":"999 Fake Street That Does Not Exist",'
            + '"city":"Nowheresville",'
            + '"region":"ZZ",'
            + '"country":"US",'
            + '"postalCode":"00000"'
            + '},'
            + '"validatedAddresses":[{'
            + '"addressType":"UnknownAddressType",'
            + '"line1":"999 Fake Street That Does Not Exist",'
            + '"line2":"",'
            + '"line3":"",'
            + '"city":"Nowheresville",'
            + '"region":"ZZ",'
            + '"country":"US",'
            + '"postalCode":"00000"'
            + '}],'
            + '"resolutionQuality":"External",'
            + '"messages":['
            + '{"summary":"Address not geocoded.","details":"Address cannot be geocoded.","refersTo":"Address","severity":"Error","source":"Avalara.AvaTax.Common"},'
            + '{"summary":"An exact street name match could not be found","details":"An exact street name match could not be found and phonetically matching the street name resulted in either no matches or matches to more than one street name.","refersTo":"Address.Line0","severity":"Error","source":"Avalara.AvaTax.Common"}'
            + ']'
            + '}';
    }
}
