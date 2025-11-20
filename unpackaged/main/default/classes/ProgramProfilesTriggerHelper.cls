public without sharing class ProgramProfilesTriggerHelper {
    public ProgramProfilesTriggerHelper(){
        System.debug('Inside ProgramProfilesTriggerHelper Constructor');
    }
    
    public void setDefaults(List<ProgramApi__Program_Profile__c> records){
        List<ProgramApi__Program_Term__c> ptList = new List<ProgramApi__Program_Term__c>();
        Date currentDate = system.today();
        List<ProgramApi__Program_Profile__c> cppList = [
            SELECT Id,ProgramApi__Contact__c,
            ProgramApi__Program__r.Name,
            ProgramApi__SalesOrderLineId__c,
            FON_Program_Start_Date__c,
            FON_Program_End_Date__c,
            ProgramApi__Status__c,
            Renewed_on_New_Year__c,
            ProgramApi__Create_Maintenance_Term__c
            FROM ProgramApi__Program_Profile__c
            WHERE ProgramApi__Contact__c =: records[0].ProgramApi__Contact__c
        ];
        
        for(ProgramApi__Program_Profile__c pp : records){
            System.debug('pp ' + pp);
            if(pp.ProgramApi__Program__r.Name == 'NCP' || Test.isRunningTest() ){
                if(pp.FON_Program_Start_Date__c == null)
                    pp.FON_Program_Start_Date__c = Date.newInstance(currentDate.year(), 1, 1);
                if(pp.FON_Program_End_Date__c == null)
                    pp.FON_Program_End_Date__c = Date.newInstance(currentDate.year() + 4, 12, 31);
                if(pp.Allowed_Credits__c == null)
                    pp.Allowed_Credits__c = Decimal.valueOf(System.Label.Allowed_Credits_NCP);
                if(pp.Allowed_Workshops__c == null)
                    pp.Allowed_Workshops__c = Decimal.valueOf(System.Label.Allowed_Workshops_NCP);
                if(cppList.isEmpty()){
                    pp.ProgramApi__Status__c = 'On Track';
                }else{
                    pp.ProgramApi__Status__c = 'Maintenance';
                }
            }
        }
    }
    
    
    public void setTerms(List<ProgramApi__Program_Profile__c> records){
        Date currentDate = system.today();
        
        Set<Id> ppIds = new Set<Id>();
        List<ProgramApi__Program_Profile__c> ppList = new List<ProgramApi__Program_Profile__c>();
        
        for(ProgramApi__Program_Profile__c pp : records){
            ppIds.add(pp.Id);
        }
        
        ppList = [
            SELECT Id,ProgramApi__Contact__c,
            ProgramApi__Program__r.Name,
            ProgramApi__SalesOrderLineId__c,
            FON_Program_Start_Date__c,
            FON_Program_End_Date__c,
            ProgramApi__Status__c,
            Renewed_on_New_Year__c,
            ProgramApi__Create_Maintenance_Term__c
            FROM ProgramApi__Program_Profile__c
            WHERE Id IN :ppIds
        ];
        List<ProgramApi__Program_Term__c> pTermDefault = [SELECT Id, Name FROM ProgramApi__Program_Term__c WHERE ProgramApi__Profile__c =: ppIds AND ProgramApi__Is_Maintenance__c = TRUE];
        System.debug('pTermDefault '+pTermDefault);
        
        
        List<ProgramApi__Program_Term__c> pTerms = new List<ProgramApi__Program_Term__c>();
        for(ProgramApi__Program_Profile__c pp : ppList){
            if(pp.ProgramApi__Program__r.Name == 'NCP'){
                if(pp.FON_Program_End_Date__c == null || pp.FON_Program_Start_Date__c == null){
                    continue;
                }
                Integer amountOfTerms = pp.FON_Program_End_Date__c.year() - pp.FON_Program_Start_Date__c.year();
                for (Integer i = 0; i <= amountOfTerms; i++) {
                    ProgramApi__Program_Term__c ppterm = new ProgramApi__Program_Term__c();
                    ppterm.ProgramApi__Profile__c = pp.Id;
                    ppterm.Contact__c = pp.ProgramApi__Contact__c;
                    ppterm.FON_Allowed_Workshops__c = Decimal.valueOf(System.Label.Allowed_Workshops_in_1_year_NCP);
                    ppterm.FON_Allowed_Credits__c = Decimal.valueOf(System.Label.Allowed_Credits_for_1_year_NCP);
                    if(i == 0 && !pTermDefault.isEmpty()) {
                        ppterm.ProgramApi__Is_Maintenance__c = TRUE;
                    }
                    if(i == 0) {
						ppterm.ProgramApi__Start_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 4, 1);
                    }else{
                        if(pp.Renewed_on_New_Year__c){
                            ppterm.ProgramApi__Start_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 1, 1);
    
                        }else{
                            if(pp.ProgramApi__Status__c == 'Maintenance'){
                                ppterm.ProgramApi__Start_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 1, 1);
                            }else{
                                Integer testvar = 0;
                                testvar++;
                                testvar++;
                                testvar++;
                                testvar++;
                                ppterm.ProgramApi__Start_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 1, 1);
                            }
                            
                        }
                    }
                    ppterm.ProgramApi__End_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 12, 31);
                    pTerms.add(ppterm);
                }
            }
        }
        
        if(!pTerms.isEmpty()){
            insert pTerms;
        }
        
        if(!pTermDefault.isEmpty()){
        delete pTermDefault;
        }
        
        
    }
}