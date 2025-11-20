@IsTest
public class FON_ProgramProfileTriggerTest {
    
    public static boolean isInstalled = false;
    public static void install(){
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            ProgramApi.PackageScripts.install();
            
            // Create a routing rule for Contact
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
            cons.apexClass = FON_ProgramProfileTrigger.class.getName();
            cons.namespace = 'ProgramApi';
            cons.isEnabled = true;
            cons.sObjectName = 'ProgramApi__Program_Profile__c';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);               
            
            isInstalled = true;
            
        }
    }
    
    
    @IsTest
    public static void testMethod_All(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
        OrderApi__Item__c itme = new OrderApi__Item__c();
        itme.Name = 'CE Credits – Late Filing Fee';
        insert itme;
        
        OrderApi__Item_Class__c itemclas = new OrderApi__Item_Class__c();
        itemclas.Name = 'item class';
        insert itemclas;
        
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.Name = 'item';
        item.OrderApi__Item_Class__c = itemclas.Id;
        insert item;
        
        OrderApi__Sales_Order__c slordr = new OrderApi__Sales_Order__c();
        insert slordr;
        
        
        OrderApi__Sales_Order_Line__c sodrline = new OrderApi__Sales_Order_Line__c();
        sodrline.OrderApi__Item_Class__c = itemclas.Id;
        sodrline.OrderApi__Item__c = item.Id;
        sodrline.OrderApi__Sales_Order__c = slordr.Id;
        insert sodrline;
        
        ProgramApi__Program__c pp = new ProgramApi__Program__c();
        pp.Name = 'NCP';
        pp.ProgramApi__Entity__c = 'Contact';
        insert pp;
        
        OrderApi__Badge_Type__c badgetype = new OrderApi__Badge_Type__c();
        badgetype.name = 'NCP Maintenance Badge';
        insert badgetype;
        
        OrderApi__Badge__c badge = new OrderApi__Badge__c();
        badge.OrderApi__Badge_Type__c = badgetype.Id;
        badge.OrderApi__Is_Active__c = true;
        insert badge;
        
        ProgramApi__Program_Profile__c ppp = new ProgramApi__Program_Profile__c();
        ppp.ProgramApi__Account__c = acc.Id;
        ppp.ProgramApi__Contact__c = con.Id;
        ppp.FON_Program_Start_Date__c = System.today();
        //ppp.FON_Program_End_Date__c = System.today().addMonths(3);
        ppp.Allowed_Workshops__c = 3;
        ppp.Allowed_Credits__c = 2;
        ppp.ProgramApi__SalesOrderLineId__c = sodrline.Id;
        ppp.ProgramApi__Program__c = pp.Id;
        ppp.FON_Exam_Results__c = 'Fail';
        ppp.ProgramApi__Status__c = 'Exempt';
        
        install();
        insert ppp;        
        
        
        ppp.FON_Exam_Results__c = 'Pass';
        ppp.ProgramApi__Status__c = 'On Track';
        ppp.Allowed_Credits__c = 4;
        update ppp;
        
    }
}