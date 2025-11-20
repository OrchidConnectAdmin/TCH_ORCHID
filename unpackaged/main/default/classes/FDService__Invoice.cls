/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Invoice extends FDService.WrapperBase {
    @AuraEnabled
    global Decimal adjustments;
    @AuraEnabled
    global Decimal amountPaid;
    @AuraEnabled
    global Id arAccount;
    @AuraEnabled
    global Decimal balanceDue;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Decimal creditsAndAdjustments;
    @AuraEnabled
    global Decimal creditsApplied;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Date dueDate;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Date invoiceDate;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Date paidDate;
    @AuraEnabled
    global Date postedDate;
    @AuraEnabled
    global List<FDService.Receipt> receipts;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global Id scheduledPayment;
    @AuraEnabled
    global String status;
    @AuraEnabled
    global Id subscription;
    @AuraEnabled
    global Decimal subtotal;
    @AuraEnabled
    global Id term;
    @AuraEnabled
    global Decimal total;
    global Invoice() {

    }
    global static FDService.Invoice getInstance() {
        return null;
    }
    global static FDService.Invoice getInstance(OrderApi__Invoice__c invoice) {
        return null;
    }
    global static List<FDService.Invoice> getInstance(List<OrderApi__Invoice__c> invoiceObjs) {
        return null;
    }
    global static List<FDService.Invoice> getInstance(List<OrderApi__Invoice__c> invoiceObjs, String className) {
        return null;
    }
}
