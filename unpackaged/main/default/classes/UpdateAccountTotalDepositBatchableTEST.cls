@isTest 
public class UpdateAccountTotalDepositBatchableTEST 
{
    static testMethod void testMethod1() 
    {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc',Primary_R_T_Number__c = '12345678');
        insert acc;
        
        Deposit_Based_Upload_Information__c dp = new Deposit_Based_Upload_Information__c();
        dp.Account_Name__c = acc.Id;
        dp.Report_Date__c = system.today();
        dp.Report_Source__c = 'Sample';
        dp.Total_Deposits__c = 3333;
        dp.Primary_R_T_Number__c = '12345678';
        insert dp;
        
        Test.startTest();

            UpdateAccountTotalDepositBatchable obj = new UpdateAccountTotalDepositBatchable();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}