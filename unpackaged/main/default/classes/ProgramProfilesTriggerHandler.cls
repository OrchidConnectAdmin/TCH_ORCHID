public without sharing class ProgramProfilesTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public ProgramProfilesTriggerHelper helper;
    public ProgramProfilesTriggerHandler(Boolean triggerIsExecuting, integer triggerSize){
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new ProgramProfilesTriggerHelper();
    }
    
    public void beforeInsert(List<ProgramApi__Program_Profile__c> newPP){
        helper.setDefaults(newPP);
    }
    public void beforeUpdate(List<ProgramApi__Program_Profile__c> oldPP, List<ProgramApi__Program_Profile__c> newPP, Map<Id, SObject> oldPPMap, Map<Id, SObject> newPPMap){
        
    }
    public void beforeDelete(List<ProgramApi__Program_Profile__c> oldPP, Map<Id, SObject> oldPPMap){
        
    }
    public void afterInsert(List<ProgramApi__Program_Profile__c> newPP, Map<Id, SObject> newPPMap){
        helper.setTerms(newPP);
    }
    public void afterUpdate(List<ProgramApi__Program_Profile__c> oldPP, List<ProgramApi__Program_Profile__c> newPP, Map<Id, SObject> oldPPMap, Map<Id, SObject> newPPMap){
        
    }
    public void afterDelete(List<ProgramApi__Program_Profile__c> oldPP, Map<Id, SObject> oldPPMap){
        
    }
    public void afterUndelete(List<ProgramApi__Program_Profile__c> newPP, Map<Id, SObject> newPPMap){
        
    }
}