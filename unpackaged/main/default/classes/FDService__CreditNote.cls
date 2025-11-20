/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class CreditNote extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
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
    global Id contact;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Date creditNoteDate;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global String customer;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global String invoiceNumber;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isPosted;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String memo;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global Date postedDate;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global Integer salesOrderNumber;
    @AuraEnabled
    global Decimal total;
    global CreditNote() {

    }
    global override void fromSObject(SObject creditNoteObj) {

    }
    global static FDService.CreditNote getInstance() {
        return null;
    }
    global static FDService.CreditNote getInstance(OrderApi__Credit_Note__c creditNote) {
        return null;
    }
    global static List<FDService.CreditNote> getInstance(List<OrderApi__Credit_Note__c> creditNotes) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
