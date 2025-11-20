global class Fon_UncheckAuditCheckboxBatch implements Database.Batchable<sObject>, Schedulable{ 
   
    /************ Schedule Class Execte **********/
    global void execute(SchedulableContext SC) {
        database.executeBatch(new Fon_UncheckAuditCheckboxBatch());
    }
   
    /******* Batch class start Method *******/
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT ID,Sent_Audit_Email__c FROM Contact WHERE Sent_Audit_Email__c = false');
    }     
   
    /******** Batch class Execute Method ********/
    public void execute(Database.BatchableContext info, List<Contact> scope){
        List<Contact> consToUpdate = new List<Contact>();
        for(Contact con : scope){ 
            con.Sent_Audit_Email__c = false; 
        } 
        update consToUpdate; 
    }   

    /********** Batch class finish ********/
    public void finish(Database.BatchableContext info){     
    } 
}