/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Assignment extends FDService.WrapperBase {
    @AuraEnabled
    global Date assignedDate;
    @AuraEnabled
    global Id assignmentRole;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global String fullName;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Boolean isPrimary;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global Id salesOrderLine;
    @AuraEnabled
    global Id subscription;
    @AuraEnabled
    global Id subscriptionLine;
    @AuraEnabled
    global Id term;
    @AuraEnabled
    global Date unassignedDate;
    global Assignment() {

    }
    global static FDService.Assignment getInstance() {
        return null;
    }
    global static FDService.Assignment getInstance(OrderApi__Assignment__c asgn) {
        return null;
    }
    global static List<FDService.Assignment> getInstance(List<OrderApi__Assignment__c> assignmentObjs) {
        return null;
    }
    global static List<FDService.Assignment> getInstance(List<OrderApi__Assignment__c> assignmentObjs, String className) {
        return null;
    }
}
