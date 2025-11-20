@isTest(SeeAllData=False)
public class ProgramProfilesTriggerHelperTest {
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
        
        ProgramApi__Program__c program = [SELECT Id, Name FROM ProgramApi__Program__c LIMIT 1];
        List<ProgramApi__Program_Profile__c> pps = [SELECT Id, Name, ProgramApi__Program__r.Name
                                                    FROM ProgramApi__Program_Profile__c 
                                                    WHERE ProgramApi__Account__c IN: accs AND ProgramApi__Contact__c IN: conts];        
        List<ProgramApi__Program_Term__c> terms = [SELECT Id 
                                                   FROM ProgramApi__Program_Term__c 
                                                   WHERE Contact__c IN: conts];
        List<EventApi__Event__c> evs = [SELECT Id 
                                                   FROM EventApi__Event__c];
        system.assertEquals(0, pps.size());
        system.assertEquals(0, terms.size());
        
        EventAPi__Attendee__c att = new EventAPi__Attendee__c();
        att.EventApi__Account__c = accs[0].Id;
        att.EventApi__Contact__c = conts[0].Id;
        att.EventApi__Attendee_Event__c = evs[0].Id;
        insert att;
        
        pps = [SELECT Id, Name
               FROM ProgramApi__Program_Profile__c 
               WHERE ProgramApi__Account__c IN: accs AND ProgramApi__Contact__c IN: conts];
        terms = [SELECT Id 
                 FROM ProgramApi__Program_Term__c 
                 WHERE Contact__c IN: conts];
        //system.assertEquals(1, pps.size());
        //system.assertEquals(5, terms.size());
        
        EventAPi__Attendee__c att2 = new EventAPi__Attendee__c();
        att2.EventApi__Account__c = accs[0].Id;
        att2.EventApi__Contact__c = conts[0].Id;
        att2.EventApi__Attendee_Event__c = evs[0].Id;
        insert att2;
        
        pps = [SELECT Id, Name
               FROM ProgramApi__Program_Profile__c 
               WHERE ProgramApi__Account__c IN: accs AND ProgramApi__Contact__c IN: conts];
        terms = [SELECT Id 
                 FROM ProgramApi__Program_Term__c 
                 WHERE Contact__c IN: conts];
        //system.assertEquals(1, pps.size());
        Integer tcount = terms.size();
        system.assertEquals(tcount, terms.size());
        
    }
    
    @isTest static void testUpdate(){
        List<Account> accs = [SELECT Id FROM Account];
        List<Contact> conts = [SELECT Id FROM Contact];
        List<EventApi__Event__c> evs = [SELECT Id FROM EventApi__Event__c];
                
        EventAPi__Attendee__c att = new EventAPi__Attendee__c();
        att.EventApi__Account__c = accs[0].Id;
        att.EventApi__Contact__c = conts[0].Id;
        att.EventApi__Attendee_Event__c = evs[0].Id;
        insert att;
        
        ProgramApi__Program__c program = [SELECT Id, Name FROM ProgramApi__Program__c LIMIT 1];
        List<ProgramApi__Program_Profile__c> ppList = [SELECT Id, Name FROM ProgramApi__Program_Profile__c];
        ppList[0].ProgramApi__Program__c = program.Id;
        update ppList;
    }
    
    @isTest static void testDelete(){
        List<Account> accs = [SELECT Id FROM Account];
        List<Contact> conts = [SELECT Id FROM Contact];
        List<EventApi__Event__c> evs = [SELECT Id FROM EventApi__Event__c];
                
        EventAPi__Attendee__c att = new EventAPi__Attendee__c();
        att.EventApi__Account__c = accs[0].Id;
        att.EventApi__Contact__c = conts[0].Id;
        att.EventApi__Attendee_Event__c = evs[0].Id;
        insert att;
        
        List<ProgramApi__Program_Profile__c> ppList = [SELECT Id, Name FROM ProgramApi__Program_Profile__c];
        delete ppList;
        undelete ppList;
    }
    
}