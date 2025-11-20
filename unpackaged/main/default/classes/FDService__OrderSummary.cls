/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class OrderSummary extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global String addressTo;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global String customerLink;
    @AuraEnabled
    global Date dateCreated;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global String filterCriteria;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global List<Id> invoices;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String memo;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global List<Id> orders;
    @AuraEnabled
    global String orderSummaryURL;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global String pdfURL;
    @AuraEnabled
    global Boolean showOutstandingCredits;
    @AuraEnabled
    global Datetime systemModstamp;
    global OrderSummary() {

    }
    global override void fromSObject(SObject OrderSummaryObj) {

    }
    global static FDService.OrderSummary getInstance() {
        return null;
    }
    global static FDService.OrderSummary getInstance(OrderApi__Order_Summary__c orderSummaryObj) {
        return null;
    }
    global static List<FDService.OrderSummary> getInstance(List<OrderApi__Order_Summary__c> orderSummaryObjs) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
