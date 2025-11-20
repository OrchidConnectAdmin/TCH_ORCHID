/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ShippingMethod extends FDService.WrapperBase {
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
    global Boolean isDefault;
    @AuraEnabled
    global Boolean isDeleted;
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
    global Id shippingCarrierItemClass;
    @AuraEnabled
    global Datetime systemModstamp;
    global ShippingMethod() {

    }
    global override void fromSObject(SObject ShippingMethodObj) {

    }
    global static FDService.ShippingMethod getInstance() {
        return null;
    }
    global static FDService.ShippingMethod getInstance(OrderApi__Shipping_Method__c ShippingMethod) {
        return null;
    }
    global static List<FDService.ShippingMethod> getInstance(List<OrderApi__Shipping_Method__c> ShippingMethods) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
