/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Adjustment extends FDService.WrapperBase {
    @AuraEnabled
    global List<FDService.WrapperBase> records;
    @AuraEnabled
    global String type;
    global Adjustment() {

    }
    global override virtual void fromSObject(SObject itemObj) {

    }
    global static FDService.Adjustment getInstance() {
        return null;
    }
}
