@isTest
public class Fon_CEInfoCntrl_Test {
    
    @testSetup static void setupmt() {
        
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
        insert ppp;
        
        
        ProgramApi__Program_Term__c ppt = new ProgramApi__Program_Term__c();
        ppt.ProgramApi__Profile__c = ppp.Id;
        ppt.ProgramApi__Start_Date__c = System.today();
        ppt.ProgramApi__End_Date__c = System.today().addMonths(5);
        ppt.ProgramApi__Active__c = true;
        ppt.Contact__c = con.Id;
        insert ppt;
        
        NCP_Credits__c ncp = new NCP_Credits__c();
        ncp.Program_Term__c = ppt.Id;
        ncp.Contact_Name__c = con.Id;
        ncp.Status__c = 'Pending for Approval';
        insert ncp;
        
        
        
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
        ncs.Minutes_EDU_Submitting__c = '2500';
        insert ncs;
        
        NCP_Credits__c ncpc = new NCP_Credits__c();
        ncpc.Program_Term__c = ppt.Id;
        ncpc.Contact_Name__c = con.Id;
        ncpc.NCP_Session__c = ncs.Id;
        ncpc.Status__c = 'Approved';
        insert ncpc;
        
        Blob b = Blob.valueOf('Test Data');
    	
    	Attachment attachment = new Attachment();
    	attachment.ParentId = ncs.Id;
    	attachment.Name = 'Test Attachment for Parent';
    	attachment.Body = b;
        insert attachment;
    }
    
    @isTest
    public static void fetchCurrentlogged_Test(){
        User u = [SELECT Id FROM User WHERE Email = 'puser000@amamama.com'];
        NCP_Sessions__c ncoSess = [SELECT id,Contact__c FROM NCP_Sessions__c WHERE Name='Test session'];
        Attachment att = [SELECT Id from Attachment];
        NCP_Credits__c ncp = [SELECT Id,FON_Provider_Name__c,NCP_Session__c,
                              NCP_Session__r.Session_Date__c,NCP_Session__r.Description__c
                              FROM NCP_Credits__c 
                              WHERE Status__c = 'Approved'
                              LIMIT 1];
        System.runAs(u) {
            Fon_CEInfoCntrl.fetchCurrentlogged();
            Fon_CEInfoCntrl.fetchNCPCredit();
            Fon_CEInfoCntrl.fecthApprovedSession();
            Fon_CEInfoCntrl.createNCP_CreditRec(ncoSess.Id,'serialtext',/* System.today(),*/System.today(),false,'Test provider',System.today());
            Fon_CEInfoCntrl.getPickListValuesIntoList('NCP_Sessions__c','Status__c');
            Fon_CEInfoCntrl.saveChunk(ncoSess.Id,'test','tt','testing','');
             Fon_CEInfoCntrl.saveChunk(ncoSess.Id,'test','tt','testing',att.Id);
            
            Fon_CEInfoCntrl.manaualCreditRecDetails wrap = new Fon_CEInfoCntrl.manaualCreditRecDetails();
            wrap.audityear = '2020';
            wrap.entryDate = system.today();
            wrap.instructor = 'ty';
            wrap.instructortitle = 'rg';
            wrap.minuteofEDU = 20;
            wrap.providerName = 'Test';
            wrap.sessionDate = System.today();
            wrap.proiderphORemail = 'test@testing.com';
            wrap.speakerCheckbox = false;
            String ncpJson = JSON.serialize(ncp);
            try{
                Fon_CEInfoCntrl.createNCPCreditManaulRec(wrap);
            }catch(exception ex){
                
            }
            
            Fon_CEInfoCntrl.updateNCPRecords(ncpJson);
            Fon_CEInfoCntrl.deleteNCPRec(ncp.Id);
        }
    }
    
    @isTest
    static void createNotes() {
        Test.startTest();
        User u = [SELECT Id FROM User WHERE Email = 'puser000@amamama.com'];
        System.runAs(u){
        Fon_CEInfoCntrl.createNotes('TEST' ,'test');
        }
        Test.stopTest();
    }
    
}