@IsTest
public class FON_NCPCreditService_Test {
    
    /*public static Boolean isInstalled = false;
    
    private static void install() {
        if (!isInstalled) {
            //Fon_PackageScripts.install();
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
            
           
            isInstalled = true;
           
        }
    }

    @IsTest
    public static void createSO_Test(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
        ProgramApi__Program_Profile__c ppp = new ProgramApi__Program_Profile__c();
          ppp.ProgramApi__Account__c = acc.Id;
          ppp.ProgramApi__Contact__c = con.Id;
          ppp.FON_Program_Start_Date__c = System.today();
          ppp.FON_Program_End_Date__c = System.today();
          ppp.Allowed_Workshops__c = 3;
          ppp.Allowed_Credits__c = 2;
          ppp.ProgramApi__Contact__c = con.Id;
          insert ppp;
        
        
        ProgramApi__Program_Term__c ppt = new ProgramApi__Program_Term__c();
        ppt.ProgramApi__Profile__c = ppp.Id;
        insert ppt;
        
       
        install(); 
        
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
        ncp1.Status__c = 'Approved';
        ncp1.FON_Session_Date__c =  Date.today().addDays(-366);
        ncp1.NCP_Session__c = ncs.Id;
        insert ncp1;
        

        
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.name = 'test bg';
        insert bg;
        
        OrderApi__Item_Class__c itemclas = new OrderApi__Item_Class__c();
        itemclas.Name = 'item class';
        insert itemclas;
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.OrderApi__Business_Group__c = bg.Id;
        itm.Name = 'CE Credit Filing Fee';
        itm.OrderApi__Item_Class__c = itemclas.Id;
        insert itm;
        
        OrderApi__Item__c itme = new OrderApi__Item__c();
        itme.Name = 'CE Credits – Late Filing Fee';
        itme.OrderApi__Business_Group__c = bg.Id;
        itme.OrderApi__Item_Class__c = itemclas.Id;
        insert itme;
        
        
        
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.Name = 'item';
        item.OrderApi__Business_Group__c = bg.Id;
        item.OrderApi__Item_Class__c = itemclas.Id;
        insert item;
        
        OrderApi__Sales_Order__c slordr = new OrderApi__Sales_Order__c();
        insert slordr;
            
            
        OrderApi__Sales_Order_Line__c sodrline = new OrderApi__Sales_Order_Line__c();
        sodrline.OrderApi__Item_Class__c = itemclas.Id;
        sodrline.OrderApi__Item__c = item.Id;
        sodrline.OrderApi__Sales_Order__c = slordr.Id;
        sodrline.OrderApi__Item__c = itm.Id;
        insert sodrline;
        
        List<NCP_Credits__c> ncpCridet = new list<NCP_Credits__c>();
        ncpCridet.add(ncp1);
        
        //NCP_Credits__c [] ncpCridet2 = new NCP_Credits__c []();
        //ncpCridet.add(ncp1);
        
        FON_NCPCreditService.createSO(ncpCridet);
        FON_NCPCreditService.setDefaults(ncpCridet);
    }*/
}