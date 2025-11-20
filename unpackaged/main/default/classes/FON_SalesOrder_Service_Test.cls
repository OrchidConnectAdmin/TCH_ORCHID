@isTest(SeeAllData=False)
public class FON_SalesOrder_Service_Test {
 public static Boolean isInstalled = false;
    
    @testSetup static void testSetup(){
        CandidateId__c newCI = new CandidateId__c();
        newCI.Candidate_Id_Number__c = 0;
        newCI.Candidate_Id_Text__c= 'HRNCP';
        insert newCI;
        
        Account acc = new Account();
        acc.Name = 'testAcc';
        insert acc;
        
        Contact cont = new Contact();
        cont.LastName = 'LastName';
        cont.AccountId = acc.Id;
        cont.FON_Exam_Year__c = system.today().year();
        insert cont;
        
        EventApi__Event__c event = new EventApi__Event__c();
        event.EventApi__Event_Key__c = 'test1238512';
        event.Is_NCP_Exam__c = true;
        event.Name = 'Exam Test';
        insert event;
        
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Account__c = acc.Id;
        so.OrderApi__Contact__c = cont.Id;
        insert so;
        
        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
        sol.EventApi__Event__c = event.Id;
        sol.OrderApi__Sales_Order__c = so.Id;
        sol.OrderApi__Account__c = acc.Id;
        sol.OrderApi__Contact__c = cont.Id;
        insert sol;
    }
    
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
        
        Account acc2 = new Account();
        acc2.name = 'Acc2Name';
        insert acc2;
        
        Contact con1 = new Contact();
        con1.Lastname = 'con1Lastname';
        con1.Firstname = 'testdata';
        con1.Email = 'test1@email.com';
        con1.AccountId = acc.ID;
        con1.FON_Exam_Year__c = system.today().year();
        insert con1;
        
        Contact con2 = new Contact();
        con2.Lastname = 'con2Lastname';
        con2.Firstname = 'testdata';
        con2.Email = 'test2@email.com';
        con2.AccountId = acc2.ID;
        con2.FON_Exam_Year__c = system.today().year();
        insert con2;
        
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
        
        OrderApi__Sales_Order__c so2 = new OrderApi__Sales_Order__c();
        so2.OrderApi__Contact__c = con2.Id;
        so2.OrderApi__Account__c = acc2.Id;
        so2.OrderApi__Entity__c = 'Contact';
        so2.OrderApi__Posting_Entity__c = 'Receipt';
        so2.OrderApi__Business_Group__c = BG1.ID;
        so2.OrderApi__Schedule_Type__c ='Simple Receipt';
        insert so2;
        
        List<EventApi__Event__c> event = [SELECT Id FROM EventApi__Event__c];
        
        Contact contBefore = [SELECT Id, FON_NCP_Candidate_ID__c, FON_Candidate_Id_Generated_On__c FroM Contact WHERE Id =: con1.Id];
        system.assertEquals(contBefore.FON_NCP_Candidate_ID__c, null);
        system.assertEquals(contBefore.FON_Candidate_Id_Generated_On__c, null);
        
        List<OrderApi__Sales_Order_Line__c> lstSOL = new List<OrderApi__Sales_Order_Line__c>();
        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
        sol.OrderApi__Contact__c = con1.Id;
        sol.OrderApi__Account__c = acc.Id;
        sol.OrderApi__Sales_Order__c = so.Id;
        sol.OrderApi__Item__c = itm.Id;
        sol.OrderApi__Business_Group__c = BG1.ID;
        sol.EventApi__Event__c = event[0].Id;
        lstSOL.add(sol);
        
        insert lstSOL;
                
        Contact contUpdated = [SELECT Id, FON_NCP_Candidate_ID__c, FON_Candidate_Id_Generated_On__c FroM Contact WHERE Id =: con1.Id];
        system.assertNotEquals(contUpdated.FON_NCP_Candidate_ID__c, null);
        system.assertNotEquals(null, contUpdated.FON_Candidate_Id_Generated_On__c);
        
        
        OrderApi__Sales_Order_Line__c sol2 = new OrderApi__Sales_Order_Line__c();
        sol2.OrderApi__Contact__c = con1.Id;
        sol2.OrderApi__Account__c = acc.Id;
        sol2.OrderApi__Sales_Order__c = so.Id;
        sol2.OrderApi__Item__c = itm.Id;
        sol2.OrderApi__Business_Group__c = BG1.ID;
        sol2.EventApi__Event__c = event[0].Id;
        
        insert sol2;
                
        Contact contUpdated2 = [SELECT Id, FON_NCP_Candidate_ID__c, FON_Candidate_Id_Generated_On__c FroM Contact WHERE Id =: con1.Id];
        system.assertNotEquals(null, contUpdated2.FON_NCP_Candidate_ID__c);
        system.assertNotEquals(null, contUpdated2.FON_Candidate_Id_Generated_On__c);
                    
        OrderApi__Sales_Order_Line__c sol3 = new OrderApi__Sales_Order_Line__c();
        sol3.OrderApi__Contact__c = con2.Id;
        sol3.OrderApi__Account__c = acc2.Id;
        sol3.OrderApi__Sales_Order__c = so2.Id;
        sol3.OrderApi__Item__c = itm.Id;
        sol3.OrderApi__Business_Group__c = BG1.ID;
        sol3.EventApi__Event__c = event[0].Id;
        
        insert sol3;
                
        Contact contUpdated3 = [SELECT Id, FON_NCP_Candidate_ID__c, FON_Candidate_Id_Generated_On__c FroM Contact WHERE Id =: con2.Id];
        system.assertNotEquals(null, contUpdated3.FON_NCP_Candidate_ID__c);
        system.assertNotEquals(null, contUpdated3.FON_Candidate_Id_Generated_On__c);
        
        Test.stopTest();
       
        
   }
    
    
    
}