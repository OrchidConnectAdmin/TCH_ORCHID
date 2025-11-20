/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TaxLocale extends FDService.WrapperBase {
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String localeValuesCSV;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global Id taxGLAccount;
    @AuraEnabled
    global String taxLocaleField;
    global TaxLocale() {

    }
    global override void fromSObject(SObject TaxLocaleObj) {

    }
    global static FDService.TaxLocale getInstance() {
        return null;
    }
    global static FDService.TaxLocale getInstance(OrderApi__Tax_Locale__c TaxLocale) {
        return null;
    }
    global static List<FDService.TaxLocale> getInstance(List<OrderApi__Tax_Locale__c> TaxLocales) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
