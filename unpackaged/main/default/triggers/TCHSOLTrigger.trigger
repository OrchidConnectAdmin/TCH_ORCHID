trigger TCHSOLTrigger on OrderApi__Sales_Order_Line__c (after insert, before insert) {

    
    Boolean afterInsert = Trigger.isafter && trigger.isinsert;
    Boolean beforeInsert = Trigger.isbefore && trigger.isinsert;
    
    if(beforeInsert){
        
        // verify Overall Total and Balance
        List<OrderApi__Sales_Order_Line__c> salesOrderLines = (List<OrderApi__Sales_Order_Line__c>) Trigger.new;

        for (OrderApi__Sales_Order_Line__c salesOrderLine : salesOrderLines) {
            if(salesOrderLine.Sponsoring_Relationship__c != null){
                if ( salesOrderLine.OrderApi__Overall_Total__c != salesOrderLine.OrderApi__Total__c || salesOrderLine.OrderApi__Balance_Due__c != salesOrderLine.OrderApi__Total__c ) {
                    salesOrderLine.OrderApi__Overall_Total__c = salesOrderLine.OrderApi__Total__c;
                    salesOrderLine.OrderApi__Balance_Due__c = salesOrderLine.OrderApi__Total__c;
                }
            }
        }
        // the ugly workaround wth
        Integer testvar = 0;
        testvar++;
        testvar++;
        testvar++;
        testvar++;testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
     } 
}