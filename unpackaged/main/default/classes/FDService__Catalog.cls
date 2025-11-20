/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Catalog extends FDService.WrapperBase {
    @AuraEnabled
    global Id catalog;
    @AuraEnabled
    global String catalogFilters;
    @AuraEnabled
    global OrderApi__Catalog__c catalogObj;
    @AuraEnabled
    global Boolean displayFeaturedItems;
    @AuraEnabled
    global Integer displayOrder;
    @AuraEnabled
    global String id;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String parent;
    @AuraEnabled
    global String placeholderImage;
    @AuraEnabled
    global Id store;
    global Catalog() {

    }
    global override virtual void fromSObject(SObject catalogObj) {

    }
    global static FDService.Catalog getInstance() {
        return null;
    }
    global static FDService.Catalog getInstance(OrderApi__Catalog__c catalogObj) {
        return null;
    }
    global static FDService.Catalog getInstance(OrderApi__Catalog__c catalogObj, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
