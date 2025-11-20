public without sharing class FON_SalesOrderLineService {
    public static void recalculateTotal(List<OrderApi__Sales_Order_Line__c> records) {
		List<OrderApi__Sales_Order__c> usos = new List<OrderApi__Sales_Order__c>();
        Map<String, Decimal> mapSOLxTOTAL = new Map<String, Decimal>();
        Set<Id> soIDs = new Set<Id>();
        
        for(OrderApi__Sales_Order_Line__c sol : records){
            soIDs.add(sol.OrderApi__Sales_Order__c);
        }
        
        List<OrderApi__Sales_Order_Line__c> sols = [Select Id,OrderApi__Sales_Order__c,OrderApi__Overall_Total__c FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Sales_Order__c IN: soIDs];
        for(OrderApi__Sales_Order_Line__c sol : sols){
            Decimal total = mapSOLxTOTAL.get(sol.OrderApi__Sales_Order__c);
            if(total == null){
                mapSOLxTOTAL.put(sol.OrderApi__Sales_Order__c,sol.OrderApi__Overall_Total__c);
            }else{
                Decimal ntotal = total + sol.OrderApi__Overall_Total__c;
                mapSOLxTOTAL.remove(sol.OrderApi__Sales_Order__c);
                mapSOLxTOTAL.put(sol.OrderApi__Sales_Order__c,ntotal);
            }
        }
        
        if(soIDs.size()>0){
            for(OrderApi__Sales_Order__c so : [Select Id,OrderApi__Overall_Total__c FROM OrderApi__Sales_Order__c WHERE Id IN: soIDs]){
                so.OrderApi__Overall_Total__c = mapSOLxTOTAL.get(so.Id);
                usos.add(so);
            }
        }
        if(usos.size()>0){
            update usos;
        }
    }
}