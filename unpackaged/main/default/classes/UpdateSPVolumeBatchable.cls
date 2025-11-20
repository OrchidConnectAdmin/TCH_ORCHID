global class UpdateSPVolumeBatchable implements Database.Batchable<sObject>, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String processDate = System.Label.Volume_Upload_Process_Date;
        String ddate;
        String ddate2;
        Pattern p = Pattern.compile('.*\\d+.*');
        Matcher m = p.matcher(processDate);
        
        Boolean hasNumber = m.matches();
        system.debug('HAS NUMBER '+hasNumber);
        if(!hasNumber){
            ddate = processDate;
        }else{
            ddate = processDate + 'T00:00:00Z';
            ddate2 = processDate + 'T23:59:00Z';
        }
        //return Database.getQueryLocator('SELECT Id,Sponsored_Organization__c,Sponsoring_Organization__c,Billing_Quarter__c,Rate_Upload__c,Volume_Upload__c,Flow_Notes__c FROM Sponsoring_Relationships__c');
        //system.debug('QUERY '+'SELECT Id,(select Id,Sponsored_Organization__c,Sponsoring_Organization__c,Billing_Quarter__c,Rate_Upload__c,Volume_Upload__c,Flow_Notes__c FROM Sponsoring_Relationships1__r),(select Id,Parent__c,Account_Name__c,FON_Total_Volume__c,Rate__c,Quarter__c FROM Item_Based_Uploads__r ORDER BY Report_Date__c DESC LIMIT 1) FROM Account WHERE Id IN (SELECT Sponsored_Organization__c FROM Sponsoring_Relationships__c) AND Id IN (SELECT Account_Name__c FROM Item_Based_Upload_Information__c WHERE CreatedDate ='+ ddate +')');
        String qry = 'SELECT Id,(select Id,Sponsored_Organization__c,Sponsoring_Organization__c,Billing_Quarter__c,Rate_Upload__c,Volume_Upload__c,Flow_Notes__c FROM Sponsoring_Relationships1__r),(select Id,Parent__c,Account_Name__c,FON_Total_Volume__c,Rate__c,Quarter__c FROM Item_Based_Uploads__r ORDER BY Report_Date__c DESC LIMIT 1) FROM Account WHERE Id IN (SELECT Sponsored_Organization__c FROM Sponsoring_Relationships__c) AND Id IN (SELECT Account_Name__c FROM Item_Based_Upload_Information__c WHERE CreatedDate ='+ddate+')';
        if(hasNumber){
            qry = 'SELECT Id,(select Id,Sponsored_Organization__c,Sponsoring_Organization__c,Billing_Quarter__c,Rate_Upload__c,Volume_Upload__c,Flow_Notes__c FROM Sponsoring_Relationships1__r),(select Id,Parent__c,Account_Name__c,FON_Total_Volume__c,Rate__c,Quarter__c FROM Item_Based_Uploads__r ORDER BY Report_Date__c DESC LIMIT 1) FROM Account WHERE Id IN (SELECT Sponsored_Organization__c FROM Sponsoring_Relationships__c) AND Id IN (SELECT Account_Name__c FROM Item_Based_Upload_Information__c WHERE CreatedDate >='+ddate+' AND CreatedDate <='+ddate2+')';
        }
        return Database.getQueryLocator(qry);
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of record
        List<Sponsoring_Relationships__c> lst = new List<Sponsoring_Relationships__c>();
        
        for (Account acc : scope) {
            
            List<Sponsoring_Relationships__c> sr = new List<Sponsoring_Relationships__c>();
                sr = acc.Sponsoring_Relationships1__r;
            List<Item_Based_Upload_Information__c> ib = new List<Item_Based_Upload_Information__c>();
                ib = acc.Item_Based_Uploads__r;
            
            for (Sponsoring_Relationships__c s : sr) {
                for (Item_Based_Upload_Information__c i : ib) {
                    if( i.Account_Name__c==s.Sponsored_Organization__c && i.Parent__c==s.Sponsoring_Organization__c ){
                            //s.Billing_Quarter__c = i.Quarter__c;
                            s.Rate_Upload__c = i.Rate__c;
                            s.Volume_Upload__c = i.FON_Total_Volume__c;
                        	s.Item_Based_Upload__c=i.Id;
                            s.Flow_Notes__c = 'Bachable Update - '+system.now();
                    }
                }
                lst.add(s);
            }

        }
        
        update lst;
    }

    
    global void finish(Database.BatchableContext bc){
        System.debug('>>>Finish');
    }    
 
}