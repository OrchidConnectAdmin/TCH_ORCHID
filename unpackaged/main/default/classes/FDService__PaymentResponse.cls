/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PaymentResponse extends FDService.WrapperBase {
    @AuraEnabled
    global String checkoutForm;
    @AuraEnabled
    global String checkoutUrl;
    @AuraEnabled
    global String epaymentId;
    @AuraEnabled
    global String errorMessage;
    @AuraEnabled
    global String receiptId;
    global PaymentResponse() {

    }
    global override virtual void fromSObject(SObject itemObj) {

    }
    global static FDService.PaymentResponse getInstance() {
        return null;
    }
}
