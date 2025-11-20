@isTest 
public class UpdateSPVolumeBatchableTEST 
{
    static testMethod void testMethod1() 
    {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc',Primary_R_T_Number__c = '12345678');
        insert acc;
        
        Account acc2 = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc2',Primary_R_T_Number__c = '12345651');
        insert acc2;
        
        Sponsoring_Relationships__c sp = new Sponsoring_Relationships__c();
        sp.Sponsored_Organization__c = acc2.Id;
        sp.Sponsoring_Organization__c = acc.Id;
        insert sp;
        
        Item_Based_Upload_Information__c dp = new Item_Based_Upload_Information__c();
        dp.Account_Name__c = acc2.Id;
        dp.Parent__c = acc.Id;
        dp.Report_Date__c = system.today();
        dp.Report_Source__c = 'Sample';
        dp.FON_Total_Volume__c = 3333;
        dp.Rate__c = 0.00058;
        dp.Quarter__c = '1Q';
        insert dp;
        
        Test.startTest();

            UpdateSPVolumeBatchable obj = new UpdateSPVolumeBatchable();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}