/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/TransactionService/*')
global virtual class TransactionService extends FDService.ServiceBase implements FDService.ITransactionService {
    global TransactionService() {

    }
    global virtual List<FDService.TransactionRecord> create(List<FDService.TransactionRecord> transactionRecords) {
        return null;
    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.TransactionService getInstance() {
        return null;
    }
    global static FDService.TransactionService getInstance(String version) {
        return null;
    }
    global FDService.TransactionService getSuper() {
        return null;
    }
    global virtual List<FDService.TransactionRecord> get(FDService.SearchRequest sr) {
        return null;
    }
    @Deprecated
    global virtual List<FDService.TransactionRecord> mutate(List<FDService.TransactionRecord> transactionRecords) {
        return null;
    }
    @HttpPost
    global static void postApiResponse() {

    }
    @HttpPut
    global static void putApiResponse() {

    }
}
