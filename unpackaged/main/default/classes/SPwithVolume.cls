public class SPwithVolume {
    @invocableMethod
    
    public static void ItemBasedUploads(List <ID> ItemIds)
    {
        List<Item_Based_Upload_Information__c> ItemBasedUpload = [select Id, Account_Name__C,Parent__c,FON_Total_Volume__c, Account_Name__r.ID, Account_Name__r.Volume__c,Rate__c,Quarter__c from Item_Based_Upload_Information__C where createddate = TODAY and id in: Itemids LIMIT 1];
        system.debug('IBU: '+ ItemBasedUpload);

        For (Item_Based_Upload_Information__c IBU: ItemBasedUpload){
            Sponsoring_Relationships__c sp = new Sponsoring_Relationships__c();
            system.debug('IBU ID:'+IBU.Id);
            //String IBUID = IBU.Sponsored_Relationship__c;
            try {
                sp = [select Id,Volume_Upload__c from Sponsoring_Relationships__c where Sponsored_Organization__c=:IBU.Account_Name__c AND Sponsoring_Organization__c=:IBU.Parent__c LIMIT 1];
                sp.Volume_Upload__c = IBU.FON_Total_Volume__c;
                sp.Rate_Upload__c = IBU.Rate__c;
                //sp.Billing_Quarter__c = IBU.Quarter__c;
                sp.Item_Based_Upload__c= IBU.Id;
                Update sp;
            } catch(DmlException e) {
                System.debug('SPwithVolume Error: ' + e.getMessage());
            }
        }
        
    }
}