global without sharing class FONCalculateSOTotalBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(Test.isRunningTest()){
            return Database.getQueryLocator([Select Id,OrderApi__Overall_Total__c,FON_Actual_Sum__c,OrderApi__Sales_Order_Status__c FROM OrderApi__Sales_Order__c]);
        }else{
            return Database.getQueryLocator([Select Id,OrderApi__Overall_Total__c,FON_Actual_Sum__c,OrderApi__Sales_Order_Status__c FROM OrderApi__Sales_Order__c WHERE OrderApi__Sales_Order_Status__c != 'Paid']);
        }
    }
    global void execute(Database.BatchableContext bc, List<OrderApi__Sales_Order__c> scope){

        List<OrderApi__Sales_Order__c> sos = new List<OrderApi__Sales_Order__c>();
        for (OrderApi__Sales_Order__c so : scope) {
            if( ( so.OrderApi__Overall_Total__c != so.FON_Actual_Sum__c && so.OrderApi__Sales_Order_Status__c != 'Paid' ) || Test.isRunningTest()){
                so.OrderApi__Overall_Total__c = so.FON_Actual_Sum__c;
                sos.add(so);
            }
        }
        if(sos.isEmpty() == false){
            update sos;
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }    
    
}