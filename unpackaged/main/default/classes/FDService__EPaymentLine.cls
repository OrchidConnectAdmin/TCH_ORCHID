/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class EPaymentLine extends FDService.WrapperBase {
    @AuraEnabled
    global Date activationDate;
    @AuraEnabled
    global String activityType;
    @AuraEnabled
    global Boolean autoCalculateActivationDate;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Date endDate;
    @AuraEnabled
    global Id ePayment;
    @AuraEnabled
    global Id ePaymentLine;
    global String foreignKey;
    @AuraEnabled
    global Id gLAccount;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global Id invoiceLine;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isRenewal;
    @AuraEnabled
    global Boolean isTax;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global Id itemClass;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global Decimal listPrice;
    @AuraEnabled
    global String name;
    global String parentForeignKey;
    @AuraEnabled
    global String paymentMethod;
    @AuraEnabled
    global Boolean priceOverride;
    @AuraEnabled
    global Id priceRule;
    @AuraEnabled
    global Integer quantity;
    @AuraEnabled
    global Decimal salePrice;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global Id salesOrderLine;
    @AuraEnabled
    global String status;
    @AuraEnabled
    global Id subscription;
    @AuraEnabled
    global Id subscriptionPlan;
    @AuraEnabled
    global Decimal subtotal;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global Boolean taxOverride;
    @AuraEnabled
    global Decimal taxPercent;
    @AuraEnabled
    global Decimal total;
    global EPaymentLine() {

    }
    global static FDService.EPaymentLine getInstance() {
        return null;
    }
    global static FDService.EPaymentLine getInstance(OrderApi__EPayment_Line__c EPaymentLine) {
        return null;
    }
    global static List<FDService.EPaymentLine> getInstance(List<OrderApi__EPayment_Line__c> EPaymentLines) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
