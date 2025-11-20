global class RenewPPsNewYearsBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Integer lastYear = Date.today().year() - 1;

        String query = 'SELECT Id, FON_Program_End_Date__c, FON_Program_Start_Date__c, ProgramApi__Account__c, ProgramApi__Contact__c, ProgramApi__Program__c FROM ProgramApi__Program_Profile__c ' + 
            'WHERE CALENDAR_YEAR(FON_Program_End_Date__c) = '+ lastYear;
        //String query = 'SELECT Id, FON_Program_End_Date__c, FON_Program_Start_Date__c, ProgramApi__Account__c, ProgramApi__Contact__c, ProgramApi__Program__c FROM ProgramApi__Program_Profile__c ' + 
        //    'WHERE Id = \'a1t6g000000GbCfAAK\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ProgramApi__Program_Profile__c> pps) {
		Date currentDate = Date.today();
        Integer currentYear = Date.today().year();
        List<ProgramApi__Program_Profile__c> ppsNewYear = [SELECT Id, ProgramApi__Contact__c 
                                                           FROM ProgramApi__Program_Profile__c 
                                                           WHERE CALENDAR_YEAR(FON_Program_Start_Date__c) =: currentYear];
        Set<String> contsWithPPs = new Set<String>();
        for(ProgramApi__Program_Profile__c p : ppsNewYear){
            contsWithPPs.add(p.ProgramApi__Contact__c);
        }
        List<ProgramApi__Program_Profile__c> ppsToInsert = new List<ProgramApi__Program_Profile__c>();
        for(ProgramApi__Program_Profile__c pp : pps){
            if(contsWithPPs.contains(pp.ProgramApi__Contact__c)){
                continue;
            }
            ProgramApi__Program_Profile__c newPP = new ProgramApi__Program_Profile__c();
            newPP.ProgramApi__Account__c = pp.ProgramApi__Account__c;
            newPP.ProgramApi__Contact__c = pp.ProgramApi__Contact__c;
            newPP.ProgramApi__Program__c = pp.ProgramApi__Program__c;
            newPP.ProgramApi__Status__c = 'On Track';
            newPP.FON_Program_Start_Date__c = date.newInstance(currentDate.year(), 1, 1);
            newPP.FON_Program_End_Date__c = date.newInstance(currentDate.year() + 4, 12, 31);
            newPP.Renewed_on_New_Year__c = true;
            newPP.Registration_Origin__c = null;
            ppsToInsert.add(newPP);
        }
        if(ppsToInsert.size() > 0)
            insert ppsToInsert;
    }

    global void finish(Database.BatchableContext BC) {
    }
}