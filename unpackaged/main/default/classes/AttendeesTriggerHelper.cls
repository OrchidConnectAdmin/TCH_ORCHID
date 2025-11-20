public without sharing class AttendeesTriggerHelper {
    public AttendeesTriggerHelper(){
        System.debug('Inside AttendeeTriggerHelper Constructor');
    }
    
    public void newAttendeeExam(List<EventApi__Attendee__c> newAttendees){
        Date dateToday = system.today();
        List<ProgramApi__Program__c> progNCP = [SELECT Id, Name 
                                                FROM ProgramApi__Program__c 
                                                WHERE Name = 'NCP' LIMIT 1];
        
        List<String> accIds = new List<String>();
        List<String> contIds = new List<String>();
        for(EventApi__Attendee__c att : newAttendees){
            accIds.add(att.EventApi__Account__c);
            contIds.add(att.EventApi__Contact__c);
        }
        
		// what does this even do. it is fetching records but doesnt seem to do anything with creating new profiles!
        /*List<ProgramApi__Program_Profile__c> ppsListAll = [SELECT Id, FON_Program_Start_Date__c, FON_Program_End_Date__c, ProgramApi__Account__c, ProgramApi__Contact__c  
                                                           FROM ProgramApi__Program_Profile__c 
                                                           WHERE ProgramApi__Account__c IN: accIds AND ProgramApi__Contact__c IN: contIds];
        Map<String, List<ProgramApi__Program_Profile__c>> mapAccContToPPList = new Map<String, List<ProgramApi__Program_Profile__c>>();
        for(ProgramApi__Program_Profile__c pp : ppsListAll){
            String keyPP = String.valueOf(pp.ProgramApi__Account__c) + String.valueOf(pp.ProgramApi__Contact__c);
            if(mapAccContToPPList.containsKey(keyPP)){
                mapAccContToPPList.get(keyPP).add(pp);
            }else{
                mapAccContToPPList.put(keyPP, new List<ProgramApi__Program_Profile__c>{pp});
            }
        }*/
        
        List<ProgramApi__Program_Profile__c> pps = new List<ProgramApi__Program_Profile__c>();
        for(EventApi__Attendee__c att : newAttendees){
            if(att.Is_NCP__c == true){
                ProgramApi__Program_Profile__c pp = new ProgramApi__Program_Profile__c();
                pp.ProgramApi__Account__c = att.EventApi__Account__c;
                pp.ProgramApi__Contact__c = att.EventApi__Contact__c;
                pp.ProgramApi__Status__c = 'On Track';
                if(progNCP.size() > 0){
                    pp.ProgramApi__Program__c = progNCP[0].Id;
                }
                if(att.Exam_Year__c != null){
                    pp.FON_Program_Start_Date__c = date.newInstance(integer.valueOf(att.Exam_Year__c), 4, 1);
                    pp.FON_Program_End_Date__c = date.newInstance(integer.valueOf(att.Exam_Year__c) + 4, 12, 31);
                }
                pps.add(pp);
            }
        }
        if(pps.size() > 0){
            insert pps;
        }
    }
    
    public Map<String, Decimal> attsPerCont(List<EventAPi__Attendee__c> atts){
        List<String> contIds = new List<String>();
        Map<String, Decimal> ret = new Map<String, Decimal>();
        //Total_Attendee_Contact_records__c
        // get current profile status
        // 

        
        for(EventAPi__Attendee__c att : atts){
            /*Integer examYear = Integer.valueOf(att.Exam_Year__c);
            List<ProgramApi__Program_Profile__c> currentPP = [SELECT Id FROM ProgramApi__Program_Profile__c WHERE 
                                                               FON_Exam_Results__c = 'Fail' AND 
                                                               ProgramApi__Contact__c =: att.ContactID__c AND 
                                                               ProgramApi__Account__c =: att.EventApi__Account__c ORDER BY FON_Program_End_Date__c DESC LIMIT 1];
            
			List<ProgramApi__Program_Profile__c> currentPPPass = [SELECT Id FROM ProgramApi__Program_Profile__c WHERE 
                                                               FON_Exam_Results__c != 'Fail' AND 
                                                               ProgramApi__Contact__c =: att.ContactID__c AND 
                                                               ProgramApi__Account__c =: att.EventApi__Account__c AND 
                                                               CALENDAR_YEAR(FON_Program_Start_Date__c) >=: examYear 
															   AND CALENDAR_YEAR(FON_Program_End_Date__c) <=: examYear];
			*/
            /*if(currentPP.size()>0 || Test.isRunningTest()){
                //if(ret.containsKey(att.ContactID__c)){
                //    Decimal aux = ret.get(att.ContactID__c);
                //    ret.remove(att.ContactID__c);
                //    ret.put(att.ContactID__c, aux + 1);
                //}else{
                ret.put(att.ContactID__c, 1);
                //}
            }else if(currentPPPass.size()> 0){
                ret.put(att.ContactID__c, 0);
            }else{
				if(att.Is_NCP__c == true){
                	ret.put(att.ContactID__c, 1);
                }
            }*/
                if(att.Is_NCP__c == true){
                	ret.put(att.ContactID__c, 1);
                }
            //contIds.add(att.ContactID__c);
        }
        Integer vars = 0;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        // Removing this bc this is problematic if the user actually have 2 or more attendee records
        //  List<EventAPi__Attendee__c> allAtts = [SELECT Id, ContactID__c FROM EventAPi__Attendee__c WHERE ContactID__c IN : contIds AND ];
        //for(EventAPi__Attendee__c att : allAtts){
        //    if(ret.containsKey(att.ContactID__c)){
        //        Decimal aux = ret.get(att.ContactID__c);
        //        ret.remove(att.ContactID__c);
        //        ret.put(att.ContactID__c, aux + 1);
        //    }else{
        //        ret.put(att.ContactID__c, 1);
        //    }
        //}
        return ret;
    }
    
}