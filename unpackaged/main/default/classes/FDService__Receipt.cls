/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Receipt extends FDService.WrapperBase {
    @AuraEnabled
    global String actionInformation;
    @AuraEnabled
    global Decimal appliedAmount;
    @AuraEnabled
    global Decimal balance;
    @AuraEnabled
    global Id batch;
    @AuraEnabled
    global String billingCity;
    @AuraEnabled
    global String billingContact;
    @AuraEnabled
    global String billingCountry;
    @AuraEnabled
    global String billingPostalCode;
    @AuraEnabled
    global String billingState;
    @AuraEnabled
    global String billingStreet;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Boolean calculateBillingDetails;
    @AuraEnabled
    global Boolean calculateMemo;
    @AuraEnabled
    global Boolean calculateShippingDetails;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global String customer;
    @AuraEnabled
    global Id depositAccount;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global Id epayment;
    @AuraEnabled
    global String gatewayTransactionId;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isPayment;
    @AuraEnabled
    global Boolean isPosted;
    @AuraEnabled
    global Boolean isRefund;
    @AuraEnabled
    global String memo;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id paymentGateway;
    @AuraEnabled
    global Id paymentMethod;
    @AuraEnabled
    global String paymentMethodDescription;
    @AuraEnabled
    global String paymentType;
    @AuraEnabled
    global Date postedDate;
    @AuraEnabled
    global Boolean processRefund;
    @AuraEnabled
    global Id receipt;
    @AuraEnabled
    global Date receiptDate;
    @AuraEnabled
    global List<FDService.ReceiptLine> receiptLines;
    @AuraEnabled
    global Id receiptR;
    @AuraEnabled
    global String referenceNumber;
    @AuraEnabled
    global Boolean refund;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global String shippingCity;
    @AuraEnabled
    global String shippingContact;
    @AuraEnabled
    global String shippingCountry;
    @AuraEnabled
    global String shippingPostalCode;
    @AuraEnabled
    global String shippingState;
    @AuraEnabled
    global String shippingStreet;
    @AuraEnabled
    global Id sourceCode;
    @AuraEnabled
    global Decimal total;
    @AuraEnabled
    global String type;
    global Receipt() {

    }
    global override virtual void fromSObject(SObject receiptObj) {

    }
    global static FDService.Receipt getInstance() {
        return null;
    }
    global static FDService.Receipt getInstance(OrderApi__Receipt__c receipt) {
        return null;
    }
    global static List<FDService.Receipt> getInstance(List<OrderApi__Receipt__c> receiptObjs) {
        return null;
    }
    global static List<FDService.Receipt> getInstance(List<OrderApi__Receipt__c> receiptObjs, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
