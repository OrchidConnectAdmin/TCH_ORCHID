global class UpdateAccountTotalDepositBatchable implements Database.Batchable<sObject>, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id,Total_Deposits__c,Flow_Notes__c,(select Id,Total_Deposits__c,Account_Name__c,Report_Date__c FROM Acquity_Deposit_Information__r WHERE Report_Date__c != null ORDER BY Report_Date__c DESC LIMIT 1) FROM Account');
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of record
        List<Account> lstAccount = new List<Account>();
        for (Account acc : scope) {
            //List<Deposit_Based_Upload_Information__c> dp = new List<Deposit_Based_Upload_Information__c>();
            //dp = [SELECT Id,Total_Deposits__c,Account_Name__c FROM Deposit_Based_Upload_Information__c WHERE Account_Name__c=:acc.Id ORDER BY Report_Date__c DESC LIMIT 1];
            //system.debug('DEPS'+acc.Acquity_Deposit_Information__r);
            if(acc.Acquity_Deposit_Information__r.size() > 0){
                acc.Total_Deposits__c = acc.Acquity_Deposit_Information__r[0].Total_Deposits__c;
                //acc.put('Total_Deposits__c',dp[0].Total_Deposits__c); 
                acc.Flow_Notes__c = 'Bachable Update - '+system.now();
                //acc.put('Flow_Notes__c','Bachable Update - '+system.now()); 
                lstAccount.add(acc);
            }
        }
        update lstAccount;
    }
    global void finish(Database.BatchableContext bc){
        System.debug('>>>Finish');
    }    
 
}