/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/PaymentCallbackService/*')
global virtual class PaymentCallbackService extends FDService.ServiceBase implements FDService.IPaymentCallbackService {
    global PaymentCallbackService() {

    }
    global virtual FDService.EPayment createEPayment(FDService.EPayRequest ePayRequest) {
        return null;
    }
    @HttpPost
    global static void createEPayment() {

    }
    global static FDService.PaymentCallbackService getInstance() {
        return null;
    }
    global static FDService.PaymentCallbackService getInstance(String version) {
        return null;
    }
}
