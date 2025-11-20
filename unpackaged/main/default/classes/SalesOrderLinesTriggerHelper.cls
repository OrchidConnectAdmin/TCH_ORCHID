public without sharing class SalesOrderLinesTriggerHelper {
    public SalesOrderLinesTriggerHelper() {
        System.debug('Inside SalesOrderLinesTriggerHelper Constructor');
    }
    
    public void updateAttendee(List<OrderApi__Sales_Order_Line__c> newSOLs) {
        List<String> eventList = new List<String>();
        List<String> contactList = new List<String>();
        
        for(OrderApi__Sales_Order_Line__c sls : newSOLs){
            eventList.add(sls.EventApi__Event__c);
            contactList.add(sls.OrderApi__Contact__c);
        }
        
        List<EventApi__Attendee__c> atts = [SELECT Id, Name, EventApi__Contact__c, EventApi__Attendee_Event__c 
                                            FROM EventApi__Attendee__c 
                                            WHERE EventApi__Contact__c IN: contactList AND EventApi__Attendee_Event__c IN: eventList 
                                            ORDER BY CreatedDate DESC];
        Map<String, EventApi__Attendee__c> uniqueAttendee = new Map<String, EventApi__Attendee__c>();
        for(EventApi__Attendee__c att : atts){
            if(!uniqueAttendee.containsKey(string.valueOf(att.EventApi__Contact__c) + string.valueOf(att.EventApi__Attendee_Event__c))){
                uniqueAttendee.put(string.valueOf(att.EventApi__Contact__c) + string.valueOf(att.EventApi__Attendee_Event__c), att);
            }
        }
        
        for(OrderApi__Sales_Order_Line__c sol : newSOLs){
            if(uniqueAttendee.containsKey(string.valueOf(sol.OrderApi__Contact__c) + string.valueOf(sol.EventApi__Event__c))){
                sol.EventApi__Attendee__c = uniqueAttendee.get(string.valueOf(sol.OrderApi__Contact__c) + string.valueOf(sol.EventApi__Event__c)).Id;
            }
        }
    }
}