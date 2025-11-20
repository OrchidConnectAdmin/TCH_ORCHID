/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvoiceLine extends FDService.WrapperBase {
    @AuraEnabled
    global Date activationDate;
    @AuraEnabled
    global String adjustmentReason;
    @AuraEnabled
    global Decimal adjustments;
    @AuraEnabled
    global Decimal amountPaid;
    @AuraEnabled
    global Decimal amountRefunded;
    @AuraEnabled
    global Id aRAccount;
    @AuraEnabled
    global Boolean autoCalculateActivationDate;
    @AuraEnabled
    global Decimal balanceDue;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Boolean calculateShippingDetails;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Id CreatedById;
    @AuraEnabled
    global Datetime CreatedDate;
    @AuraEnabled
    global Id creditMemo;
    @AuraEnabled
    global Id creditNote;
    @AuraEnabled
    global Decimal creditsApplied;
    @AuraEnabled
    global Boolean deferredRevenueAdjustment;
    @AuraEnabled
    global Date endDate;
    @AuraEnabled
    global Id gLAccount;
    @AuraEnabled
    global Id Id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global Id invoiceLine;
    @AuraEnabled
    global Boolean isAdjustment;
    @AuraEnabled
    global Boolean isChildLine;
    @AuraEnabled
    global Boolean IsDeleted;
    @AuraEnabled
    global Boolean isPosted;
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
    global Id LastModifiedById;
    @AuraEnabled
    global Datetime LastModifiedDate;
    @AuraEnabled
    global String lineDescription;
    @AuraEnabled
    global Decimal listPrice;
    @AuraEnabled
    global String Name;
    @AuraEnabled
    global Id parentSalesOrderLine;
    @AuraEnabled
    global Integer paymentPriority;
    @AuraEnabled
    global Date postedDate;
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
    global Datetime SystemModstamp;
    @AuraEnabled
    global Decimal taxAmount;
    @AuraEnabled
    global Boolean taxOverride;
    @AuraEnabled
    global Decimal taxPercent;
    @AuraEnabled
    global Decimal total;
    @AuraEnabled
    global Decimal totalWithTax;
    global InvoiceLine() {

    }
    global override void fromSObject(SObject InvoiceLineObj) {

    }
    global static FDService.InvoiceLine getInstance() {
        return null;
    }
    global static FDService.InvoiceLine getInstance(OrderApi__Invoice_Line__c InvoiceLine) {
        return null;
    }
    global static List<FDService.InvoiceLine> getInstance(List<OrderApi__Invoice_Line__c> InvoiceLines) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
