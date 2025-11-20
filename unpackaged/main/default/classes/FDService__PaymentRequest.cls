/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PaymentRequest extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global Id batch;
    @AuraEnabled
    global String billingCity;
    @AuraEnabled
    global String billingCountry;
    @AuraEnabled
    global String billingPostalCode;
    @AuraEnabled
    global String billingState;
    @AuraEnabled
    global String billingStreet;
    @AuraEnabled
    global String cardholderName;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Id customer;
    @AuraEnabled
    global Id depositAccount;
    @AuraEnabled
    global String gatewayToken;
    @AuraEnabled
    global String memo;
    @AuraEnabled
    global Boolean offline;
    @AuraEnabled
    global List<FDService.WrapperBase> orders;
    @AuraEnabled
    global Id overridePaymentMethod;
    @AuraEnabled
    global Map<String,String> pageParams;
    @AuraEnabled
    global Date paymentDate;
    @AuraEnabled
    global Id paymentGateway;
    @AuraEnabled
    global Id paymentMethod;
    @AuraEnabled
    global String paymentMethodToken;
    @AuraEnabled
    global String paymentType;
    @AuraEnabled
    global Date postedDate;
    @AuraEnabled
    global Id record;
    @AuraEnabled
    global String redirectUrl;
    @AuraEnabled
    global String referenceNumber;
    @AuraEnabled
    global Boolean savePaymentMethod;
    global PaymentRequest() {

    }
    global override virtual void fromSObject(SObject itemObj) {

    }
    global static FDService.PaymentRequest getInstance() {
        return null;
    }
}
