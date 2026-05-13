/**
 * Transformer for the Avalara CreateTransaction API operation.
 * Converts between AvalaraCreateTransaction inner classes and JSON payloads.
 * Handles request serialization and response deserialization.
 */
public with sharing class AvalaraCreateTransactionTransformer {

    /**
     * Transforms a CreateTransaction Request into a JSON string for the API callout.
     * @param transactionRequest the tax calculation request data
     * @return JSON string representation of the request
     */
    public static String transformRequest(AvalaraCreateTransaction.Request transactionRequest) {
        if (transactionRequest == null) {
            throw new AvalaraAuthProviderService.AvalaraException('Transaction request cannot be null.');
        }

        Map<String, Object> requestPayload = buildRequestPayload(transactionRequest);
        return JSON.serialize(requestPayload);
    }

    /**
     * Transforms a JSON response string from the API into a CreateTransaction Response.
     * @param jsonResponseBody the raw JSON response body from the Avalara API
     * @return parsed Response with transaction details and line-level tax data
     */
    public static AvalaraCreateTransaction.Response transformResponse(String jsonResponseBody) {
        if (String.isBlank(jsonResponseBody)) {
            throw new AvalaraAuthProviderService.AvalaraException('Transaction response body is blank.');
        }

        Map<String, Object> rawResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonResponseBody);
        return buildResponseFromRawMap(rawResponse);
    }

    // ─── Request Building ───

    /**
     * Builds the top-level request payload map.
     * @param transactionRequest the source request data
     * @return map of field names to values
     */
    private static Map<String, Object> buildRequestPayload(AvalaraCreateTransaction.Request transactionRequest) {
        Map<String, Object> payload = new Map<String, Object>();

        payload.put('companyCode', transactionRequest.companyCode);
        payload.put('type', transactionRequest.type);
        payload.put('date', transactionRequest.transactionDate);
        payload.put('customerCode', transactionRequest.customerCode);

        addIfNotBlank(payload, 'currencyCode', transactionRequest.currencyCode);
        addIfNotBlank(payload, 'exemptionNo', transactionRequest.exemptionNo);
        addIfNotBlank(payload, 'customerUsageType', transactionRequest.customerUsageType);

        if (transactionRequest.commitTransaction != null) {
            payload.put('commit', transactionRequest.commitTransaction);
        }

        payload.put('addresses', buildAddressesPayload(transactionRequest));
        payload.put('lines', buildLinesPayload(transactionRequest.lineItems));

        return payload;
    }

    /**
     * Builds the addresses object with shipFrom and shipTo.
     * @param transactionRequest the source request containing both addresses
     * @return map with 'shipFrom' and 'shipTo' address maps
     */
    private static Map<String, Object> buildAddressesPayload(AvalaraCreateTransaction.Request transactionRequest) {
        Map<String, Object> addresses = new Map<String, Object>();

        if (transactionRequest.shipFromAddress != null) {
            addresses.put('shipFrom', buildSingleAddressPayload(transactionRequest.shipFromAddress));
        }
        if (transactionRequest.shipToAddress != null) {
            addresses.put('shipTo', buildSingleAddressPayload(transactionRequest.shipToAddress));
        }

        return addresses;
    }

    /**
     * Builds a single address map from an Address object.
     * @param address the source address data
     * @return map of address field names to values
     */
    private static Map<String, Object> buildSingleAddressPayload(AvalaraCreateTransaction.Address address) {
        Map<String, Object> addressMap = new Map<String, Object>();

        addIfNotBlank(addressMap, 'line1', address.line1);
        addIfNotBlank(addressMap, 'line2', address.line2);
        addIfNotBlank(addressMap, 'city', address.city);
        addIfNotBlank(addressMap, 'region', address.region);
        addIfNotBlank(addressMap, 'postalCode', address.postalCode);
        addIfNotBlank(addressMap, 'country', address.country);

        return addressMap;
    }

    /**
     * Builds the lines array from a list of LineItem objects.
     * @param lineItems the source line items
     * @return list of line item maps
     */
    private static List<Map<String, Object>> buildLinesPayload(List<AvalaraCreateTransaction.LineItem> lineItems) {
        List<Map<String, Object>> lines = new List<Map<String, Object>>();

        if (lineItems == null) {
            return lines;
        }

        for (AvalaraCreateTransaction.LineItem lineItem : lineItems) {
            lines.add(buildSingleLinePayload(lineItem));
        }

        return lines;
    }

    /**
     * Builds a single line item map from a LineItem object.
     * @param lineItem the source line item data
     * @return map of line field names to values
     */
    private static Map<String, Object> buildSingleLinePayload(AvalaraCreateTransaction.LineItem lineItem) {
        Map<String, Object> lineMap = new Map<String, Object>();

        addIfNotBlank(lineMap, 'number', lineItem.number_x);
        addIfNotBlank(lineMap, 'itemCode', lineItem.itemCode);
        addIfNotBlank(lineMap, 'taxCode', lineItem.taxCode);
        addIfNotBlank(lineMap, 'description', lineItem.description);

        if (lineItem.quantity != null) {
            lineMap.put('quantity', lineItem.quantity);
        }
        if (lineItem.amount != null) {
            lineMap.put('amount', lineItem.amount);
        }

        return lineMap;
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

    // ─── Response Building ───

    /**
     * Builds a Response object from the raw deserialized JSON map.
     * @param rawResponse the deserialized JSON map from the API
     * @return populated Response object
     */
    private static AvalaraCreateTransaction.Response buildResponseFromRawMap(Map<String, Object> rawResponse) {
        AvalaraCreateTransaction.Response response = new AvalaraCreateTransaction.Response();

        response.id = (Long) rawResponse.get('id');
        response.code = (String) rawResponse.get('code');
        response.companyCode = (String) rawResponse.get('companyCode');
        response.date_x = (String) rawResponse.get('date');
        response.status = (String) rawResponse.get('status');
        response.type = (String) rawResponse.get('type');
        response.customerCode = (String) rawResponse.get('customerVendorCode');
        response.totalTax = (Decimal) rawResponse.get('totalTax');
        response.totalTaxable = (Decimal) rawResponse.get('totalTaxable');
        response.totalAmount = (Decimal) rawResponse.get('totalAmount');
        response.totalExempt = (Decimal) rawResponse.get('totalExempt');
        response.totalDiscount = (Decimal) rawResponse.get('totalDiscount');
        response.lines = buildResponseLinesFromRaw(rawResponse);

        return response;
    }

    /**
     * Extracts and builds the list of response lines from the raw response.
     * @param rawResponse the deserialized JSON map
     * @return list of ResponseLine objects, empty list if none present
     */
    private static List<AvalaraCreateTransaction.ResponseLine> buildResponseLinesFromRaw(Map<String, Object> rawResponse) {
        List<AvalaraCreateTransaction.ResponseLine> responseLines = new List<AvalaraCreateTransaction.ResponseLine>();

        List<Object> rawLines = (List<Object>) rawResponse.get('lines');
        if (rawLines == null) {
            return responseLines;
        }

        for (Object rawLine : rawLines) {
            responseLines.add(buildSingleResponseLineFromRaw((Map<String, Object>) rawLine));
        }

        return responseLines;
    }

    /**
     * Builds a single ResponseLine from a raw line map.
     * @param rawLine the deserialized line map
     * @return populated ResponseLine object
     */
    private static AvalaraCreateTransaction.ResponseLine buildSingleResponseLineFromRaw(Map<String, Object> rawLine) {
        AvalaraCreateTransaction.ResponseLine responseLine = new AvalaraCreateTransaction.ResponseLine();

        responseLine.number_x = (String) rawLine.get('lineNumber');
        responseLine.tax = (Decimal) rawLine.get('tax');
        responseLine.taxableAmount = (Decimal) rawLine.get('taxableAmount');
        responseLine.taxCalculated = (Decimal) rawLine.get('taxCalculated');
        responseLine.lineAmount = (Decimal) rawLine.get('lineAmount');
        responseLine.rate = (Decimal) rawLine.get('rate');
        responseLine.itemCode = (String) rawLine.get('itemCode');
        responseLine.taxCode = (String) rawLine.get('taxCode');
        responseLine.isItemTaxable = (Boolean) rawLine.get('isItemTaxable');
        responseLine.details = buildTaxDetailsFromRaw(rawLine);

        return responseLine;
    }

    /**
     * Extracts and builds the list of tax details from a raw line map.
     * @param rawLine the deserialized line map containing 'details' array
     * @return list of TaxDetail objects, empty list if none present
     */
    private static List<AvalaraCreateTransaction.TaxDetail> buildTaxDetailsFromRaw(Map<String, Object> rawLine) {
        List<AvalaraCreateTransaction.TaxDetail> taxDetails = new List<AvalaraCreateTransaction.TaxDetail>();

        List<Object> rawDetails = (List<Object>) rawLine.get('details');
        if (rawDetails == null) {
            return taxDetails;
        }

        for (Object rawDetail : rawDetails) {
            taxDetails.add(buildSingleTaxDetailFromRaw((Map<String, Object>) rawDetail));
        }

        return taxDetails;
    }

    /**
     * Builds a single TaxDetail from a raw detail map.
     * @param rawDetail the deserialized tax detail map
     * @return populated TaxDetail object
     */
    private static AvalaraCreateTransaction.TaxDetail buildSingleTaxDetailFromRaw(Map<String, Object> rawDetail) {
        AvalaraCreateTransaction.TaxDetail taxDetail = new AvalaraCreateTransaction.TaxDetail();

        taxDetail.jurisName = (String) rawDetail.get('jurisName');
        taxDetail.jurisType = (String) rawDetail.get('jurisType');
        taxDetail.rate = (Decimal) rawDetail.get('rate');
        taxDetail.tax = (Decimal) rawDetail.get('tax');
        taxDetail.taxableAmount = (Decimal) rawDetail.get('taxableAmount');
        taxDetail.taxName = (String) rawDetail.get('taxName');

        return taxDetail;
    }
}
