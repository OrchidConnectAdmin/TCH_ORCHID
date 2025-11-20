@IsTest
public class FON_NCPCreditsRuleTest  {
    
    @TestSetup
    private static void install() {

            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            Framework.RegisteredObject[] regObjects = new List<Framework.RegisteredObject>();
            Framework.RegisteredObject profobj = new Framework.RegisteredObject();
                profobj.sObjectName = 'NCP_Credits__c';
                profobj.apexClass = FON_NCPCreditTrigger.class.getName();
                profobj.namespace = '';
                profobj.isEnabled = true;
                profobj.isStandard = true;
                profobj.triggersEnabled = true;
                profobj.soqlLimit = String.valueOf(2000);
                profobj.soqlOrderBy = 'Name ASC';
                regObjects.add(profobj);
            Framework.Config.push(regObjects);
            
            // Create a routing rule for Contact
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
            cons.apexClass = FON_NCPCreditsRule.class.getName();
            cons.namespace = '';
            cons.isEnabled = true;
            cons.sObjectName = 'NCP_Credits__c';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);               
            



    }
    
    @IsTest
    public static void NewYearBatchJob_Test(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();

		OrderApi__Business_Group__c businessGroup = new OrderApi__Business_Group__c(Name='test');
        insert businessGroup;
        //system.debug(' '+);
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        //system.debug(' '+);
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        //system.debug(' '+);
        
        ProgramApi__Program_Profile__c ppp = new ProgramApi__Program_Profile__c();
        ppp.ProgramApi__Account__c = acc.Id;
        ppp.ProgramApi__Contact__c = con.Id;
        ppp.FON_Program_Start_Date__c = System.today();
        ppp.FON_Program_End_Date__c = System.today();
        ppp.Allowed_Workshops__c = 3;
        ppp.Allowed_Credits__c = 2;
        ppp.ProgramApi__Contact__c = con.Id;
        insert ppp;
        //system.debug(' '+);
        
        
        ProgramApi__Program_Term__c ppt = new ProgramApi__Program_Term__c();
        ppt.ProgramApi__Profile__c = ppp.Id;
        insert ppt;
        //system.debug(' '+);
        
        OrderApi__Item_Class__c itemClass = new OrderApi__Item_Class__c();
        itemClass.Name = 'item class test';
        insert itemClass;
        //system.debug(' '+);
        
         OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'CE Credit Filing Fee';
        itm.OrderApi__Business_Group__c = businessGroup.Id;
        itm.OrderApi__Item_Class__c = itemClass.Id;
        insert itm;
        //system.debug(' '+);

         OrderApi__Item__c itm2 = new OrderApi__Item__c();
        itm2.Name = 'CE Credits – Late Filing Fee';
        itm2.OrderApi__Business_Group__c = businessGroup.Id;
        itm2.OrderApi__Item_Class__c = itemClass.Id;
        insert itm2;

         Application__c app = new Application__c();
         app.Account__c = acc.Id;
         app.Contact__c = con.Id;
         insert app;
         
         NCP_Sessions__c ncs = new NCP_Sessions__c();
         ncs.Name = 'Test session';
         ncs.Account__c = acc.Id;
         ncs.Contact__c = con.Id;
         ncs.Application__c = app.Id;
         ncs.Status__c = 'Approved';
        ncs.Session_Date__c = System.today();
        ncs.Instructor__c = 'ins';
        ncs.Minutes_EDU_Submitting__c = '60';
        ncs.Description__c = 'desc';
        ncs.Session_Title__c = 'sesh title';
         insert ncs;

        
        NCP_Credits__c ncp1 = new NCP_Credits__c();
        ncp1.Program_Term__c = ppt.Id;
        ncp1.Contact_Name__c = con.Id;
        ncp1.Status__c = 'Pending for Approval';
        ncp1.FON_Session_Date__c = Date.today().addDays(-366);
        ncp1.NCP_Session__c = ncs.Id;
        insert ncp1;
        //system.debug(' '+);
        
        ncp1.FON_Session_Date__c =  Date.today().addDays(-386);
        update ncp1;
        
        Test.startTest();
        	
        Test.stopTest();
    }
}