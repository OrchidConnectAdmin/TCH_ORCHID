/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SObjectService {
    global SObjectService() {

    }
    global static Map<String,String> getFieldLabels(String objectName) {
        return null;
    }
    global static List<FDService.SObjectService.FieldDescribe> getFieldSetMembers(String fieldsetName, Schema.SObjectType sObjectType) {
        return null;
    }
    global static Map<String,String> getFieldTypes(String objectName) {
        return null;
    }
    global static Map<String,String> getPicklistLabels(String objectName, String fieldString) {
        return null;
    }
    global static Map<String,Schema.DescribeFieldResult> getSObjectFields(String objectName) {
        return null;
    }
global class FieldDescribe {
    @AuraEnabled
    global Boolean isRequired;
    @AuraEnabled
    global String label;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String type;
    @AuraEnabled
    global Object value;
    global FieldDescribe() {

    }
    global FieldDescribe(Schema.FieldSetMember fieldResult) {

    }
}
}
