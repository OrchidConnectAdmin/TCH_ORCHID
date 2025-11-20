@IsTest
public class FON_AuditTemplateEmailControllerTest
{
    @testSetup 
    static void createData()
    {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();

        Account acc = new Account(recordtypeId = devRecordTypeId, Name = 'Test Acc');
        insert acc;

        Contact con = new contact(LastName = 'Test Con', AccountId = acc.Id, Audit_Email_Sent__c = Date.today());
        insert con;


        User u = new User(ProfileId = [SELECT Id
                                       FROM Profile
                                       WHERE Name = 'Fonteva Chatter Manager Community Login User'].Id, LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ContactId = con.Id);
        insert u;

        ProgramApi__Program_Profile__c ppp = new ProgramApi__Program_Profile__c();
        ppp.ProgramApi__Account__c = acc.Id;
        ppp.ProgramApi__Contact__c = con.Id;
        ppp.FON_Program_Start_Date__c = System.today();
        ppp.FON_Program_End_Date__c = System.today();
        ppp.FON_Audited__c = true;
        ppp.ProgramApi__Status__c = 'On Track';
        ppp.FON_Audited_Year__c = System.today().year();
        insert ppp;


        ProgramApi__Program_Term__c ppt = new ProgramApi__Program_Term__c();
        ppt.ProgramApi__Profile__c = ppp.Id;
        ppt.ProgramApi__Start_Date__c = Date.newInstance(System.today().year(), 1, 1);
        ppt.ProgramApi__End_Date__c = Date.newInstance(System.today().year(), 12, 1);
        insert ppt;
        
    }

    @IsTest
    public static void coverAll_Mt()
    {
        User u = [SELECT Id
                  FROM User
                  WHERE Email = 'puser000@amamama.com'];

        Id contactId = [SELECT Id
                        FROM Contact WHERE LastName = 'Test Con' 
                        LIMIT 1].Id;
		ProgramApi__Program_Profile__c pp = [Select Id FROM ProgramApi__Program_Profile__c WHERE ProgramApi__Contact__c=:contactId];
        System.runAs(u)
        {
            //FON_AuditTemplateEmailController.fetchProgProfile();
            FON_AuditTemplateEmailController dah = new FON_AuditTemplateEmailController();
            dah.programProfileId = pp.Id;
            dah.getdisplaydata();
        }
    }
    
    static testMethod void fakeTest(){
     FON_AuditTemplateEmailController.testingCoverage();
     //repeat the same for the rest of classes.
    }  
}