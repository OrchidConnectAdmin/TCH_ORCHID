/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class EventChatterGroup extends FDService.WrapperBase {
    @AuraEnabled
    global Id collaborationGroupId;
    @AuraEnabled
    global Id event;
    @AuraEnabled
    global String groupName;
    @AuraEnabled
    global Id id;
    global EventChatterGroup() {

    }
    global override virtual void fromSObject(SObject eventChatterGroupsObj) {

    }
    global static FDService.EventChatterGroup getInstance() {
        return null;
    }
    global static FDService.EventChatterGroup getInstance(EventApi__Event_Chatter_Groups__c eventChatterGroupsObj) {
        return null;
    }
    global static List<FDService.EventChatterGroup> getInstance(List<EventApi__Event_Chatter_Groups__c> eventChatterGroupsObjs) {
        return null;
    }
    global static List<FDService.EventChatterGroup> getInstance(List<EventApi__Event_Chatter_Groups__c> eventChatterGroupsObjs, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
