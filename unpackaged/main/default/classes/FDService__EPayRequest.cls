/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class EPayRequest extends FDService.WrapperBase {
    @AuraEnabled
    global Integer amount;
    @AuraEnabled
    global Boolean attempt3ds;
    @AuraEnabled
    global Id batch;
    @AuraEnabled
    global Id contactId;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Id customerId;
    @AuraEnabled
    global Id customPaymentId;
    @AuraEnabled
    global String depositAccount;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global List<FDService.EPayRequest.Element> elements;
    @AuraEnabled
    global String email;
    @AuraEnabled
    global FDService.PaymentGateway gateway;
    @AuraEnabled
    global String ip;
    @AuraEnabled
    global String merchantLocationDescriptor;
    @AuraEnabled
    global String merchantNameDescriptor;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global List<FDService.EPayRequest.RequestObject> objects;
    @AuraEnabled
    global String orderId;
    @AuraEnabled
    global String overridePaymentMethod;
    @AuraEnabled
    global Map<String,String> pageParams;
    @AuraEnabled
    global Id paymentGateway;
    @AuraEnabled
    global FDService.PaymentMethod paymentMethod;
    @AuraEnabled
    global String paymentMethodId;
    @AuraEnabled
    global String paymentMethodToken;
    @AuraEnabled
    global Id paymentObjId;
    @AuraEnabled
    global String redirectUrl;
    @AuraEnabled
    global String requestBody;
    @AuraEnabled
    global Boolean retainOnSuccess;
    @AuraEnabled
    global Boolean savePaymentMethod;
    @AuraEnabled
    global String token;
    @AuraEnabled
    global String transaction_token;
    @AuraEnabled
    global String transactionToken;
    @AuraEnabled
    global String type;
    global EPayRequest() {

    }
    global override virtual void fromSObject(SObject itemObj) {

    }
    global static FDService.EPayRequest getInstance() {
        return null;
    }
global class Element {
    @AuraEnabled
    global String key;
    @AuraEnabled
    global String value;
    global Element(String key, String value) {

    }
}
global class RequestObject {
    @AuraEnabled
    global List<FDService.EPayRequest.Element> elements;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global FDService.EPayRequest.RequestObject reqObject;
    global RequestObject() {

    }
}
}
