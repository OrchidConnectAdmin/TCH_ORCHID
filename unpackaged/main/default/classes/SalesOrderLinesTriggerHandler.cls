public without sharing class SalesOrderLinesTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public SalesOrderLinesTriggerHelper helper;
    public SalesOrderLinesTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new SalesOrderLinesTriggerHelper();
    }
    public void beforeInsert(List<OrderApi__Sales_Order_Line__c> newSOLs) {
        
    }
    public void beforeUpdate(List<OrderApi__Sales_Order_Line__c> oldSOLs, List<OrderApi__Sales_Order_Line__c> newSOLs, Map<ID, SObject> oldSOLsMap, Map<ID, SObject> newSOLsMap) {
        List<OrderApi__Sales_Order_Line__c> updAtt = new List<OrderApi__Sales_Order_Line__c>();
        for(OrderApi__Sales_Order_Line__c sol : newSOLs){
            if(string.isBlank(sol.EventApi__Attendee__c) && !string.isBlank(sol.OrderApi__Contact__c) && !string.isBlank(sol.EventApi__Event__c)){
                updAtt.add(sol);
            }
        }
        helper.updateAttendee(updAtt);
    }
    
    public void beforeDelete(List<OrderApi__Sales_Order_Line__c> oldSOLs, Map<ID, SObject> oldSOLsMap) {
        
    }
    public void afterInsert(List<OrderApi__Sales_Order_Line__c> newSOLs, Map<ID, SObject> newSOLsMap) {
        
    }
    public void afterUpdate(List<OrderApi__Sales_Order_Line__c> oldSOLs, List<OrderApi__Sales_Order_Line__c> newSOLs, Map<ID, SObject> oldSOLsMap, Map<ID, SObject> newSOLsMap) {
        
    }
    public void afterDelete(List<OrderApi__Sales_Order_Line__c> oldSOLs, Map<ID, SObject> oldSOLsMap) {
        
    }
    public void afterUndelete(List<OrderApi__Sales_Order_Line__c> newSOLs, Map<ID, SObject> newSOLsMap) {
        
    }
}