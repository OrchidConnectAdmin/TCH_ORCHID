/**
 * Unified service for Avalara CommitTransaction and VoidTransaction API operations.
 * Both endpoints share the same pattern: path variables + simple JSON body + TransactionModel response.
 * Reuses AvalaraCreateTransaction.Response via AvalaraCreateTransactionTransformer.
*/
public with sharing class AvalaraTransactionStatusService {

    private static final String COMMIT_SERVICE = 'Commit_Transaction';
    private static final String VOID_SERVICE = 'Void_Transaction';

    private class StatusChangeRequest {
        public String serviceName;
        public String companyCode;
        public String transactionCode;
        public String requestJson;
    }

    /**
     * Commits a transaction in Avalara, making it permanent for tax reporting.
     * @param companyCode the Avalara company code (from Avalara_Config__mdt)
     * @param transactionCode the transaction code returned by CreateTransaction (response.code)
     * @return the updated transaction with status 'Committed'
    */
    public static AvalaraCreateTransaction.Response commitTransaction(String companyCode, String transactionCode) {
        StatusChangeRequest changeRequest = new StatusChangeRequest();
        changeRequest.serviceName = COMMIT_SERVICE;
        changeRequest.companyCode = companyCode;
        changeRequest.transactionCode = transactionCode;
        changeRequest.requestJson = JSON.serialize(new Map<String, Boolean>{ 'commit' => true });
        return executeStatusChange(changeRequest);
    }

    /**
     * Voids a transaction in Avalara, cancelling it for tax reporting.
     * @param companyCode the Avalara company code (from Avalara_Config__mdt)
     * @param transactionCode the transaction code returned by CreateTransaction (response.code)
     * @return the updated transaction with status 'Cancelled'
    */
    public static AvalaraCreateTransaction.Response voidTransaction(String companyCode, String transactionCode) {
        StatusChangeRequest changeRequest = new StatusChangeRequest();
        changeRequest.serviceName = VOID_SERVICE;
        changeRequest.companyCode = companyCode;
        changeRequest.transactionCode = transactionCode;
        changeRequest.requestJson = JSON.serialize(new Map<String, String>{ 'code' => 'DocVoided' });
        return executeStatusChange(changeRequest);
    }

    /**
     * Core method: executes a transaction status change (commit or void).
     * Builds the callout request with path variables and body, then parses the response.
    */
    private static AvalaraCreateTransaction.Response executeStatusChange(StatusChangeRequest changeRequest) {

        AvalaraAuthProviderService.AvalaraCalloutRequest calloutRequest = new AvalaraAuthProviderService.AvalaraCalloutRequest();
        calloutRequest.serviceDeveloperName = changeRequest.serviceName;        
        calloutRequest.pathVariables = new Map<String, String>{
            'companyCode' => changeRequest.companyCode,
            'transactionCode' => changeRequest.transactionCode
        };
        calloutRequest.jsonBody = changeRequest.requestJson;

        HttpResponse httpResponse = AvalaraAuthProviderService.executeRequest(calloutRequest);
        return AvalaraCreateTransactionTransformer.transformResponse(httpResponse.getBody());
        
    }


}
