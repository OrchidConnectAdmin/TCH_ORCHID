public without sharing class GetEventSessionsController {
    
    public detailsWrapper wrapObj {get;set;}
    public string attendeeId {get; set;}
    
    public GetEventSessionsController() {
        getdisplaydata();
    }
    
    public void getdisplaydata(){
        
        List<EventApi__Registration_Item__c> sess = [SELECT Id, EventApi__Schedule_Item__r.EventApi__Event__r.EventApi__Time_Zone__c,EventApi__Schedule_Item__r.Name,EventApi__Schedule_Item__r.EventApi__Session_Start_Time__c,EventApi__Schedule_Item__r.EventApi__Session_End_Time__c,EventApi__Date__c,EventApi__Start_Time__c,EventApi__End_Time__c 
                                                               FROM EventApi__Registration_Item__c
                                                               WHERE EventApi__Attendee__c=:attendeeId AND EventApi__Schedule_Item__C != NULL 
                                                     			ORDER BY EventApi__Schedule_Item__r.EventApi__Start_Date_Time__c
                                                    ];
        
        // set event timezone
        
        system.debug('ACCTS '+sess);
        wrapObj = new detailsWrapper();
        
        //if(sess.size()>0){
        //    wrapObj.sessions = sess;
        //}  
        if (sess.size() > 0) {
        	wrapObj.sessions = sess;
            
            /*Map<Id,Map<String,Object>> fsessions = new Map<Id,Map<String,Object>>();
            for (EventApi__Registration_Item__c item : sess) {
                // get timezone
                String tz = item.EventApi__Schedule_Item__r.EventApi__Event__r.EventApi__Time_Zone__c;
                String targetTimeZone = tz.substringAfter(') ').trim();
                
                Map<String,Object> sesh = new Map<String,Object>();
                sesh.put('Name',item.EventApi__Schedule_Item__r.Name);
                sesh.put('EventApi__Date__c', (Date) convertToLocalTime(Datetime.newInstance(item.EventApi__Date__c.year(), item.EventApi__Date__c.month(), item.EventApi__Date__c.day()), targetTimeZone).date());
            	sesh.put('EventApi__Start_Time__c', convertToLocalTime(Datetime.newInstance(item.EventApi__Date__c.year(), item.EventApi__Date__c.month(), item.EventApi__Date__c.day(), item.EventApi__Start_Time__c.hour(), item.EventApi__Start_Time__c.minute(), item.EventApi__Start_Time__c.second()), targetTimeZone).time());
            	sesh.put('EventApi__End_Time__c',convertToLocalTime(Datetime.newInstanceGmt(item.EventApi__End_Time__c.year(), item.EventApi__End_Time__c.month(), item.EventApi__End_Time__c.day(), item.EventApi__End_Time__c.hour(), item.EventApi__End_Time__c.minute(), item.EventApi__End_Time__c.second()), targetTimeZone).time());
        	}*/
    	}     
    }

    public class detailsWrapper{
        @auraEnabled
        public List<EventApi__Registration_Item__c> sessions{get;set;}
        //@auraEnabled
        //public Map<Id,Map<String,String>> sessionObjects{get;set;}

        public detailsWrapper(){
            sessions = new List<EventApi__Registration_Item__c>();
            //sessionObjects = new Map<Id,Map<String,String>>();
        }
        
    }
    
    /*public Datetime convertToLocalTime(Datetime inputDateTime, String targetTimeZone) {
        TimeZone tz = TimeZone.getTimeZone(targetTimeZone);
        Integer offset = tz.getOffset(inputDateTime.getTime()) / 1000;
        return inputDateTime.addSeconds(offset);
    }*/


}