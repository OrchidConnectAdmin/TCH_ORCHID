global without sharing class CHA_ProgramTermsBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id,ProgramApi__Start_Date__c,ProgramApi__End_Date__c,ProgramApi__Active__c FROM ProgramApi__Program_Term__c WHERE (ProgramApi__Start_Date__c <= TODAY AND ProgramApi__End_Date__c > TODAY AND ProgramApi__Active__c = false) OR ( ProgramApi__End_Date__c <= TODAY AND ProgramApi__Active__c = true)');
    }
    global void execute(Database.BatchableContext bc, List<ProgramApi__Program_Term__c> scope){
        
        Date tDay = System.Today();
        // lists to update
        List<ProgramApi__Program_Term__c> expireTerms = new List<ProgramApi__Program_Term__c>();
        List<ProgramApi__Program_Term__c> activateTerms =  new List<ProgramApi__Program_Term__c>();
        
        for(ProgramApi__Program_Term__c pt : scope){
            if(pt.ProgramApi__Start_Date__c <= tDay && pt.ProgramApi__End_Date__c > tDay && pt.ProgramApi__Active__c == false){
                pt.ProgramApi__Active__c = true;
                activateTerms.add(pt);
            }
            if(pt.ProgramApi__End_Date__c < tDay && pt.ProgramApi__Active__c == true){
                pt.ProgramApi__Active__c = false;
                expireTerms.add(pt);
            }
        }
        
        update activateTerms;
        update expireTerms;
        
    }
    global void finish(Database.BatchableContext bc){
        
    }
    
    
}