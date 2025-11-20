/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RecordMatchField extends FDService.WrapperBase {
    @AuraEnabled
    global String fieldName;
    @AuraEnabled
    global String fieldType;
    @AuraEnabled
    global String label;
    @AuraEnabled
    global Boolean matchOnChange;
    @AuraEnabled
    global String objectName;
    @AuraEnabled
    global Boolean required;
    global RecordMatchField() {

    }
    global override virtual void fromSObject(SObject itemObj) {

    }
    global static FDService.RecordMatchField getInstance() {
        return null;
    }
}
