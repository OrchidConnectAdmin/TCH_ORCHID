public class FON_RenewProgramProfilesBatch implements Database.Batchable<SObject>, Database.Stateful{
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'SELECT Id FROM ProgramApi__Program_Profile__c WHERE ProgramApi__Status__c = \'Completed\'';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<ProgramApi__Program_Profile__c> scope){
        Date dateToday = system.today();
        List<ProgramApi__Program__c> p = [SELECT Id FROM ProgramApi__Program__c WHERE Name = 'NCP' LIMIT 1];
        List<ProgramApi__Program_Profile__c> pps = new List<ProgramApi__Program_Profile__c>();
        List<ProgramApi__Program_Term__c> pts = new List<ProgramApi__Program_Term__c>();
        for(ProgramApi__Program_Profile__c sc : scope){
            if(sc.FON_Program_End_Date__c == dateToday){
                ProgramApi__Program_Profile__c pp = new ProgramApi__Program_Profile__c();
                pp.ProgramApi__Contact__c = sc.ProgramApi__Contact__c;
                pp.ProgramApi__Account__c = sc.ProgramApi__Account__c;
                pp.ProgramApi__Status__c = 'On Track';
                pp.FON_Program_Start_Date__c = date.newInstance(dateToday.year() + 1, 1, 1);
                pp.FON_Program_End_Date__c = date.newInstance(dateToday.year() + 5, 12, 31);
                if(p.size() > 0){
                    pp.ProgramApi__Program__c = p[0].Id;
                }else{
                    pp.ProgramApi__Program__c = sc.ProgramApi__Program__c;
                }
                pps.add(pp);
            }
        }
        if(pps.size() > 0){
            insert pps;
        }
        for(ProgramApi__Program_Profile__c pp : pps){
            ProgramApi__Program_Term__c pt = new ProgramApi__Program_Term__c();
            pt.ProgramApi__Start_Date__c = pp.FON_Program_Start_Date__c;
            pt.ProgramApi__Active__c = true;
            pt.Contact__c = pp.ProgramApi__Contact__c;
            pt.ProgramApi__Profile__c = pp.Id;
            pts.add(pt);
        }
        if(pts.size() > 0){
            insert pts;
        }
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
}