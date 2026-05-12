/**
 * Transformer for the Avalara ResolveAddress API operation.
 * Converts between AvalaraResolveAddress inner classes and JSON payloads.
 * Handles request serialization and response deserialization.
 */
public with sharing class AvalaraResolveAddressTransformer {

    /**
     * Transforms a ResolveAddress Request into a JSON string for the API callout.
     * @param addressRequest the address validation request data
     * @return JSON string representation of the request
     */
    public static String transformRequest(AvalaraResolveAddress.Request addressRequest) {
        if (addressRequest == null) {
            throw new AvalaraAuthProviderService.AvalaraException('Address request cannot be null.');
        }

        Map<String, Object> requestPayload = buildRequestPayload(addressRequest);
        return JSON.serialize(requestPayload);
    }

    /**
     * Transforms a JSON response string from the API into a ResolveAddress Response.
     * @param jsonResponseBody the raw JSON response body from the Avalara API
     * @return parsed Response with all address resolution data
     */
    public static AvalaraResolveAddress.Response transformResponse(String jsonResponseBody) {
        if (String.isBlank(jsonResponseBody)) {
            throw new AvalaraAuthProviderService.AvalaraException('Address response body is blank.');
        }

        Map<String, Object> rawResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonResponseBody);
        return buildResponseFromRawMap(rawResponse);
    }

    /**
     * Builds the request payload map from the Request object.
     * Only includes non-blank fields to keep the payload clean.
     * @param addressRequest the source request data
     * @return map of field names to values
     */
    private static Map<String, Object> buildRequestPayload(AvalaraResolveAddress.Request addressRequest) {
        Map<String, Object> payload = new Map<String, Object>();

        addIfNotBlank(payload, 'line1', addressRequest.line1);
        addIfNotBlank(payload, 'line2', addressRequest.line2);
        addIfNotBlank(payload, 'city', addressRequest.city);
        addIfNotBlank(payload, 'region', addressRequest.region);
        addIfNotBlank(payload, 'postalCode', addressRequest.postalCode);
        addIfNotBlank(payload, 'country', addressRequest.country);
        addIfNotBlank(payload, 'textCase', addressRequest.textCase);

        return payload;
    }

    /**
     * Adds a key-value pair to the map only if the value is not blank.
     * @param targetMap the map to add to
     * @param fieldName the JSON field name
     * @param fieldValue the value to add
     */
    private static void addIfNotBlank(Map<String, Object> targetMap, String fieldName, String fieldValue) {
        if (String.isNotBlank(fieldValue)) {
            targetMap.put(fieldName, fieldValue);
        }
    }

    /**
     * Builds a Response object from the raw deserialized JSON map.
     * @param rawResponse the deserialized JSON map from the API
     * @return populated Response object
     */
    private static AvalaraResolveAddress.Response buildResponseFromRawMap(Map<String, Object> rawResponse) {
        AvalaraResolveAddress.Response response = new AvalaraResolveAddress.Response();
        response.resolutionQuality = (String) rawResponse.get('resolutionQuality');
        response.inputAddress = buildAddressFromRaw((Map<String, Object>) rawResponse.get('address'));
        response.validatedAddresses = buildAddressListFromRaw(rawResponse);
        response.coordinates = buildCoordinatesFromRaw((Map<String, Object>) rawResponse.get('coordinates'));
        response.taxAuthorities = buildTaxAuthorityListFromRaw(rawResponse);
        response.messages = buildMessageListFromRaw(rawResponse);
        return response;
    }

    /**
     * Builds an Address object from a raw address map. Returns null if the map is null.
     * @param rawAddress the deserialized address map
     * @return populated Address object or null
     */
    private static AvalaraResolveAddress.Address buildAddressFromRaw(Map<String, Object> rawAddress) {
        if (rawAddress == null) {
            return null;
        }

        AvalaraResolveAddress.Address address = new AvalaraResolveAddress.Address();
        address.addressType = (String) rawAddress.get('addressType');
        address.line1 = (String) rawAddress.get('line1');
        address.line2 = (String) rawAddress.get('line2');
        address.line3 = (String) rawAddress.get('line3');
        address.city = (String) rawAddress.get('city');
        address.region = (String) rawAddress.get('region');
        address.postalCode = (String) rawAddress.get('postalCode');
        address.country = (String) rawAddress.get('country');
        address.latitude = (Decimal) rawAddress.get('latitude');
        address.longitude = (Decimal) rawAddress.get('longitude');
        return address;
    }

    /**
     * Extracts and builds the list of validated addresses from the raw response.
     * @param rawResponse the deserialized JSON map
     * @return list of Address objects, empty list if none present
     */
    private static List<AvalaraResolveAddress.Address> buildAddressListFromRaw(Map<String, Object> rawResponse) {
        List<AvalaraResolveAddress.Address> addresses = new List<AvalaraResolveAddress.Address>();

        List<Object> rawAddresses = (List<Object>) rawResponse.get('validatedAddresses');
        if (rawAddresses == null) {
            return addresses;
        }

        for (Object rawAddress : rawAddresses) {
            addresses.add(buildAddressFromRaw((Map<String, Object>) rawAddress));
        }
        return addresses;
    }

    /**
     * Builds a Coordinates object from a raw coordinates map. Returns null if the map is null.
     * @param rawCoordinates the deserialized coordinates map
     * @return populated Coordinates object or null
     */
    private static AvalaraResolveAddress.Coordinates buildCoordinatesFromRaw(Map<String, Object> rawCoordinates) {
        if (rawCoordinates == null) {
            return null;
        }

        AvalaraResolveAddress.Coordinates coordinates = new AvalaraResolveAddress.Coordinates();
        coordinates.latitude = (Decimal) rawCoordinates.get('latitude');
        coordinates.longitude = (Decimal) rawCoordinates.get('longitude');
        return coordinates;
    }

    /**
     * Extracts and builds the list of tax authorities from the raw response.
     * @param rawResponse the deserialized JSON map
     * @return list of TaxAuthority objects, empty list if none present
     */
    private static List<AvalaraResolveAddress.TaxAuthority> buildTaxAuthorityListFromRaw(Map<String, Object> rawResponse) {
        List<AvalaraResolveAddress.TaxAuthority> taxAuthorities = new List<AvalaraResolveAddress.TaxAuthority>();

        List<Object> rawAuthorities = (List<Object>) rawResponse.get('taxAuthorities');
        if (rawAuthorities == null) {
            return taxAuthorities;
        }

        for (Object rawAuthority : rawAuthorities) {
            taxAuthorities.add(buildSingleTaxAuthorityFromRaw((Map<String, Object>) rawAuthority));
        }
        return taxAuthorities;
    }

    /**
     * Builds a single TaxAuthority object from a raw authority map.
     * @param rawAuthority the deserialized tax authority map
     * @return populated TaxAuthority object
     */
    private static AvalaraResolveAddress.TaxAuthority buildSingleTaxAuthorityFromRaw(Map<String, Object> rawAuthority) {
        AvalaraResolveAddress.TaxAuthority taxAuthority = new AvalaraResolveAddress.TaxAuthority();
        taxAuthority.avalaraId = (String) rawAuthority.get('avalaraId');
        taxAuthority.jurisdictionName = (String) rawAuthority.get('jurisdictionName');
        taxAuthority.jurisdictionType = (String) rawAuthority.get('jurisdictionType');
        taxAuthority.signatureCode = (String) rawAuthority.get('signatureCode');
        return taxAuthority;
    }

    /**
     * Extracts and builds the list of validation messages from the raw response.
     * @param rawResponse the deserialized JSON map
     * @return list of Message objects, empty list if none present
     */
    private static List<AvalaraResolveAddress.Message> buildMessageListFromRaw(Map<String, Object> rawResponse) {
        List<AvalaraResolveAddress.Message> messages = new List<AvalaraResolveAddress.Message>();

        List<Object> rawMessages = (List<Object>) rawResponse.get('messages');
        if (rawMessages == null) {
            return messages;
        }

        for (Object rawMessage : rawMessages) {
            messages.add(buildSingleMessageFromRaw((Map<String, Object>) rawMessage));
        }
        return messages;
    }

    /**
     * Builds a single Message object from a raw message map.
     * @param rawMessage the deserialized message map
     * @return populated Message object
     */
    private static AvalaraResolveAddress.Message buildSingleMessageFromRaw(Map<String, Object> rawMessage) {
        AvalaraResolveAddress.Message message = new AvalaraResolveAddress.Message();
        message.summary = (String) rawMessage.get('summary');
        message.details = (String) rawMessage.get('details');
        message.refersTo = (String) rawMessage.get('refersTo');
        message.severity = (String) rawMessage.get('severity');
        message.source = (String) rawMessage.get('source');
        return message;
    }
}
