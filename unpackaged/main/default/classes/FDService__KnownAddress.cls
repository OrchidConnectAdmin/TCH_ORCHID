/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class KnownAddress extends FDService.WrapperBase {
    @AuraEnabled
    global String additionalDetails;
    @AuraEnabled
    global FDService.Address address;
    @AuraEnabled
    global String city;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global String country;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    global static String FEATURE;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isDefault;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global String postalCode;
    @AuraEnabled
    global String province;
    @AuraEnabled
    global String street;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global String type;
    global KnownAddress() {

    }
    global override void fromSObject(SObject KnownAddressObj) {

    }
    global static FDService.KnownAddress getInstance() {
        return null;
    }
    global static FDService.KnownAddress getInstance(OrderApi__Known_Address__c KnownAddress) {
        return null;
    }
    global static List<FDService.KnownAddress> getInstance(List<OrderApi__Known_Address__c> KnownAddresss) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
