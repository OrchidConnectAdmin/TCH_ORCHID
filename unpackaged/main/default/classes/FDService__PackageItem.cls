/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PackageItem extends FDService.WrapperBase {
    @AuraEnabled
    global Boolean calculatePricing;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Boolean displayItem;
    @AuraEnabled
    global Decimal displayOrder;
    @AuraEnabled
    global String groupHeader;
    @AuraEnabled
    global String groupInstructionsText;
    @AuraEnabled
    global String id;
    @AuraEnabled
    global Boolean isGroup;
    @AuraEnabled
    global Boolean isMultiCurrency;
    @AuraEnabled
    global Boolean isRecommended;
    @AuraEnabled
    global Boolean isRequired;
    @AuraEnabled
    global String item;
    @AuraEnabled
    global Decimal maximumQuantity;
    @AuraEnabled
    global Decimal maximumQuantityPerItem;
    @AuraEnabled
    global Decimal minimumQuantity;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Decimal numberOfFreeItems;
    @AuraEnabled
    global String packageItem;
    @AuraEnabled
    global String parentItem;
    global PackageItem() {

    }
    global override virtual void fromSObject(SObject packageItemObj) {

    }
    global override virtual Object getFieldValueFromSObject(String fieldName) {
        return null;
    }
    global static FDService.PackageItem getInstance() {
        return null;
    }
    global static FDService.PackageItem getInstance(OrderApi__Package_Item__c packageItemObj) {
        return null;
    }
    global static FDService.PackageItem getInstance(OrderApi__Package_Item__c packageItemObj, String className) {
        return null;
    }
    global static List<FDService.PackageItem> getInstance(List<OrderApi__Package_Item__c> packageItemObjs) {
        return null;
    }
    global static List<FDService.PackageItem> getInstance(List<OrderApi__Package_Item__c> packageItemObjs, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
