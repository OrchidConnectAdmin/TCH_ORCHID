public without sharing class MembershipsTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public MembershipsTriggerHelper helper;
    public MembershipsTriggerHandler(Boolean triggerIsExecuting, integer triggerSize){
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new MembershipsTriggerHelper();
    }
    
    public void beforeInsert(List<OrderApi__Subscription__c> newSubs){
        
    }
    public void beforeUpdate(List<OrderApi__Subscription__c> oldSubs, List<OrderApi__Subscription__c> newSubs, Map<Id, SObject> oldSubsMap, Map<Id, SObject> newSubsMap){
        Map<Id, OrderApi__Subscription__c> newSMap = (Map<Id, OrderApi__Subscription__c>)newSubsMap;
        Map<Id, OrderApi__Subscription__c> oldSMap = (Map<Id, OrderApi__Subscription__c>)oldSubsMap;
        List<OrderAPI__Subscription__c> subsToInactivate = new List<OrderAPI__Subscription__c>();
        for(OrderAPI__Subscription__c sub : newSubs){
            if(newSMap.get(sub.Id).OrderApi__Renewals__c != oldSMap.get(sub.Id).OrderApi__Renewals__c && sub.OrderApi__Renewals__c > 1){
                subsToInactivate.add(sub);
            }
        }
        if(subsToInactivate.size() > 0){
            helper.inactivateSubs(subsToInactivate);
        }
    }
    public void beforeDelete(List<OrderApi__Subscription__c> oldSubs, Map<Id, SObject> oldSubsPPMap){
        
    }
    public void afterInsert(List<OrderApi__Subscription__c> newSubs, Map<Id, SObject> newSubsMap){
        
    }
    public void afterUpdate(List<OrderApi__Subscription__c> oldSubs, List<OrderApi__Subscription__c> newSubs, Map<Id, SObject> oldSubsMap, Map<Id, SObject> newSubsMap){
        
    }
    public void afterDelete(List<OrderApi__Subscription__c> oldSubs, Map<Id, SObject> oldSubsMap){
        
    }
    public void afterUndelete(List<ProgramApi__Program_Profile__c> newPP, Map<Id, SObject> newPPMap){
        
    }
}