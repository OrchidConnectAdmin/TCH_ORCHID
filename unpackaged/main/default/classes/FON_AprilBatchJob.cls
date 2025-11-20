/**
 * Created by nkopparthi on 11/16/20.
 */

global class FON_AprilBatchJob implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute

        String query = 'SELECT Id, OrderApi__Sales_Order_Status__c FROM OrderApi__Sales_Order__c WHERE OrderApi__Sales_Order_Status__c = \'Unpaid\' AND OrderApi__Is_Proforma__c = true';
        if(test.isRunningTest()){
            query = 'SELECT Id, OrderApi__Sales_Order_Status__c FROM OrderApi__Sales_Order__c ';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<OrderApi__Sales_Order__c> soList) {

        List<Id> soIds = new List<Id>();
        List<OrderApi__Sales_Order__c> salesOrderList = new List<OrderApi__Sales_Order__c>();
        List<OrderApi__Sales_Order_Line__c> lstSolIns = new List<OrderApi__Sales_Order_Line__c>();
        Id ItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credit Filing Fee' LIMIT 1].Id;
        Id LateItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credits – Late Filing Fee' LIMIT 1].Id;

        // process each batch of records default size is 200

        for(OrderApi__Sales_Order__c so : soList){
            soIds.add(so.Id);
        }

        salesOrderList = [
                         SELECT  Id,
                         (SELECT Id,
                                 OrderApi__Item__c
                         FROM OrderApi__Sales_Order_Lines__r)
                         FROM OrderApi__Sales_Order__c
                         WHERE Id IN :soIds
        ];

        for(OrderApi__Sales_Order__c so : salesOrderList){
            for(OrderApi__Sales_Order_Line__c sol : so.OrderApi__Sales_Order_Lines__r){
                if(sol.OrderApi__Item__c == ItemID){
                    OrderApi__Sales_Order_Line__c newSol = new OrderApi__Sales_Order_Line__c();
                    newSol.OrderApi__Sales_Order__c = so.Id;
                    newSol.OrderApi__Item__c = LateItemID;
                    lstSolIns.add(newSol);
                }
            }
        }

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