/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class EPayResponse extends FDService.WrapperBase {
    global List<FDService.Error> errors;
    global Map<String,String> gateway_specific_fields;
    global Map<String,String> gateway_specific_response_fields;
    global List<FDService.EPayTransaction.Gateway> gateways;
    global Integer http_status_code;
    global String http_status_message;
    global List<FDService.EPayTransaction.PaymentMethod> payment_methods;
    global List<FDService.EPayTransaction> transactions;
    global EPayResponse() {

    }
    global override virtual void fromSObject(SObject itemObj) {

    }
    global static FDService.EPayResponse getInstance() {
        return null;
    }
}
