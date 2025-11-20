/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ScheduledPaymentLine extends FDService.WrapperBase {
    @AuraEnabled
    global Date activationDate;
    @AuraEnabled
    global Boolean autoCalculateActivationDate;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Date endDate;
    @AuraEnabled
    global Id gLAccount;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoiceLine;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isRenewal;
    @AuraEnabled
    global Boolean isShippingRate;
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
    @AuraEnabled
    global Boolean priceOverride;
    @AuraEnabled
    global Id priceRule;
    @AuraEnabled
    global Integer quantity;
    @AuraEnabled
    global Decimal salePrice;
    @AuraEnabled
    global Id salesOrderLine;
    @AuraEnabled
    global Id scheduledPayment;
    @AuraEnabled
    global Id scheduledPaymentLine;
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
    global ScheduledPaymentLine() {

    }
    global static FDService.ScheduledPaymentLine getInstance() {
        return null;
    }
    global static FDService.ScheduledPaymentLine getInstance(OrderApi__Scheduled_Payment_Line__c ScheduledPaymentLine) {
        return null;
    }
    global static List<FDService.ScheduledPaymentLine> getInstance(List<OrderApi__Scheduled_Payment_Line__c> ScheduledPaymentLines) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
