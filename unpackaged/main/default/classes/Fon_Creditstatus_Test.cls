@IsTest
public class Fon_Creditstatus_Test {

      @testSetup static void createData() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
       
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Fonteva Chatter Manager Community Login User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = con.Id
        );
        
        insert u;
        
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
       
          List<NCP_Credits__c> credits = new List<NCP_Credits__c>();
          
          NCP_Credits__c ncp1 = new NCP_Credits__c();
          ncp1.Program_Term__c = ppt.Id;
          ncp1.Contact_Name__c = con.Id;
          ncp1.Status__c = 'Approved';
          credits.add(ncp1);
          
          NCP_Credits__c ncp2 = new NCP_Credits__c();
          ncp2.Program_Term__c = ppt.Id;
          ncp2.Contact_Name__c = con.Id;
          ncp2.Status__c = 'Pending for Approval';
          ncp2.Minutes_of_Education__c = 200;
          credits.add(ncp2);
          
          NCP_Credits__c ncp3 = new NCP_Credits__c();
          ncp3.Program_Term__c = ppt.Id;
          ncp3.Contact_Name__c = con.Id;
          ncp3.Status__c = 'Approved';
          ncp3.Minutes_of_Education__c = 200;
          ncp3.Session_Type__c = 'NCP CE Workshop';
          credits.add(ncp3);
          
          NCP_Credits__c ncp4 = new NCP_Credits__c();
          ncp4.Program_Term__c = ppt.Id;
          ncp4.Contact_Name__c = con.Id;
          ncp4.Status__c = 'Pending for Approval';
          ncp4.Minutes_of_Education__c = 200;
          ncp4.Session_Type__c = 'NCP CE Workshop';
          credits.add(ncp4);
          
          insert credits;
       
    }
    
    @IsTest
    public static void coverAllMt(){
        User u = [SELECT Id FROM User WHERE Email = 'puser000@amamama.com'];
        System.runAs(u) {
            Fon_Creditstatus.fetchonLoadWrapper();
        }
    }
}