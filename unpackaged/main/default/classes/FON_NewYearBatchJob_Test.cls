@IsTest
public class FON_NewYearBatchJob_Test {
    
    @IsTest
    public static void NewYearBatchJob_Test(){
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
        
         OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'CE Credit Filing Fee';
        insert itm;
        
        NCP_Credits__c ncp1 = new NCP_Credits__c();
        ncp1.Program_Term__c = ppt.Id;
        ncp1.Contact_Name__c = con.Id;
        ncp1.Status__c = 'Pending for Approval';
        ncp1.FON_Session_Date__c =  Date.today().addDays(-366);
        insert ncp1;
        
        
        Test.startTest();
        FON_NewYearBatchJob obj = new FON_NewYearBatchJob();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}