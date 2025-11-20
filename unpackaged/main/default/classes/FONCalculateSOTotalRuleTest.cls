@isTest
public class FONCalculateSOTotalRuleTest {
    
    @TestSetup
    private static void install() {

        Framework.Installer.install();
        OrderApi.PackageScripts.install();
        Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
        Framework.RoutingRule accountJoinDateUpdate = new Framework.RoutingRule();
        accountJoinDateUpdate.apexClass = FONCalculateSOTotalRule.class.getName();
        accountJoinDateUpdate.namespace = '';
        accountJoinDateUpdate.isEnabled = true;
        accountJoinDateUpdate.sObjectName = 'OrderApi__Sales_Order_Line__c';
        accountJoinDateUpdate.executionOrder = 0;
        rules.add(accountJoinDateUpdate);
        Framework.Config.push(rules);
    }
    @isTest static void test_FION_GenerateRenewalProformaBatch() {
        Account acc = new Account();
        acc.name = 'account test';
        insert acc;
        
        Contact ct = new Contact();
        ct.FirstName = 'contact';
        ct.LastName = 'test';
        ct.AccountId = acc.Id;    
        insert ct;
        
        /*OrderApi__Badge_Type__c bgType = OrderApi__Badge_Type__c();
        bgType.Name = 'Sustaining Member';
        insert bgType;
        
        OrderApi__Badge__c badge = OrderApi__Badge__c();
        badge.OrderApi__Contact__c = ct.Id;
        badge.OrderApi__Badge_Type__c = bgType.Id;
        badge.OrderApi__Is_Active__c = true;
        insert badge;*/
       
        
        OrderApi__Item_Class__c itemClass = new OrderApi__Item_Class__c();
        itemClass.Name = 'item class test';
        insert itemClass;
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.Name = 'Business Group Test';
        insert bg;
        
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.Name = 'Attorney: 0-2 Years';
        item.OrderApi__Is_Active__c = true;
		item.OrderApi__Price__c = 150;
        item.OrderApi__Item_Class__c = itemClass.Id;
        insert item;


        
        Test.startTest();
        
      OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Contact__c = ct.Id;
        so.OrderApi__Account__c = acc.Id;
        so.OrderApi__Business_Group__c = bg.Id;
        so.OrderApi__Entity__c = 'Account';
        so.OrderApi__Status__c = 'Open';
        insert so;
        
        List<OrderApi__Sales_Order_Line__c> sols = new List<OrderApi__Sales_Order_Line__c>();
      
    OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c(); 
        sol.OrderApi__Account__c = acc.Id;
        sol.OrderApi__Contact__c = ct.Id;
        sol.OrderApi__Quantity__c = 1;
        sol.OrderApi__Sales_Order__c = so.Id;
        sol.OrderApi__Entity__c = 'Contact';
        sol.OrderApi__Item__c = item.Id;
        sol.OrderApi__Overall_Total__c = 100;
        insert sol;
        
        sol.OrderApi__Entity__c = 'Account';
        update sol;
        sols.add(sol);
        
        // FIRST BATCH
        /*List<String> fids = new List<String>();*/
        //FONCalculateSOTotalBatchable Batch1 = new FION_RenewalProformaBatchable1(null,null,null,null,null,null,fids,null,null);
        Id job1 = Database.executeBatch(new FONCalculateSOTotalBatchable(),5);

        
        Test.stopTest();
    }
}