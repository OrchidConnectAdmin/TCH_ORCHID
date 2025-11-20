/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Domain {
    global static Framework.Domain.ErrorFactory errors {
        get;
    }
    global List<SObject> records {
        get;
    }
    global Domain(List<SObject> sObjectList) {

    }
    global virtual void afterDelete() {

    }
    global virtual void afterInsert() {

    }
    global virtual void afterUpdate(Map<Id,SObject> existingRecords) {

    }
    global virtual void applyDefaults() {

    }
    global virtual void beforeDelete() {

    }
    global virtual void beforeInsert() {

    }
    global virtual void beforeUpdate(Map<Id,SObject> existingRecords) {

    }
    global String error(String message, SObject record) {
        return null;
    }
    global String error(String message, SObject record, Schema.SObjectField field) {
        return null;
    }
    global virtual void validate() {

    }
    global virtual void validate(Map<Id,SObject> existingRecords) {

    }
global interface DomainConstructor {
    Framework.Domain construct(List<SObject> param0);
}
}
