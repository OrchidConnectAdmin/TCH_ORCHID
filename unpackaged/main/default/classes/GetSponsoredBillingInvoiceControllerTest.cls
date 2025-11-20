@isTest
public class GetSponsoredBillingInvoiceControllerTest {
    @isTest static void getEvent() {
        //get user
        //User tuser = [Select Id,Name FROM User WHERE Id='0056g000004isrTAAQ'];
        //CME__c cme  = [Select Name,Contact__r.Id,Contact__r.Name,Date__c,Event__r.Certificate_Type_Awarded__c,Event__r.Id,Event__r.Name,Event__r.COC_Header_Logo__c,Expiration__c,OwnerId,Status__c,Title__c,Value__c from CME__c where id = 'a392h0000003r4cAAA'];
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.Name = 'Test BG';
        insert bg;
        
    	OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Contact__c = con.Id;
        so.OrderApi__Account__c = acc.Id;
        so.OrderApi__Business_Group__c = bg.Id;
        so.OrderApi__Entity__c = 'Account';
        so.OrderApi__Status__c = 'Open';
        insert so;
                
        //create item class
        OrderApi__Item_Class__c ic = new OrderApi__Item_Class__c();
        ic.Name = 'Item Class';
        ic.OrderApi__Is_Active__c = true;
        insert ic;
        
        // create item
        OrderApi__Item__c it = new OrderApi__Item__c();
        it.OrderApi__Item_Class__c = ic.Id;
        it.OrderApi__Business_Group__c = bg.Id;
        it.OrderApi__Is_Active__c = true;
        insert it;
        
        List<OrderApi__Sales_Order_Line__c> sols = new List<OrderApi__Sales_Order_Line__c>();
    	
		OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c(); 
        sol.OrderApi__Account__c = acc.Id;
        sol.OrderApi__Contact__c = con.Id;
        sol.OrderApi__Quantity__c = 1;
        sol.OrderApi__Sales_Order__c = so.Id;
        sol.OrderApi__Entity__c = 'Account';
        sol.OrderApi__Overall_Total__c = 50;
        insert sol;
        sols.add(sol);
        
       // system.runAs(tuser){
            Test.startTest();
            
                PageReference pageRef = Page.SponsoredBillingInvoicePDF;
                Test.setCurrentPage(pageRef);
            	System.currentPageReference().getParameters().put('id',so.Id);
            
                GetSponsoredBillingInvoiceController gpdf = new GetSponsoredBillingInvoiceController();
                System.debug('Test1xxx' + gpdf);
        		List<SObject> gsol = gpdf.getSOL();
                System.assertEquals(1, gsol.size());
        
                SObject gso = gpdf.getSO();
                System.assertEquals(so.Id, gso.Id);
        
        		SObject gco = gpdf.getCO();
                System.assertEquals(bg.Id, gco.Id);
        
            

            
            Test.stopTest();
       // }
    }
}