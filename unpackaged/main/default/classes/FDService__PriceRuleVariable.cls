/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PriceRuleVariable extends FDService.WrapperBase {
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global String field;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String operator;
    @AuraEnabled
    global Id priceRule;
    @AuraEnabled
    global String priceRuleVariableobject;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global String value;
    global PriceRuleVariable() {

    }
    global override void fromSObject(SObject PriceRuleVariableObj) {

    }
    global static FDService.PriceRuleVariable getInstance() {
        return null;
    }
    global static FDService.PriceRuleVariable getInstance(OrderApi__Price_Rule_Variable__c PriceRuleVariable) {
        return null;
    }
    global static List<FDService.PriceRuleVariable> getInstance(List<OrderApi__Price_Rule_Variable__c> PriceRuleVariables) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
