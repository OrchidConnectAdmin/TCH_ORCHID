/**
 * Service for the Avalara CreateTransaction API operation.
 * Orchestrates the tax calculation flow: transforms the request,
 * calls the Avalara API via AvalaraAuthProviderService, and transforms the response.
 */
public with sharing class AvalaraCreateTransactionService {

    private static final String SERVICE_DEVELOPER_NAME = 'Create_Transaction';

    /**
     * Creates a tax transaction in Avalara (SalesOrder estimate or SalesInvoice permanent).
     * Returns the calculated tax per line and total, with jurisdiction breakdown.
     * @param transactionRequest the transaction data including addresses, lines, and document type
     * @return the transaction response with tax calculations and status
     */
    public static AvalaraCreateTransaction.Response execute(AvalaraCreateTransaction.Request transactionRequest) {
        String requestJson = AvalaraCreateTransactionTransformer.transformRequest(transactionRequest);
        HttpResponse httpResponse = AvalaraAuthProviderService.executeWithBody(SERVICE_DEVELOPER_NAME, requestJson);
        return AvalaraCreateTransactionTransformer.transformResponse(httpResponse.getBody());
    }
}
