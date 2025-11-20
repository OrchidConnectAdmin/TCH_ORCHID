global without sharing class GetCYRILPCSparkPlugController {
    @AuraEnabled
    public static Map<String,List<SObject>> getSalesOrder(String orderNumber) {
		Map<String,List<SObject>> sop = new Map<String,List<SObject>>();
        
        String sid;
        try{
            List<OrderApi__Sales_Order__c> so = [SELECT Id,Name,OrderApi__Total__c,OrderApi__Encrypted_Id__c FROM OrderApi__Sales_Order__c WHERE Name =:orderNumber];
            if(so != null && so.size() > 0) {
                sop.put('order',so);
                sid = so[0].Id;
            }else{
                List<OrderApi__Receipt__c> receiptList = [SELECT Id,OrderApi__Total__c,OrderApi__Encrypted_Id__c,OrderApi__Sales_Order__r.Id,OrderApi__Sales_Order__r.OrderApi__Encrypted_Id__c,OrderApi__Sales_Order__r.OrderApi__Total__c FROM OrderApi__Receipt__c WHERE Name =:orderNumber LIMIT 1];
                sop.put('receipt',receiptList);
                sid = receiptList[0].OrderApi__Sales_Order__r.Id;
            }
        } catch (ListException le) {
            System.debug('Receipt not found: '+le.getMessage());

        }
        
        
        
        
		
        
        // get line items
        List<OrderApi__Sales_Order_Line__c> sol = [SELECT Id,OrderApi__Item__r.Name,OrderApi__Item__r.OrderApi__Is_Event__c,OrderApi__Item__r.ProgramApi__Program__r.Id,OrderApi__Item__r.ProgramApi__Program__r.Name FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Sales_Order__c =:sid];
		sop.put('lines',sol);
        
        return sop;
    }
}