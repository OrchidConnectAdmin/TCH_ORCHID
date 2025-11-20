/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/PaymentMethodService/*')
global virtual class PaymentMethodService extends FDService.ServiceBase implements FDService.IPaymentMethodService {
    global PaymentMethodService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    @Deprecated
    global List<FDService.PaymentMethod> getContactPaymentMethods(Set<Id> contactIds) {
        return null;
    }
    global static FDService.PaymentMethodService getInstance() {
        return null;
    }
    global static FDService.PaymentMethodService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.PaymentMethod> get(FDService.SearchRequest sr) {
        return null;
    }
    global virtual FDService.PaymentMethod mapPaymentMethod(FDService.EPayTransaction.PaymentMethod paymentMethodWrapper) {
        return null;
    }
    global virtual List<FDService.PaymentMethod> mutate(List<FDService.PaymentMethod> methods) {
        return null;
    }
}
