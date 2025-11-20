/**
 * Created by nkopparthi on 9/22/20.
 */

public without sharing class FON_ProgramProfileService {
    public FON_ProgramProfileService() {
        System.debug('Inside FON_ProgramProfileService Constructor');
    }
/*
    public static void setDefaults(List<ProgramApi__Program_Profile__c> records){

        Set<Id> ppIds = new Set<Id>();
        List<ProgramApi__Program_Profile__c> ppList = new List<ProgramApi__Program_Profile__c>();
        List<ProgramApi__Program_Term__c> ptList = new List<ProgramApi__Program_Term__c>();
        Set<Id> solIds = new Set<Id>();
        List<OrderApi__Sales_Order_Line__c> solList = new List<OrderApi__Sales_Order_Line__c>();
        Map<Id, Decimal> mapIDYear = new Map<Id, Decimal>();
        List<ProgramApi__Program_Profile__c> lstPPUpd = new List<ProgramApi__Program_Profile__c>();

        Set<Id> conIds = new Set<Id>();
        Map<Id,Integer> mapContactxNumProg = new Map<Id,Integer>();
        // get NCP program
        List<ProgramApi__Program__c> ncpProg = [Select Id FROM ProgramApi__Program__c WHERE Name = 'NCP' LIMIT 1];

        for(ProgramApi__Program_Profile__c pp : records){
            ppIds.add(pp.Id);
            system.debug('init set defaults pp '+pp.FON_Program_Name__c);
            ppList.add(pp);
            conIds.add(pp.ProgramApi__Contact__c);
        }

		 system.debug('ppList '+ppList);
        for(ProgramApi__Program_Profile__c pp : ppList){
            solIds.add(pp.ProgramApi__SalesOrderLineId__c);
        }
system.debug('solIDS '+solIds);
        solList = [SELECT Id, OrderApi__Item__r.NCP_Exam_Year__c FROM OrderApi__Sales_Order_Line__c WHERE Id IN :solIds];
		system.debug('solList '+solList);
        
        for(OrderApi__Sales_Order_Line__c sol : solList){
            if(!Test.isRunningTest()){ 
            	mapIDYear.put(sol.Id, sol.OrderApi__Item__r.NCP_Exam_Year__c);
            }else{
                mapIDYear.put(sol.Id, 2023);
            }
        }

        for(ProgramApi__Program_Profile__c pp : records){
            if(pp.ProgramApi__Program__c == ncpProg[0].Id){
                Integer currentPf = mapContactxNumProg.get(pp.ProgramApi__Contact__c);
                
                if(pp.ProgramApi__SalesOrderLineId__c != NULL && pp.ProgramApi__SalesOrderLineId__c != '') {
                    pp.FON_Program_Start_Date__c = Date.newInstance(Integer.valueOf(mapIDYear.get(pp.ProgramApi__SalesOrderLineId__c)), 4, 1);
                    pp.FON_Program_End_Date__c = Date.newInstance(Integer.valueOf(mapIDYear.get(pp.ProgramApi__SalesOrderLineId__c)) + 5, 12, 31);
                    pp.ProgramApi__Status__c = 'On Track';
                    pp.Allowed_Credits__c = Decimal.valueOf(System.Label.Allowed_Credits_NCP);
                    pp.Allowed_Workshops__c = Decimal.valueOf(System.Label.Allowed_Workshops_NCP);
                    system.debug('new pp '+pp.FON_Program_Start_Date__c+' ---'+pp.FON_Program_End_Date__c);
                }
                //lstPPUpd.add(pp);
            }
        }

    }
*/
/*
    public static void setTerms(List<ProgramApi__Program_Profile__c> records){
        Date currentDate = system.today();
        system.debug('SET TERMS------------ ');
        Set<Id> ppIds = new Set<Id>();
        List<ProgramApi__Program_Profile__c> ppList = new List<ProgramApi__Program_Profile__c>();
        
        for(ProgramApi__Program_Profile__c pp : records){
            ppIds.add(pp.Id);
        }
        system.debug('ppids '+ppIds);
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
        system.debug('ppList '+ppList);
        List<ProgramApi__Program_Term__c> pTermDefault = [SELECT Id, Name FROM ProgramApi__Program_Term__c WHERE ProgramApi__Profile__c =: ppIds AND ProgramApi__Is_Maintenance__c = TRUE];
        System.debug('pTermDefault '+pTermDefault);
        
        String awf = System.Label.Allowed_Workshops_NCP;
        Integer allowedWorkshopsFirst = Integer.valueOf(awf);
        String aw = System.Label.Allowed_Workshops_in_1_year_NCP;
        Integer allowedWorkshops = Integer.valueOf(aw);
        
        String acf = System.Label.Allowed_Credits_NCP;
        Integer allowedCreditsFirst = Integer.valueOf(acf);
        String ac = System.Label.Allowed_Credits_for_1_year_NCP;
        Integer allowedCredits = Integer.valueOf(ac);      
        
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
                    if(i == 0 && !pTermDefault.isEmpty()) {
                        ppterm.ProgramApi__Is_Maintenance__c = TRUE;
                    }
                    if(i == 0 ) {
                        ppterm.FON_Allowed_Workshops__c = allowedWorkshopsFirst;
                    	ppterm.FON_Allowed_Credits__c = allowedCreditsFirst;
                        if(pp.Renewed_on_New_Year__c == true || ppterm.ProgramApi__Is_Maintenance__c == TRUE){
							ppterm.ProgramApi__Start_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 1, 1);
                        }else{
                            ppterm.ProgramApi__Start_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 4, 1);
                        }
                    }else{
                        ppterm.FON_Allowed_Credits__c = allowedCredits;
                        ppterm.FON_Allowed_Workshops__c = allowedWorkshops;
                        if(pp.Renewed_on_New_Year__c){
                            ppterm.ProgramApi__Start_Date__c = Date.newInstance(pp.FON_Program_Start_Date__c.year() + i, 1, 1);
    
                        }else{
                            if(ppterm.ProgramApi__Is_Maintenance__c = TRUE){
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
        system.debug('insert pterms '+pTerms);
        if(!pTerms.isEmpty()){
            insert pTerms;
        }
        
        if(!pTermDefault.isEmpty()){
        //delete pTermDefault;
        }

    }
*/
    public static void setBadge(List<ProgramApi__Program_Profile__c> records, Map<Id,ProgramApi__Program_Profile__c> oldRecords){

        Id bdgType = [SELECT Id FROM OrderApi__Badge_Type__c WHERE Name = 'NCP Maintenance Badge' LIMIT 1].Id;
        List<OrderApi__Badge__c> lstInsBadges = new List<OrderApi__Badge__c>();
        Set<Id> existingConIds = new Set<Id>();
        List<OrderApi__Badge__c> bdgLst = new List<OrderApi__Badge__c>();
        List<Contact> lstConUpd = new List<Contact>();

        bdgLst = [SELECT Id, OrderApi__Contact__c FROM OrderApi__Badge__c WHERE OrderApi__Badge_Type__c = :bdgType AND OrderApi__Is_Active__c = TRUE];

        for(OrderApi__Badge__c bdg : bdgLst){
            existingConIds.add(bdg.OrderApi__Contact__c);
        }

        for(ProgramApi__Program_Profile__c pp : records){
            if(pp.FON_Exam_Results__c == 'Pass' && pp.FON_Exam_Results__c != oldRecords.get(pp.Id).FON_Exam_Results__c){
                if(!existingConIds.contains(pp.ProgramApi__Contact__c)) {
                    OrderApi__Badge__c bdg = new OrderApi__Badge__c();
                    bdg.OrderApi__Contact__c = pp.ProgramApi__Contact__c;
                    bdg.OrderApi__Badge_Type__c = bdgType;
                    bdg.OrderApi__Awarded_Date__c = system.today();
                    bdg.OrderApi__Is_Active__c = TRUE;
                    lstInsBadges.add(bdg);
                }

                Contact con = new Contact(Id = pp.ProgramApi__Contact__c);
                con.FON_Exam_Results__c = 'Pass';
                lstConUpd.add(con);

            } else if(pp.FON_Exam_Results__c == 'Fail' && pp.FON_Exam_Results__c != oldRecords.get(pp.Id).FON_Exam_Results__c){

                Contact con = new Contact(Id = pp.ProgramApi__Contact__c);
                con.FON_Exam_Results__c = 'Fail';
                lstConUpd.add(con);

            }
        }

        if(!lstInsBadges.isEmpty()){
            insert lstInsBadges;
        }

        if(!lstConUpd.isEmpty()){
            update lstConUpd;
        }
    }
    /*
    public static void setCreateStatus(List<ProgramApi__Program_Profile__c> records){
		Set<Id> ppIDs = new Set<Id>();
        //for(ProgramApi__Program_Profile__c pp : records){
        //    ppIDs.add(pp.Id);
        //}
        for(ProgramApi__Program_Profile__c pp : records){
            if(pp.Registration_Origin__c == 'New Registrant'){
                ppIDs.add(pp.Id);      
            }

        }
        setStatusQueue queueableJob = new setStatusQueue(ppIDs, 'On Track');
        ID jobID = System.enqueueJob(queueableJob);

    }
	*/
    /*
    public static void setStatus(List<ProgramApi__Program_Profile__c> records, Map<Id,ProgramApi__Program_Profile__c> oldRecords){

        List<ProgramApi__Program_Profile__c> ppUpdLst = new List<ProgramApi__Program_Profile__c>();

        for(ProgramApi__Program_Profile__c pp : records){

            if(pp.ProgramApi__Status__c == oldRecords.get(pp.Id).ProgramApi__Status__c) {

                if(pp.Days_left_until_recertification__c != oldRecords.get(pp.Id).Days_left_until_recertification__c
                        || pp.FON_Total_Workshops__c != oldRecords.get(pp.Id).FON_Total_Workshops__c
                        || pp.FON_Total_Credits__c != oldRecords.get(pp.Id).FON_Total_Credits__c) {

                    if (pp.Days_left_until_recertification__c < 730 && (pp.FON_Total_Credits__c < 50 || pp.FON_Total_Workshops__c < 3)) {
                        //pp.ProgramApi__Status__c = 'Cautionary';
                        setPPStatus(pp.Id, 'Cautionary');
                    }

                    if(pp.Days_left_until_recertification__c == 365 && (pp.FON_Total_Credits__c <50 || pp.FON_Total_Workshops__c < 3)){
                        //pp.ProgramApi__Status__c = 'Pending Revocation';
                        setPPStatus(pp.Id, 'Pending Revocation');
                    }

                    if(pp.FON_Total_Workshops__c >= 3 && pp.FON_Total_Credits__c >= 50){
                        //pp.ProgramApi__Status__c = 'Completed';
                        setPPStatus(pp.Id, 'Completed');
                    }
                    if(pp.Registration_Origin__c == 'New Registrant'){
                        setPPStatus(pp.Id, 'On Track');      
                    }
                    ppUpdLst.add(pp);
                }
            }


        }

        if(!ppUpdLst.isEmpty()){
            //update ppUpdLst;
        }
    }

    public static void createNewPp(List<ProgramApi__Program_Profile__c> records, Map<Id,ProgramApi__Program_Profile__c> oldRecords){

        List<ProgramApi__Program_Profile__c> ppInsLst = new List<ProgramApi__Program_Profile__c>();
        List<Id> ppIds = new List<Id>();
        List<ProgramApi__Program_Profile__c> ppList = new List<ProgramApi__Program_Profile__c>();
        Map<Id, List<ProgramApi__Goals__c>> mapPPGoals = new Map<Id, List<ProgramApi__Goals__c>>();

        for(ProgramApi__Program_Profile__c pp : records){
            if(pp.ProgramApi__Status__c == 'On Track' && oldRecords.get(pp.Id).ProgramApi__Status__c == 'Exempt'){
                ppIds.add(pp.Id);
            }
        }

        Id programId = [
                SELECT
                        Id
                FROM ProgramApi__Program__c
                WHERE Name = 'NCP'
                LIMIT 1
        ].Id;

        ppList = [
                SELECT
                        Id,
                        ProgramApi__Contact__c,
                        ProgramApi__Contact__r.AccountId,
                        ProgramApi__Status__c,
                        FON_Program_Start_Date__c,
                        FON_Program_End_Date__c,
                        ProgramApi__Program__c,
                (SELECT
                        Id,
                        ProgramApi__Profile_Contact__c,
                        ProgramApi__Profile_Account__c,
                        ProgramApi__Requirement_Title__c,
                        ProgramApi__Status__c,
                        ProgramApi__Publish__c,
                        ProgramApi__Program_Profile__c,
                        ProgramApi__Requirement__c
                FROM ProgramApi__Goals__r
                )
                FROM ProgramApi__Program_Profile__c
                WHERE Id IN :ppIds
        ];
        for(ProgramApi__Program_Profile__c pp : ppList){
            List<ProgramApi__Goals__c> goals = new List<ProgramApi__Goals__c>();
            for(ProgramApi__Goals__c pg : pp.ProgramApi__Goals__r){
                goals.add(pg);
            }
            mapPPGoals.put(pp.Id, goals);
        }

        for(ProgramApi__Program_Profile__c pp : ppList){
            ProgramApi__Program_Profile__c newPP = new ProgramApi__Program_Profile__c();
            newPP.ProgramApi__Contact__c = pp.ProgramApi__Contact__c;
            newPP.ProgramApi__Account__c = pp.ProgramApi__Contact__r.AccountId;
            newPP.ProgramApi__Status__c = 'On Track';
            newPP.FON_Program_Start_Date__c = system.today();
            newPP.FON_Program_End_Date__c = Date.newInstance(system.today().year() + 5, 12, 31);
            newPP.ProgramApi__Program__c = programId;
            newPP.Old_Program_Profile__c = pp.Id;
            ppInsLst.add(newPP);

            //pp.ProgramApi__Status__c =
        }

        if(!ppInsLst.isEmpty()){
            insert ppInsLst;

            List<ProgramApi__Goals__c> goalsIns = new List<ProgramApi__Goals__c>();
            List<ProgramApi__Program_Term__c> termsIns = new List<ProgramApi__Program_Term__c>();
            for(ProgramApi__Program_Profile__c pp : ppInsLst){

                Map<Id, Id> mapPPTerm = new Map<Id, Id>();
                ProgramApi__Program_Term__c defTerm = new ProgramApi__Program_Term__c();
                defTerm.ProgramApi__Profile__c = pp.Id;
                defTerm.Contact__c = pp.ProgramApi__Contact__c;
                defTerm.ProgramApi__Start_Date__c = system.today();
                defTerm.ProgramApi__End_Date__c = Date.newInstance(system.today().year() + 1, 12, 31);
                defTerm.FON_Allowed_Credits__c = Decimal.valueOf(System.Label.Allowed_Credits_for_1_year_NCP);
                defTerm.FON_Allowed_Workshops__c = Decimal.valueOf(System.Label.Allowed_Workshops_in_1_year_NCP);
                defTerm.ProgramApi__Is_Maintenance__c = TRUE;
                defTerm.Is_Test_Data__c = TRUE;
                
                termsIns.add(defTerm);

                if(!termsIns.isEmpty()){
                    insert termsIns;

                    for(ProgramApi__Program_Term__c pt : termsIns){
                        mapPPTerm.put(pt.ProgramApi__Profile__c, pt.Id);
                    }

                }


                List<ProgramApi__Goals__c> newGoals = new List<ProgramApi__Goals__c>();
                newGoals = mapPPGoals.get(pp.Old_Program_Profile__c);
                for(ProgramApi__Goals__c goals : newGoals){
                    ProgramApi__Goals__c pg = goals.clone(false, false, false, false);
                    pg.ProgramApi__Program_Profile__c = pp.Id;
                    pg.ProgramApi__Term__c = mapPPTerm.get(pp.Id);
                    goalsIns.add(pg);
                }


            }

            if(!goalsIns.isEmpty()){
                insert goalsIns;
            }
        }
    }

    @future
    public static void setPPStatus(Id ppId, String status) {

        List<ProgramApi__Program_Profile__c> lstPProfiles = [SELECT id, ProgramApi__Status__c FROM ProgramApi__Program_Profile__c WHERE Id = :ppId ];

        for(ProgramApi__Program_Profile__c pp : lstPProfiles ) {
            pp.ProgramApi__Status__c = status;
        }
        update lstPProfiles;
    }
*/
/*
    public class setStatusQueue implements Queueable {

        private Set<Id> ppIds;
        private String status;

        public setStatusQueue(Set<Id> ppIds, String status) {
            this.ppIds = ppIds;
            this.status = status;
        }

        public void execute(QueueableContext context) {
            List<ProgramApi__Program_Profile__c> lstPProfiles = [SELECT id, ProgramApi__Status__c FROM ProgramApi__Program_Profile__c WHERE Id IN :ppIds ];
    
            for(ProgramApi__Program_Profile__c pp : lstPProfiles ) {
                pp.ProgramApi__Status__c = status;
            }
            update lstPProfiles;
        }
    }
*/
}