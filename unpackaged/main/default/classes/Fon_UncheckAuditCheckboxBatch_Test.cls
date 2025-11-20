@IsTest
public class Fon_UncheckAuditCheckboxBatch_Test {

    @IsTest
    public static void cover_All(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id,Sent_Audit_Email__c = false);
        insert con;
        
        Test.startTest();
        Fon_UncheckAuditCheckboxBatch obj = new Fon_UncheckAuditCheckboxBatch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}