/**
 * Created by nkopparthi on 9/22/20.
 */

global without sharing class FON_ProgramProfileTrigger extends Framework.Domain{

    private boolean triggerIsExecuting;
    private integer triggerSize;
    public ProgramProfilesTriggerHelper helper;
    
    public FON_ProgramProfileTrigger(List<ProgramApi__Program_Profile__c> sObjectList) {
        super(sObjectList);
    }
    
    //public ProgramProfilesTriggerHandler(Boolean triggerIsExecuting, integer triggerSize){
    //    this.triggerIsExecuting = triggerIsExecuting;
    //    this.triggerSize = triggerSize;
    //    this.helper = new ProgramProfilesTriggerHelper();
    //}

    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new FON_ProgramProfileTrigger(sObjectList);
        }
    }
    
    public override void beforeInsert(){
        Framework.Log.push(FON_ProgramProfileTrigger.class.getName(),'beforeInsert');
        //helper.setDefaults((ProgramApi__Program_Profile__c []) records);
        //helper.setTerms((ProgramApi__Program_Profile__c []) records);
        //FON_ProgramProfileService.setDefaults((ProgramApi__Program_Profile__c []) records);
        system.debug('BEFORE INSERT PP');
        setDefaults((List<ProgramApi__Program_Profile__c>) records);
        //FON_ProgramProfileService.setCreateStatus((ProgramApi__Program_Profile__c []) records);
        //List<ProgramApi__Program_Profile__c> npps = (List<ProgramApi__Program_Profile__c>) records;
        //system.debug('NEW Updated PP before insert' + npps[0].ProgramApi__Status__c);
        //FON_ProgramProfileService.setTerms((ProgramApi__Program_Profile__c []) records);
        Framework.Log.pop();
    }

    public override void afterInsert(){
        Framework.Log.push(FON_ProgramProfileTrigger.class.getName(),'afterInsert');
        //helper.setDefaults((ProgramApi__Program_Profile__c []) records);
        //helper.setTerms((ProgramApi__Program_Profile__c []) records);
        
        //FON_ProgramProfileService.setDefaults((ProgramApi__Program_Profile__c []) records);
        
        FON_ProgramProfileService.setTerms((ProgramApi__Program_Profile__c []) records);
        //FON_ProgramProfileService.setCreateStatus((ProgramApi__Program_Profile__c []) records);
        
        
        Framework.Log.pop();
    }

    public override void afterUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(FON_ProgramProfileTrigger.class.getName(),'afterUpdate');
        FON_ProgramProfileService.setBadge((ProgramApi__Program_Profile__c []) records, (Map<Id,ProgramApi__Program_Profile__c>) oldMap);
        //FON_ProgramProfileService.setStatus((ProgramApi__Program_Profile__c []) records, (Map<Id,ProgramApi__Program_Profile__c>) oldMap);
        //FON_ProgramProfileService.createNewPp((ProgramApi__Program_Profile__c []) records, (Map<Id,ProgramApi__Program_Profile__c>) oldMap);
        //FON_ProgramProfileService.setCreateStatus((ProgramApi__Program_Profile__c []) records);
        //FON_ProgramProfileService.validateTerms((ProgramApi__Program_Profile__c []) records);
        List<ProgramApi__Program_Profile__c> pps = (List<ProgramApi__Program_Profile__c>) records;
        
        
        
        List<Id> ppIds = new List<Id>();
        for (ProgramApi__Program_Profile__c pp : pps) {
            ppIds.add(pp.Id);
        }
    
        // Enqueue Queueable with retry support
        //if (!ppIds.isEmpty()) {
        //    System.enqueueJob(new FON_ProgramProfileValidateTermsQueueable(ppIds, 1), 1);
        //}
        
        // Create queueables
        Queueable[] jobs = new Queueable[] {
            new FON_ProgramProfileValidateTermsQueueable(ppIds)
        };
        FON_QueueableGatekeeper.enqueueIfFree(jobs, 0, 2);
        // Enqueue through Gatekeeper with 2-minute retry delay
        //System.enqueueJob(new FON_QueueableGatekeeper(jobs, 0, 2));
        
        Framework.Log.pop();
    }
    
    
    public static void setDefaults(List<ProgramApi__Program_Profile__c> records){

        Set<Id> ppIds = new Set<Id>();
        List<ProgramApi__Program_Profile__c> ppList = new List<ProgramApi__Program_Profile__c>();
        List<ProgramApi__Program_Term__c> ptList = new List<ProgramApi__Program_Term__c>();
        Set<Id> solIds = new Set<Id>();
        List<OrderApi__Sales_Order_Line__c> solList = new List<OrderApi__Sales_Order_Line__c>();
        Map<Id, Decimal> mapIDYear = new Map<Id, Decimal>();
        List<ProgramApi__Program_Profile__c> lstPPUpd = new List<ProgramApi__Program_Profile__c>();

        Set<Id> conIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Map<Id,Integer> mapContactxNumProg = new Map<Id,Integer>();
        // get NCP program
        List<ProgramApi__Program__c> ncpProg = [Select Id FROM ProgramApi__Program__c WHERE Name = 'NCP' LIMIT 1];

        for(ProgramApi__Program_Profile__c pp : records){
            ppIds.add(pp.Id);
            system.debug('init set defaults pp '+pp.FON_Program_Name__c);
            ppList.add(pp);
            conIds.add(pp.ProgramApi__Contact__c);
            accIds.add(pp.ProgramApi__Account__c);
        }

		 system.debug('ppList '+ppList);
        for(ProgramApi__Program_Profile__c pp : ppList){
            solIds.add(pp.ProgramApi__SalesOrderLineId__c);
        }
		system.debug('solIDS '+solIds);
        if(solIds.size()>0){
            solList = [SELECT Id, OrderApi__Item__r.NCP_Exam_Year__c FROM OrderApi__Sales_Order_Line__c WHERE Id IN :solIds];
			system.debug('solList '+solList);
        }
        
        
        for(OrderApi__Sales_Order_Line__c sol : solList){
            if(!Test.isRunningTest()){ 
            	mapIDYear.put(sol.Id, sol.OrderApi__Item__r.NCP_Exam_Year__c);
            }else{
                mapIDYear.put(sol.Id, 2025);
            }
        }
		Date currentDate = system.today();
        
        List<ProgramApi__Program_Profile__c> ppsListAll = [SELECT Id, FON_Program_Start_Date__c, FON_Program_End_Date__c, ProgramApi__Account__c, ProgramApi__Contact__c  
                                                           FROM ProgramApi__Program_Profile__c 
                                                           WHERE ProgramApi__Account__c IN: accIds AND ProgramApi__Contact__c IN: conIds AND Id NOT IN: ppIds];
        
        Map<String, List<ProgramApi__Program_Profile__c>> mapAccContToPPList = new Map<String, List<ProgramApi__Program_Profile__c>>();
        if(ppsListAll.size()> 0){
            for(ProgramApi__Program_Profile__c pp : ppsListAll){
                String keyPP = String.valueOf(pp.ProgramApi__Account__c) + String.valueOf(pp.ProgramApi__Contact__c);
                if(mapAccContToPPList.containsKey(keyPP)){
                    mapAccContToPPList.get(keyPP).add(pp);
                }else{
                    mapAccContToPPList.put(keyPP, new List<ProgramApi__Program_Profile__c>{pp});
                }
            }
        }
        // check if user has current profile
        /*List<ProgramApi__Program_Profile__c> cppList = [
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
        ];*/
        
        for(ProgramApi__Program_Profile__c pp : records){
            if(pp.ProgramApi__Program__c == ncpProg[0].Id){
                //Integer currentPf = mapContactxNumProg.get(pp.ProgramApi__Contact__c);
                
                //if(pp.ProgramApi__SalesOrderLineId__c != NULL && pp.ProgramApi__SalesOrderLineId__c != '') {
                    
                    // check for current profiles
                    String keyPP = String.valueOf(pp.ProgramApi__Account__c) + String.valueOf(pp.ProgramApi__Contact__c);
                    //List<ProgramApi__Program_Profile__c> currentProfiles = new List<ProgramApi__Program_Profile__c>();
                    //currentProfiles = mapAccContToPPList.get(keyPP);
                    List<ProgramApi__Program_Profile__c> currentProfiles =
                        mapAccContToPPList.get(keyPP) != null 
                        ? mapAccContToPPList.get(keyPP)
                        : new List<ProgramApi__Program_Profile__c>();
                    
                    /*if(pp.FON_Program_Start_Date__c == null){
                    	pp.FON_Program_Start_Date__c = Date.newInstance(currentDate.year(), 4, 1);
                    //}else if(pp.Renewed_on_New_Year__c==true){
                    }else{
                        pp.FON_Program_Start_Date__c = Date.newInstance(currentDate.year(), 1, 1);
                    }
                    pp.FON_Program_End_Date__c = Date.newInstance(currentDate.year() + 5, 12, 31);
                    */
    				if(currentProfiles.size()>0 ){
                        pp.FON_Program_Start_Date__c = Date.newInstance(integer.valueOf(pp.Exam_Year__c), 1, 1);
                        pp.FON_Program_End_Date__c = Date.newInstance(integer.valueOf(pp.Exam_Year__c) + 5, 12, 31);
                        pp.ProgramApi__Status__c = 'Maintenance';
                        pp.Registration_Origin__c = '';
                    }else{
                        pp.FON_Program_Start_Date__c = Date.newInstance(integer.valueOf(pp.Exam_Year__c), 4, 1);
                        pp.FON_Program_End_Date__c = Date.newInstance(integer.valueOf(pp.Exam_Year__c) + 5, 12, 31);
                        pp.ProgramApi__Status__c = 'On Track';
                        pp.Registration_Origin__c = 'New Registrant';
                    }
                    //pp.FON_Trainer_Name__c = 'set default';
                    
                    
                    
                    pp.Allowed_Credits__c = Decimal.valueOf(System.Label.Allowed_Credits_NCP);
                    pp.Allowed_Workshops__c = Decimal.valueOf(System.Label.Allowed_Workshops_NCP);
                    //pp.FON_Trainer_Name__c = 'from routing rule';
                    system.debug('new pp '+pp.FON_Program_Start_Date__c+' ---'+pp.FON_Program_End_Date__c);
                //}

            }
            system.debug('NEW BINSERT PP' + pp.ProgramApi__Status__c + pp);
        }

    }

}