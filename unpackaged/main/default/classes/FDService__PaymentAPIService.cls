/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/PaymentAPIService/*')
global virtual class PaymentAPIService extends FDService.ServiceBase implements FDService.IPaymentAPIService {
    global PaymentAPIService() {

    }
    global virtual FDService.EPayResponse authorize(FDService.EPayRequest api) {
        return null;
    }
    global virtual FDService.EPayResponse cancel(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse capture(FDService.EPayRequest api) {
        return null;
    }
    global virtual FDService.EPayResponse connect() {
        return null;
    }
    global virtual FDService.EPayResponse connect(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse credit(FDService.EPayRequest api) {
        return null;
    }
    global virtual FDService.EPayResponse disconnect(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse generalCredit(FDService.EPayRequest api) {
        return null;
    }
    global virtual FDService.EPayResponse getAccountTransactions() {
        return null;
    }
    global virtual FDService.EPayResponse getGatewayOptions() {
        return null;
    }
    global virtual FDService.EPayResponse getGatewayTransactions(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global static FDService.PaymentAPIService getInstance() {
        return null;
    }
    global static FDService.PaymentAPIService getInstance(String version) {
        return null;
    }
    global virtual FDService.EPayResponse getPaymentMethodTransactions(FDService.EPayRequest ePayRequest) {
        return null;
    }
    @HttpPost
    global static void processTransaction() {

    }
    global virtual FDService.EPayResponse purchase(FDService.EPayRequest api) {
        return null;
    }
    global virtual FDService.EPayResponse read(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse remove(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse savePayMethod(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse updateGateway(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse updatePayMethod(FDService.EPayRequest ePayRequest) {
        return null;
    }
    global virtual FDService.EPayResponse verify(FDService.EPayRequest ePayRequest) {
        return null;
    }
}
