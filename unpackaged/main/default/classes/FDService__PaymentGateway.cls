/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PaymentGateway extends FDService.WrapperBase {
    @AuraEnabled
    global Boolean attempt3DS;
    @AuraEnabled
    global String aVSConfiguration;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global String companyName;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Id depositAccount;
    @AuraEnabled
    global Boolean enableAVS;
    @AuraEnabled
    global Boolean enableAVSZipCodeOnly;
    @AuraEnabled
    global String gatewaySpecificFields;
    @AuraEnabled
    global String gatewayType;
    @AuraEnabled
    global String homepage;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isEnabled;
    @AuraEnabled
    global Boolean isOffsite;
    @AuraEnabled
    global Boolean isTest;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global Boolean postOrdersInProcesing;
    @AuraEnabled
    global Boolean preAuthorizationPurchases;
    @AuraEnabled
    global Boolean requireCVV;
    @AuraEnabled
    global Boolean requireEmail;
    @AuraEnabled
    global Boolean requirePhone;
    @AuraEnabled
    global String state;
    @AuraEnabled
    global String supportedCountries;
    @AuraEnabled
    global String supportedCreditCardsImage;
    @AuraEnabled
    global String supportedRegions;
    @AuraEnabled
    global Boolean supports3DSPurchase;
    @AuraEnabled
    global Boolean supportsAuthorize;
    @AuraEnabled
    global Boolean supportsCapture;
    @AuraEnabled
    global Boolean supportsCredit;
    @AuraEnabled
    global Boolean supportsCreditCard;
    @AuraEnabled
    global Boolean supportsECheck;
    @AuraEnabled
    global Boolean supportsEFT;
    @AuraEnabled
    global Boolean supportsOffsiteAuthorize;
    @AuraEnabled
    global Boolean supportsVerify;
    @AuraEnabled
    global Boolean supportsVoid;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global String token;
    @AuraEnabled
    global Boolean useOffsite;
    global PaymentGateway() {

    }
    global override void fromSObject(SObject PaymentGatewayObj) {

    }
    global static FDService.PaymentGateway getInstance() {
        return null;
    }
    global static FDService.PaymentGateway getInstance(OrderApi__Payment_Gateway__c PaymentGateway) {
        return null;
    }
    global static List<FDService.PaymentGateway> getInstance(List<OrderApi__Payment_Gateway__c> PaymentGateway) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
