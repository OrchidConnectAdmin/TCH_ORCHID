/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/ReceiptService/*')
global virtual class ReceiptService extends FDService.ServiceBase implements FDService.IReceiptService {
    global ReceiptService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.ReceiptService getInstance() {
        return null;
    }
    global static FDService.ReceiptService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.Receipt> get(FDService.SearchRequest sr) {
        return null;
    }
    global virtual List<FDService.Receipt> mutate(List<FDService.Receipt> receipts) {
        return null;
    }
}
