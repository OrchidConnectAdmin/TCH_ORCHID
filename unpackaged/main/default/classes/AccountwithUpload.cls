public class AccountwithUpload {
    @invocableMethod
    
    public static void ItemBasedUploads(List <ID> ItemIds)
    {
        List<Deposit_Based_Upload_Information__c> Uploads = [select Id, Account_Name__c,Total_Deposits__c from Deposit_Based_Upload_Information__c where createddate = TODAY and id in: Itemids LIMIT 1];
        system.debug('IBU: '+ Uploads);

        For (Deposit_Based_Upload_Information__c IBU: Uploads){
            Account acc = new Account();
            system.debug('IBU ID:'+IBU.Id);
            //String IBUID = IBU.Sponsored_Relationship__c;
            try {
                acc = [select Id,Total_Deposits__c from Account where Id=:IBU.Account_Name__c LIMIT 1];
                acc.Total_Deposits__c = IBU.Total_Deposits__c;
                Update acc;
            } catch(DmlException e) {
                System.debug('SPwithVolume Error: ' + e.getMessage());
            }
        }
        
    }
}