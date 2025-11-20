@isTest
public class SPwithVolumeTest {
    @isTest static void getEvent() {
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'Test account';
        insert acc2;
        
        Sponsoring_Relationships__c sp = new Sponsoring_Relationships__c();
        sp.Sponsored_Organization__c = acc.Id;
        sp.Sponsoring_Organization__c = acc2.Id;
        insert sp;
        
        Item_Based_Upload_Information__c ibu = new Item_Based_Upload_Information__c();
        ibu.Account_Name__c = acc.Id;
        ibu.Quarter__c = '1Q';
        ibu.Parent__c = acc2.Id;
        ibu.Rate__c = 0.00080;
        ibu.FON_Total_Item_Based_Deposits__c = 111111;
        ibu.FON_Total_Volume__c	 = 11111;
        ibu.Report_Source__c = 'test';
        insert ibu;
        
        List <ID> ibus = new List <ID>();
        ibus.add(ibu.Id);
       
        //SPwithVolume spv = new SPwithVolume();
        SPwithVolume.ItemBasedUploads(ibus);
        
    }
}