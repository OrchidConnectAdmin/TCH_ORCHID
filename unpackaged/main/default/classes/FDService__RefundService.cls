/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/RefundService/*')
global virtual class RefundService extends FDService.ServiceBase implements FDService.IRefundService, FDService.IRefundService2 {
    global RefundService() {

    }
    @HttpPost
    global static void apiPost() {

    }
    global virtual List<FDService.Receipt> createRefund(List<FDService.Receipt> receipts) {
        return null;
    }
    global static FDService.RefundService getInstance() {
        return null;
    }
    global static FDService.RefundService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.Receipt> processRefund(FDService.SearchRequest sr) {
        return null;
    }
    global virtual List<FDService.Receipt> processRefund(List<FDService.Receipt> refunds) {
        return null;
    }
}
