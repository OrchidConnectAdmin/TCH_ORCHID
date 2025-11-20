/**
 * Created by nkopparthi on 11/16/20.
 */

global class FON_NewYearBatchJob implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute

        Integer year = system.today().year();
        String query = 'SELECT Id, Status__c, Contact_Name__c FROM NCP_Credits__c WHERE Contact_Name__c != null AND CALENDAR_YEAR(FON_Session_Date__c) < ' + year + ' AND Status__c = \'Pending for Approval\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<NCP_Credits__c> ncpList) {

        Set<Id> conIds = new Set<Id>();
        List<OrderApi__Sales_Order__c> lstSoIns = new List<OrderApi__Sales_Order__c>();
        List<OrderApi__Sales_Order_Line__c> lstSolIns = new List<OrderApi__Sales_Order_Line__c>();
        Id ItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credit Filing Fee' LIMIT 1].Id;
        
        List<OrderApi__Sales_Order_Line__c> currentSOLS = [Select Id, OrderApi__Item__c,OrderApi__Contact__c FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__r.Name = 'CE Credit Filing Fee' AND OrderApi__Sales_Order__r.OrderApi__Sales_Order_Status__c != 'Paid' AND OrderApi__Contact__c=:conIds];
        Map<String,Boolean> mapCONxSOL = new Map<String,Boolean>();
        
        if(currentSOLS.size()>0){
            for(OrderApi__Sales_Order_Line__c cSOL : currentSOLS){
                mapCONxSOL.put(cSOL.OrderApi__Contact__c,true);
            }
        }
        // process each batch of records default size is 200
            
            for(NCP_Credits__c ncp : ncpList) {
                conIds.add(ncp.Contact_Name__c);
            }
    
            for(Id cId : conIds){
                Boolean hasSOL = mapCONxSOL.get(cId);
                if(hasSOL != true){
                    OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
                    so.OrderApi__Contact__c = cId;
                    so.OrderApi__Is_Closed__c = true;
                    so.OrderApi__Is_Proforma__c = true;
                    so.OrderApi__Proforma_Invoice_Email_Sent__c = true;
                    lstSoIns.add(so);
                }
            }
    
            try {
    
                if(!lstSoIns.isEmpty()){
                    insert lstSoIns;
    
                    for(OrderApi__Sales_Order__c so : lstSoIns){
                        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                        sol.OrderApi__Item__c = ItemID;
                        sol.OrderApi__Sales_Order__c = so.Id;
                        lstSolIns.add(sol);
                    }
    
                    if(!lstSolIns.isEmpty()){
                        insert lstSolIns;
                    }
                }
    
            } catch(Exception e) {
                System.debug(e);
            }
            

    }

    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}