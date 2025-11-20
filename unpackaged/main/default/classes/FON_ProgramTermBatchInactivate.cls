global class FON_ProgramTermBatchInactivate implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {

        Integer currentYear = Date.today().year();

        String query = 'SELECT Id, ProgramApi__Active__c, ProgramApi__End_Date__c, ProgramApi__Start_Date__c FROM ProgramApi__Program_Term__c ' + 
            'WHERE ProgramApi__Profile__c != null AND Contact__c != null AND CALENDAR_YEAR(ProgramApi__Start_Date__c ) != ' + currentYear;
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ProgramApi__Program_Term__c> terms) {
		
        List<ProgramApi__Program_Term__c> termsToUpdate = new List<ProgramApi__Program_Term__c>();
        
        for(ProgramApi__Program_Term__c term : terms){
            if(term.ProgramApi__Active__c){
                term.ProgramApi__Active__c = false;
                if(term.ProgramApi__End_Date__c.year() != term.ProgramApi__Start_Date__c.year()){
                    term.ProgramApi__End_Date__c = date.newInstance(term.ProgramApi__Start_Date__c.year(), 12, 31);
                }
                termsToUpdate.add(term);
            }
        }
        if(termsToUpdate.size() > 0)
            update termsToUpdate;
    }

    global void finish(Database.BatchableContext BC) {
        Database.executeBatch(new FON_ProgramTermBatchActivate(), 50);
    }
}