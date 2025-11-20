@isTest(SeeAllData=False)
public class MembershipTriggerHelperTest {
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
        
        OrderApi__Subscription_Plan__c plan = new OrderApi__Subscription_Plan__c();
        insert plan;
        
        OrderApi__Subscription__c memb = new OrderApi__Subscription__c();
        memb.OrderApi__Subscription_Plan__c = plan.Id;
        insert memb;
        
        OrderApi__Renewal__c term = new OrderApi__Renewal__c();
        term.OrderApi__Is_Active__c = true;
        term.OrderApi__Subscription__c = memb.Id;
        term.OrderApi__Subscription_Plan__c = plan.Id;
        insert term;
        
    }
    @isTest static void testInsertTerm(){
        List<Account> accs = [SELECT Id FROM Account];
        List<Contact> conts = [SELECT Id FROM Contact];
        List<OrderApi__Renewal__c> terms = [SELECT Id, OrderApi__Is_Active__c FROM OrderApi__Renewal__c];
        List<OrderApi__Subscription__c> memb = [SELECT Id, OrderApi__Paid_Through_Date__c FROM OrderApi__Subscription__c];
        List<OrderApi__Subscription_Plan__c> plan = [SELECT Id FROM OrderApi__Subscription_Plan__c];
        
        system.assertEquals(1, terms.size());
        system.assertEquals(1, memb.size());
        system.assertEquals(1, plan.size());
        system.assertEquals(true, terms[0].OrderApi__Is_Active__c);
        system.assertEquals(null, memb[0].OrderApi__Paid_Through_Date__c);
        
        OrderApi__Renewal__c term = new OrderApi__Renewal__c();
        term.OrderApi__Is_Active__c = true;
        term.OrderApi__Subscription__c = memb[0].Id;
        term.OrderApi__Subscription_Plan__c = plan[0].Id;
        insert term;
        
        List<OrderApi__Renewal__c> termsAfterIns = [SELECT Id, OrderApi__Is_Active__c FROM OrderApi__Renewal__c ORDER BY CreatedDate DESC];
        List<OrderApi__Subscription__c> membAfterIns = [SELECT Id, OrderApi__Paid_Through_Date__c FROM OrderApi__Subscription__c];
        system.assertEquals(true, termsAfterIns[0].OrderApi__Is_Active__c);
        system.assertEquals(false, termsAfterIns[1].OrderApi__Is_Active__c);
        system.assertEquals(system.today(), membAfterIns[0].OrderApi__Paid_Through_Date__c);
    }
    
    @isTest static void testGenericUpdate(){
        List<OrderApi__Subscription__c> subs = [SELECT Id FROM OrderApi__Subscription__c];
                       
        update subs;
    }
    
    @isTest static void testGenericDelete(){
        List<OrderApi__Subscription__c> subs = [SELECT Id FROM OrderApi__Subscription__c];
                   
        delete subs;
        undelete subs;
    }
    
}