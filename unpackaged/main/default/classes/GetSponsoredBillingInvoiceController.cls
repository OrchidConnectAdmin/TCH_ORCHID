global without sharing class GetSponsoredBillingInvoiceController {
    List<OrderApi__Sales_Order_Line__c> sol = new List<OrderApi__Sales_Order_Line__c>();
    OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
    OrderApi__Business_Group__c co = new OrderApi__Business_Group__c();
	OrderApi__Sales_Order_Line__c disc = new OrderApi__Sales_Order_Line__c();
    Decimal solTotal = 0;
    
    global GetSponsoredBillingInvoiceController() {
        String soID = Apexpages.currentPage().getparameters().get('id'); 
        //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=invoice-'+soID+'.pdf');
        
        so  = [Select Id,Name,Invoice_Number__c,PO_ID__c,OrderApi__Business_Group__r.Id,OrderApi__Description__c,Invoice_Term__c,Invoice_Total__c,OrderApi__Overall_Total__c,OrderApi__Customer_Link__c,Contact_Name__c,OrderApi__Billing_Street__c,Address__c,FON_Billing_Type__c from OrderApi__Sales_Order__c where Id =: soID];
        
        String bid;
        
        bid = so.OrderApi__Business_Group__r.Id;
        
        // Get site
        if(String.isBlank(bid) == true){
        	String siteId = Site.getSiteId();
        	bid = [SELECT OrderApi__Business_Group__r.Id FROM PagesApi__Site__c WHERE PagesApi__Is_Default__c = true LIMIT 1].OrderApi__Business_Group__r.Id;
        }
        co = [SELECT OrderApi__Display_Name__c,OrderApi__Email__c,OrderApi__Phone__c,OrderApi__Homepage_URL__c FROM OrderApi__Business_Group__c WHERE id = : bid];
        
       
        for (OrderApi__Sales_Order_Line__c a : [SELECT OrderApi__Item__c,Membership_Date__c,FON_Sponsored_Account__c,PO_ID__c,Primary_R_T__c,Invoice_Subscription__c,Annual_Dues__c,Amount_Invoiced__c,OrderApi__Overall_Total__c,Volume__c FROM OrderApi__Sales_Order_Line__c where OrderApi__Sales_Order__c =: soID AND OrderApi__Item__r.Name != 'Discount' ORDER BY FON_Sponsored_Account__c ASC]) {
            sol.add(a);
            solTotal = solTotal + a.OrderApi__Overall_Total__c;
        }
        
        List<OrderApi__Sales_Order_Line__c> discs = [SELECT OrderApi__Item__c,Membership_Date__c,FON_Sponsored_Account__c,PO_ID__c,Primary_R_T__c,Invoice_Subscription__c,Annual_Dues__c,Amount_Invoiced__c,OrderApi__Overall_Total__c,Volume__c FROM OrderApi__Sales_Order_Line__c where OrderApi__Sales_Order__c =: soID AND OrderApi__Item__r.Name = 'Discount' LIMIT 1];
        if(discs.size()>0){
            disc = discs[0];
        }
    }

    global List<OrderApi__Sales_Order_Line__c> getSOL() {
        return sol;
    }
    global OrderApi__Sales_Order__c getSO() {
        return so;
    }
    global OrderApi__Business_Group__c getCO() {
        return co;
    }
    global OrderApi__Sales_Order_Line__c getDISC() {
        return disc;
    }
    global Decimal getSOLTOTAL() {
        return solTotal;
    }
}