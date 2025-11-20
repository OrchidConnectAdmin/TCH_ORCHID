@isTest
public class AccountwithUploadTest {
    @isTest static void getEvent() {
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;       
       
        Deposit_Based_Upload_Information__c ibu = new Deposit_Based_Upload_Information__c();
        ibu.Account_Name__c = acc.Id;
        ibu.Primary_R_T_Number__c = '564454523';
        ibu.Report_Source__c = 'test source';
        ibu.Total_Deposits__c = 111111;
        ibu.Name = 'test';
        insert ibu;
        
        List <ID> ibus = new List <ID>();
        ibus.add(ibu.Id);
       
        //SPwithVolume spv = new SPwithVolume();
        AccountwithUpload.ItemBasedUploads(ibus);
        
    }
}