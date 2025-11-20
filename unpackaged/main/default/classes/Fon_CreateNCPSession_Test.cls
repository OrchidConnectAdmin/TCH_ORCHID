@IsTest
public class Fon_CreateNCPSession_Test {

    
     @testSetup static void createData() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
        Contact cont = new contact(LastName='Test Cont',AccountId = acc.Id);
        insert cont;
        
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
            ContactId = con.Id);
        insert u;
        
       
         
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
         insert ncs;
         
         OrderApi__Sales_Order__c oSO = new OrderApi__Sales_Order__c();
         oSO.OrderApi__Account__c = acc.Id;
         oSO.OrderApi__Contact__c = con.Id;
         oSO.Application__c = app.Id;
         insert oSO;
        
    }
    
    @IsTest
    public static void cover_All(){
         User u = [SELECT Id FROM User WHERE Email = 'puser000@amamama.com'];
        OrderApi__Sales_Order__c so = [Select Id From OrderApi__Sales_Order__c];
        Application__c appRec = [Select Id,Account__c From Application__c];
        System.runAs(u) {
            
            NCP_Sessions__c ncs = new NCP_Sessions__c();
            ncs.Name = 'Test session';
            ncs.Status__c = 'Approved';
            ncs.Account__c = appRec.Account__c;
             ncs.Application__c = appRec.Id;
            
            Fon_CreateNCPSession.createCloneNCPSession(ncs);
        }
        
        

    }
    
    @IsTest
    public static void handleComponentLoad_Test(){
         Fon_CreateNCPSession.handleComponentLoad();
    }
    
    
    @IsTest
    public static void createSalesOrderLines_Test(){
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
            ContactId = con.Id);
        insert u;
        
       
         
         Application__c app = new Application__c();
         app.Account__c = acc.Id;
         app.Contact__c = con.Id;
         app.IsPaid__c = false;
         insert app;
         
         NCP_Sessions__c ncs = new NCP_Sessions__c();
         ncs.Name = 'Test session';
         ncs.Account__c = acc.Id;
         ncs.Contact__c = con.Id;
         ncs.Application__c = app.Id;
         ncs.Status__c = 'Approved';
         insert ncs;
         
         OrderApi__Sales_Order__c oSO = new OrderApi__Sales_Order__c();
         oSO.OrderApi__Account__c = acc.Id;
         oSO.OrderApi__Contact__c = con.Id;
         oSO.Application__c = app.Id;
         insert oSO;
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'NCP Session Application Fee';
        insert itm;
        
         System.runAs(u) {
            Fon_CreateNCPSession.createSalesOrderLines(oSO);
             
         }

    }
}