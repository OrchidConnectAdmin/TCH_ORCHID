/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ShippingRegion extends FDService.WrapperBase {
    @AuraEnabled
    global String address;
    @AuraEnabled
    global String addressFieldValuesCSV;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global String displayName;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isDefaultRegion;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Date lastActivityDate;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global Datetime lastReferencedDate;
    @AuraEnabled
    global Datetime lastViewedDate;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global Boolean willNotShip;
    @AuraEnabled
    global String willNotShipMessage;
    global ShippingRegion() {

    }
    global override void fromSObject(SObject ShippingRegionObj) {

    }
    global static FDService.ShippingRegion getInstance() {
        return null;
    }
    global static FDService.ShippingRegion getInstance(OrderApi__Shipping_Region__c ShippingRegion) {
        return null;
    }
    global static List<FDService.ShippingRegion> getInstance(List<OrderApi__Shipping_Region__c> ShippingRegions) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
