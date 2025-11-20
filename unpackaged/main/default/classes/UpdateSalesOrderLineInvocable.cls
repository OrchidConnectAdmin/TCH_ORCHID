global class UpdateSalesOrderLineInvocable {
    // https://developer.salesforce.com/forums/?id=9060G0000005nusQAA

    @InvocableMethod(label='Update Sales Order Line' Description='Update Multiple Order Line')
    global static List<String> fetchSalesOrderLine(List<methodVars> rels) {
   
        List<String> test = new List<String>();
        List<String> recs = rels[0].mlist;
        
        system.debug('RELS '+rels[0].mlist);
        system.debug('RECORDS '+rels[0].mlist);
        
        for (Integer i = 0; i < recs.size(); i++) {
            
            system.debug('CURRENT RECORD '+i+'--'+recs[i]);
            system.debug('CURRENT SO '+i+'--'+rels[0].so);
            String srid = recs[i].trim();
            OrderApi__Sales_Order_Line__c sol = [Select Id,OrderApi__Overall_Total__c from OrderApi__Sales_Order_Line__c where SOID__c =: rels[0].so AND SRID__c =: srid ];
            sol.OrderApi__Subscription_Plan__c = rels[0].plan;
            update sol;
            
            // update pricing
            if(rels[0].quarter != '1QFull'){
                if(rels[0].timing != 'Annual'){
                    OrderApi__Sales_Order_Line__c nsol = [Select Id,OrderApi__Overall_Total__c from OrderApi__Sales_Order_Line__c where Id =: sol.Id];
                    nsol.OrderApi__Balance_Due__c = nsol.OrderApi__Overall_Total__c / 4;
                    nsol.OrderApi__Total__c = nsol.OrderApi__Overall_Total__c / 4;
                    nsol.OrderApi__Overall_Total__c = nsol.OrderApi__Overall_Total__c / 4;
                    update nsol;
                    system.debug('PRICE UPDATED '+i+'--'+nsol);
                }
            }
            
            
            
        }
        
		test.add('done');
        return test;
    }
           //input details that comes to apex from flow
    global class methodVars{
        @InvocableVariable
        global String quarter;
        
        @InvocableVariable
        global String item;
        
        @InvocableVariable
        global String so;
        
        @InvocableVariable
        global String plan;
        
        @InvocableVariable
        global String acc;
        
        @InvocableVariable
        global String contact;
        
        @InvocableVariable
        global String rel;
        
        @InvocableVariable
        global List<String> mlist;
        
		@InvocableVariable
        global String timing;
    }
    
    //output details which goes from apex to flow
    /*public class methodOutputs{
        @InvocableVariable
        public String accountPreviousName ;
        @InvocableVariable
        public String DMLResult ;
    } */
}