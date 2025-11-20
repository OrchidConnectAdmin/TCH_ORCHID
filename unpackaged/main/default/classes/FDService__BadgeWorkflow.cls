/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BadgeWorkflow extends FDService.WrapperBase {
    @AuraEnabled
    global Boolean assignedContacts;
    @AuraEnabled
    global Boolean autoExpire;
    @AuraEnabled
    global Id badgeType;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global Boolean lineAccount;
    @AuraEnabled
    global Boolean lineContact;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String type;
    global BadgeWorkflow() {

    }
    global override void fromSObject(SObject BadgeWorkflowObj) {

    }
    global static FDService.BadgeWorkflow getInstance() {
        return null;
    }
    global static FDService.BadgeWorkflow getInstance(OrderApi__Badge_Workflow__c BadgeWorkflow) {
        return null;
    }
    global static List<FDService.BadgeWorkflow> getInstance(List<OrderApi__Badge_Workflow__c> BadgeWorkflows) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
