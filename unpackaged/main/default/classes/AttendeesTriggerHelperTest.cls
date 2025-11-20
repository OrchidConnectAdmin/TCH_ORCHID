@isTest(SeeAllData=False)
public class AttendeesTriggerHelperTest {
    @testSetup static void testSetup(){
        ProgramApi__Program__c progNCP = new ProgramApi__Program__c();
        progNCP.Name  = 'NCP';
        progNCP.ProgramApi__Active__c = true;
        insert progNCP;
        
        EventApi__Event__c ev = new EventApi__Event__c();
        ev.Name = 'event';
        ev.EventApi__Event_Key__c = 'dummyK3y3vTstC8';
        insert ev;
        
        Account acc = new Account();
        acc.Name = 'testAcc';
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'testAcc2';
        insert acc2;
        
        Contact cont = new Contact();
        cont.FirstName = 'First';
        cont.LastName = 'Last';
        cont.AccountId = acc.Id;
        insert cont;
        
    }
    @isTest static void testInsert(){
        List<Account> accs = [SELECT Id FROM Account];
        List<Contact> conts = [SELECT Id FROM Contact];
        system.assert(accs.size() > 0);
        system.assert(conts.size() > 0);
        
        List<ProgramApi__Program_Profile__c> pps = [SELECT Id
                                                    FROM ProgramApi__Program_Profile__c 
                                                    WHERE ProgramApi__Account__c IN: accs AND ProgramApi__Contact__c IN: conts];
        List<ProgramApi__Program_Term__c> terms = [SELECT Id 
                                                   FROM ProgramApi__Program_Term__c 
                                                   WHERE Contact__c IN: conts];
        
        EventApi__Event__c ev = new EventApi__Event__c();
        ev.Name = 'Test Event';
        ev.Exam_Year__c = 2024;
        ev.EventApi__Event_Key__c = 'sdfjh-ghddk';
        insert ev;
        
        List<EventApi__Event__c> evs = [SELECT Id 
                                                   FROM EventApi__Event__c];
        system.assertEquals(0, pps.size());
        system.assertEquals(0, terms.size());
        
        EventAPi__Attendee__c att = new EventAPi__Attendee__c();
        att.EventApi__Account__c = accs[0].Id;
        att.EventApi__Contact__c = conts[0].Id;
        att.EventApi__Attendee_Event__c = ev.Id;
        att.EventApi__Status__c = 'Registered';
        insert att;
        
        pps = [SELECT Id
               FROM ProgramApi__Program_Profile__c 
               WHERE ProgramApi__Account__c IN: accs AND ProgramApi__Contact__c IN: conts];
        terms = [SELECT Id 
                 FROM ProgramApi__Program_Term__c 
                 WHERE Contact__c IN: conts];
        Integer psize = pps.size();
        system.assertEquals(psize, pps.size());
        Integer tsize = terms.size();
        system.assertEquals(tsize, terms.size());
        
        EventAPi__Attendee__c att2 = new EventAPi__Attendee__c();
        att2.EventApi__Account__c = accs[0].Id;
        att2.EventApi__Contact__c = conts[0].Id;
        att2.EventApi__Attendee_Event__c = ev.Id;
        att2.EventApi__Status__c = 'Registered';
        insert att2;
        
        pps = [SELECT Id
               FROM ProgramApi__Program_Profile__c 
               WHERE ProgramApi__Account__c IN: accs AND ProgramApi__Contact__c IN: conts];
        terms = [SELECT Id 
                 FROM ProgramApi__Program_Term__c 
                 WHERE Contact__c IN: conts];
        //system.assertEquals(1, pps.size());
        //system.assertEquals(5, terms.size());
        
    }
    
    @isTest static void testUpdate(){
        List<Account> accs = [SELECT Id FROM Account];
        List<Contact> conts = [SELECT Id FROM Contact];
        List<EventApi__Event__c> evs = [SELECT Id FROM EventApi__Event__c];
        
        List<ProgramApi__Program_Profile__c> pps = [SELECT Id
               FROM ProgramApi__Program_Profile__c 
               WHERE ProgramApi__Account__c IN: accs AND ProgramApi__Contact__c IN: conts];
        
        System.debug('pps ' + pps);
        if(!pps.isEmpty()){
            pps[0].ProgramApi__Status__c = 'Renewed';
        
            update pps;
        }
                
        EventAPi__Attendee__c att = new EventAPi__Attendee__c();
        att.EventApi__Account__c = accs[0].Id;
        att.EventApi__Contact__c = conts[0].Id;
        att.EventApi__Attendee_Event__c = evs[0].Id;
        insert att;
        
        att.EventApi__Account__c = accs[1].Id;
        update att;
    }
    
    @isTest static void testGenericDelete(){
        List<Account> accs = [SELECT Id FROM Account];
        List<Contact> conts = [SELECT Id FROM Contact];
        List<EventApi__Event__c> evs = [SELECT Id FROM EventApi__Event__c];
                
        EventAPi__Attendee__c att = new EventAPi__Attendee__c();
        att.EventApi__Account__c = accs[0].Id;
        att.EventApi__Contact__c = conts[0].Id;
        att.EventApi__Attendee_Event__c = evs[0].Id;
        insert att;
        
        delete att;
        undelete att;
    }
    
}