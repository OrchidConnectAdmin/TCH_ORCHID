@isTest(SeeAllData=False)
public class SalesOrderLinesTriggerHelperTest {
    @isTest 
    public static void testUpdate() {
        Contact cont = new Contact();
        cont.LastName = 'Last Name';
        cont.FirstName = 'First Name';
        insert cont;
        
        EventApi__Event__c ev = new EventApi__Event__c();
        ev.EventApi__Event_Key__c = 'TestUn1qu3!Key';
        insert ev;
        
        EventApi__Attendee__c att = new EventApi__Attendee__c();
        att.EventApi__Attendee_Event__c = ev.Id;
        att.EventApi__Contact__c = cont.Id;
        insert att;
        
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Contact__c = cont.Id;
        insert so;
        
        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
        sol.OrderApi__Contact__c = cont.Id;
        sol.OrderApi__Sales_Order__c = so.Id;
        sol.EventApi__Event__c = ev.Id;
        insert sol;
        
        test.startTest();
        
        List<OrderApi__Sales_Order_Line__c> sols = [SELECT Id, EventApi__Attendee__c FROM OrderApi__Sales_Order_Line__c WHERE Id =: sol.Id];
        system.assert(sols.size() == 1);
        system.assertEquals(null, sols[0].EventApi__Attendee__c);
        update sol;
        List<OrderApi__Sales_Order_Line__c> solsUpdated = [SELECT Id, EventApi__Attendee__c FROM OrderApi__Sales_Order_Line__c WHERE Id =: sol.Id];
        system.assert(solsUpdated.size() == 1);
        
        test.stopTest();
    }
}