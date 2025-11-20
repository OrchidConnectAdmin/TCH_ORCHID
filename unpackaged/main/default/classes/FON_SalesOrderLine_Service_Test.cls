@isTest
public class FON_SalesOrderLine_Service_Test {
    
    public static Boolean isInstalled = false;
    
    private static void install() {
            if (!isInstalled) {
                //Fon_PackageScripts.install();
                Framework.Installer.install();
                PagesApi.PackageScripts.install();
                OrderApi.PackageScripts.install();
                 EventApi.PackageScripts.install();
                
                // Create a routing rule for Contact
                Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
                Framework.RoutingRule cons = new Framework.RoutingRule();
                cons.apexClass = FON_SalesOrderTrigger.class.getName();
                cons.namespace = 'OrderApi';
                cons.isEnabled = true;
                cons.sObjectName = 'OrderApi__Sales_Order__c';
                cons.executionOrder = 0;
                rules.add(cons);
               
                Framework.Config.push(rules);  
                isInstalled = true;
               
            }
        }
        
    static testMethod void validateItemClassIns_Test() {
        
        Account acc = new Account();
        acc.name = 'AccName';
        insert acc;
        
        Contact con1 = new Contact();
        con1.Lastname = 'con1Lastname';
        con1.Firstname = 'testdata';
        con1.Email = 'test1@email.com';
        con1.AccountId = acc.ID;
        insert con1;
        
        Profile p = [select Id, Name from Profile where Name IN ('Fonteva Customer Community Login User') limit 1];
        
        User newUser = new User(
             profileId = p.id,
             username = 'newUser@yahoo.com',
             emailencodingkey = 'UTF-8',
             localesidkey = 'en_US',
             languagelocalekey = 'en_US',
             timezonesidkey = 'America/Los_Angeles',
             alias='nuser',
             lastname='lastname',
             contactId = con1.id
        );
        newUser.Email = 'test1@email.com';
        insert newUser;
                
        OrderApi__Business_Group__c BG1 =  new OrderApi__Business_Group__c();
        BG1.Name = 'BG1Name';
        insert BG1;
        
        OrderApi__GL_Account__c gl = new OrderApi__GL_Account__c();
        gl.OrderApi__Business_Group__c = BG1.id;
        insert gl;
        
        OrderApi__Item_Class__c itmc = new OrderApi__Item_Class__c();
        itmc.Name = 'Test Class';
        itmc.OrderApi__Is_Subscription__c=false;
        itmc.OrderApi__Enable_Assignments__c = false;
        itmc.OrderApi__Assignment_SObject__c = 'TEST__C';
        itmc.OrderApi__Business_Group__c = BG1.ID;
        itmc.OrderApi__Is_Active__c = true;
        insert itmc;     

        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.OrderApi__Price__c = 100;
        itm.OrderApi__Item_Class__c = itmc.Id;
        itm.OrderApi__Business_Group__c = BG1.Id;
        itm.Name = 'CE Credit Filing Fee';
        itm.OrderApi__Income_Account__c = gl.id;
        itm.OrderApi__Adjustment_Account__c = gl.id;
        itm.OrderApi__Refund_Account__c = gl.id;
        insert itm;                               
        
        Test.startTest();
        
        install();
        
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Contact__c = con1.Id;
        so.OrderApi__Account__c = acc.Id;
        so.OrderApi__Entity__c = 'Contact';
        so.OrderApi__Posting_Entity__c = 'Receipt';
        so.OrderApi__Business_Group__c = BG1.ID;
        so.OrderApi__Schedule_Type__c ='Simple Receipt';
        insert so;
        
        List<OrderApi__Sales_Order_Line__c> lstSOL = new List<OrderApi__Sales_Order_Line__c>();
        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
        sol.OrderApi__Sales_Order__c = so.Id;
        sol.OrderApi__Item__c = itm.Id;
        sol.OrderApi__Business_Group__c = BG1.ID;
        lstSOL.add(sol);             
       
        insert lstSOL;
        
        so.OrderApi__Is_Closed__c = true;
        update so;
        
        so.OrderApi__Is_Posted__c = true;
        update so;
        
        
        Test.stopTest();
       
        
   }
    
    
    
}