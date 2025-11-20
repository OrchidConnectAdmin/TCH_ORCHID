global without sharing class FON_LateFilingBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute

        Integer year = system.today().year();
        
        Id ItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credit Filing Fee' LIMIT 1].Id;
        Id ItemID2 = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credits – Late Filing Fee' LIMIT 1].Id;
        
        //String query = 'Select Id, OrderApi__Item__c,OrderApi__Contact__c,OrderApi__Sales_Order__c,OrderApi__Account__c FROM OrderApi__Sales_Order_Line__c WHERE CALENDAR_YEAR(CreatedDate) = '+year+' AND OrderApi__Item__c = \''+ItemID+'\' AND FON_Sales_Order_Status__c != \'Paid\'';
        String query = 'Select Id, OrderApi__Contact__c,OrderApi__Account__c FROM OrderApi__Sales_Order__c WHERE Id IN (Select OrderApi__Sales_Order__c FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__c = \''+ItemID+'\' AND FON_Sales_Order_Status__c != \'Paid\' AND CALENDAR_YEAR(CreatedDate) = '+year+') AND Id NOT IN (Select OrderApi__Sales_Order__c FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__c = \''+ItemID2+'\' AND FON_Sales_Order_Status__c != \'Paid\' AND CALENDAR_YEAR(CreatedDate) = '+year+')';

        system.debug('QUERY '+ query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<OrderApi__Sales_Order__c> scope) {
		system.debug('ITEMS '+ scope);
        Set<Id> soIds = new Set<Id>();
        List<OrderApi__Sales_Order_Line__c> lstSolIns = new List<OrderApi__Sales_Order_Line__c>();
        Id ItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credits – Late Filing Fee' LIMIT 1].Id;
        

        for(OrderApi__Sales_Order__c sO : scope){
            OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
            sol.OrderApi__Item__c = ItemID;
            sol.OrderApi__Sales_Order__c = so.Id;
            sol.OrderApi__Is_Adjustment__c = true;
            lstSolIns.add(sol);
        }
        system.debug('SOIDs '+ soIds);

        system.debug('SOLS '+ lstSolIns);
        try {
            if(!lstSolIns.isEmpty()){
                insert lstSolIns;
            }
            
        } catch(Exception e) {
            System.debug(e);
        }
       

    }

    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}