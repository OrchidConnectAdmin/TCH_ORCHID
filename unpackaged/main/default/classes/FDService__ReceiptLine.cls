/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ReceiptLine extends FDService.WrapperBase {
    @AuraEnabled
    global Date activationDate;
    @AuraEnabled
    global Boolean autoCalculateActivationDate;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Boolean calculateShippingDetails;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Date endDate;
    global String foreignKey;
    @AuraEnabled
    global Id gLAccount;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global Decimal invoiceBalanceDue;
    @AuraEnabled
    global String invoiceCustomerLink;
    @AuraEnabled
    global Date invoiceDueDate;
    @AuraEnabled
    global Id invoiceLine;
    @AuraEnabled
    global Boolean isRefund;
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
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String lineDescription;
    @AuraEnabled
    global Decimal listPrice;
    @AuraEnabled
    global String name;
    global String parentForeignKey;
    @AuraEnabled
    global Boolean priceOverride;
    @AuraEnabled
    global Id priceRule;
    @AuraEnabled
    global Decimal quantity;
    @AuraEnabled
    global Id receipt;
    @AuraEnabled
    global Id receiptLine;
    @AuraEnabled
    global Id receiptLineR;
    @AuraEnabled
    global Decimal salePrice;
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
    global Id subscription;
    @AuraEnabled
    global Id subscriptionPlan;
    @AuraEnabled
    global Decimal subtotal;
    @AuraEnabled
    global Boolean taxOverride;
    @AuraEnabled
    global Decimal taxPercent;
    @AuraEnabled
    global Decimal total;
    global ReceiptLine() {

    }
    global static FDService.ReceiptLine getInstance() {
        return null;
    }
    global static FDService.ReceiptLine getInstance(OrderApi__Receipt_Line__c receiptLine) {
        return null;
    }
    global static List<FDService.ReceiptLine> getInstance(List<OrderApi__Receipt_Line__c> receiptLineObjs) {
        return null;
    }
    global static List<FDService.ReceiptLine> getInstance(List<OrderApi__Receipt_Line__c> receiptLineObjs, String className) {
        return null;
    }
}
