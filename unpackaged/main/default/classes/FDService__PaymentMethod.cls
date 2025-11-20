/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PaymentMethod extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global String aPIResponse;
    @AuraEnabled
    global String bankAccountHolderType;
    @AuraEnabled
    global String bankAccountType;
    @AuraEnabled
    global String bankName;
    @AuraEnabled
    global String bankRoutingNumber;
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
    global String cardType;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global String customer;
    @AuraEnabled
    global String customerID;
    @AuraEnabled
    global Id customPaymentMethod;
    @AuraEnabled
    global Id customPaymentType;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global Boolean eligibleForCardUpdater;
    @AuraEnabled
    global String email;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global Date expDate;
    @AuraEnabled
    global String firstSixDigits;
    @AuraEnabled
    global String fullName;
    @AuraEnabled
    global String gatewayToken;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Boolean isDeclined;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isExpired;
    @AuraEnabled
    global Boolean isRestricted;
    @AuraEnabled
    global Boolean isThirdParty;
    @AuraEnabled
    global Boolean isValid;
    @AuraEnabled
    global String lastFourDigits;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global Datetime lastReferencedDate;
    @AuraEnabled
    global Datetime lastViewedDate;
    @AuraEnabled
    global String maskedAccountNumber;
    @AuraEnabled
    global Integer month;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String overrideEdit;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global String paymentMethodToken;
    @AuraEnabled
    global String paymentMethodType;
    @AuraEnabled
    global String phone;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global Integer year;
    global PaymentMethod() {

    }
    global override virtual void fromSObject(SObject PaymentMethodObj) {

    }
    global static FDService.PaymentMethod getInstance() {
        return null;
    }
    global static FDService.PaymentMethod getInstance(OrderApi__Payment_Method__c PaymentMethod) {
        return null;
    }
    global static List<FDService.PaymentMethod> getInstance(List<OrderApi__Payment_Method__c> PaymentMethod) {
        return null;
    }
    global static List<FDService.PaymentMethod> getInstance(List<OrderApi__Payment_Method__c> paymentMethodObjs, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
