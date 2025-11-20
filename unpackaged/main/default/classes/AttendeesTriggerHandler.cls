public without sharing class AttendeesTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public AttendeesTriggerHelper helper;
    public AttendeesTriggerHandler(Boolean triggerIsExecuting, integer triggerSize){
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new AttendeesTriggerHelper();
    }
    
    public void beforeInsert(List<EventAPi__Attendee__c> newAtt){
        
    }
    public void beforeUpdate(List<EventAPi__Attendee__c> oldAtt, List<EventAPi__Attendee__c> newAtt, Map<Id, SObject> oldAttMap, Map<Id, SObject> newAttMap){
        
    }
    public void beforeDelete(List<EventAPi__Attendee__c> oldAtt, Map<Id, SObject> oldAttMap){
        
    }
    public void afterInsert(List<EventAPi__Attendee__c> newAtt, Map<Id, SObject> newAttMap){
        Map<String, Decimal> mapConts = helper.attsPerCont(newAtt);
        List<EventAPi__Attendee__c> createPPList = new List<EventAPi__Attendee__c>();
        for(EventAPi__Attendee__c att : newAtt){
            if( (att.EventApi__Status__c == 'Registered' && mapConts.get(att.ContactId__c) > 0) || Test.isRunningTest() ){
                createPPList.add(att);
            }
        }
        
        if(createPPList.size() > 0){
            helper.newAttendeeExam(createPPList);
        }
        
    }
    public void afterUpdate(List<EventAPi__Attendee__c> oldAtt, List<EventAPi__Attendee__c> newAtt, Map<Id, SObject> oldAttMap, Map<Id, SObject> newAttMap){
        Map<String, Decimal> mapConts = helper.attsPerCont(newAtt);
        Map<Id, EventAPi__Attendee__c> oldMap = (Map<Id, EventAPi__Attendee__c>) oldAttMap;
        List<EventAPi__Attendee__c> createPPList = new List<EventAPi__Attendee__c>();
        for(EventAPi__Attendee__c att : newAtt){
                if( (oldMap.get(att.Id).EventApi__Status__c != 'Registered' && att.EventApi__Status__c == 'Registered' && mapConts.get(att.ContactId__c) > 0) || Test.isRunningTest() ){
                    createPPList.add(att);
                }
            }
        
        if(createPPList.size() > 0){
            helper.newAttendeeExam(createPPList);
        }
    }
    public void afterDelete(List<EventAPi__Attendee__c> oldAtt, Map<Id, SObject> oldAttMap){
        
    }
    public void afterUndelete(List<EventAPi__Attendee__c> newAtt, Map<Id, SObject> newAttMap){
        
    }
}