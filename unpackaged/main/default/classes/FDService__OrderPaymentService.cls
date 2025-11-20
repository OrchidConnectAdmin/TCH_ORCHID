/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/OrderPaymentService/*')
global virtual class OrderPaymentService extends FDService.ServiceBase implements FDService.IOrderPaymentService {
    global OrderPaymentService() {

    }
    global static FDService.OrderPaymentService getInstance() {
        return null;
    }
    global static FDService.OrderPaymentService getInstance(String version) {
        return null;
    }
    global virtual FDService.OrderPaymentService getSuper() {
        return null;
    }
    global virtual FDService.PaymentResponse pay(FDService.PaymentRequest request) {
        return null;
    }
    @HttpPost
    global static void pay() {

    }
}
