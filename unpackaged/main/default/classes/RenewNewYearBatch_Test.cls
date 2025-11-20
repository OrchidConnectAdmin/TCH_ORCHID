@IsTest(SeeAllData = false)
public class RenewNewYearBatch_Test {
    @IsTest
    public static void testNewYear(){
        ProgramApi__Program__c progNCP = new ProgramApi__Program__c();
        progNCP.Name  = 'NCP';
        progNCP.ProgramApi__Active__c = true;
        insert progNCP;
        
        Date currentDate = system.today();
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
        ProgramApi__Program_Profile__c pp = new ProgramApi__Program_Profile__c();
        pp.ProgramApi__Account__c = acc.Id;
        pp.ProgramApi__Contact__c = con.Id;
        pp.ProgramApi__Program__c = progNcp.Id;
        pp.FON_Program_Start_Date__c = Date.newInstance(currentDate.year() - 2, 1, 1);
        pp.FON_Program_End_Date__c = Date.newInstance(currentDate.year() - 1, 1, 1);
        insert pp;
             
        List<ProgramApi__Program_Profile__c> pps = [SELECT Id 
                                              FROM ProgramApi__Program_Profile__c 
                                              WHERE ProgramApi__Account__c =: acc.Id AND ProgramApi__Contact__c =: con.Id];
        system.assertEquals(1, pps.size());
        
        Test.startTest();
        RenewPPsNewYearsBatch batch = new RenewPPsNewYearsBatch();
        DataBase.executeBatch(batch, 50); 
        Test.stopTest();
        List<ProgramApi__Program_Profile__c> ppsAfterBatch = [SELECT Id 
                                              FROM ProgramApi__Program_Profile__c 
                                              WHERE ProgramApi__Account__c =: acc.Id AND ProgramApi__Contact__c =: con.Id];
        system.assertEquals(2, ppsAfterBatch.size());
        
    }
}