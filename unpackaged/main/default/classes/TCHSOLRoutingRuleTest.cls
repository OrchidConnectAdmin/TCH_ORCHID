@IsTest
global without sharing class TCHSOLRoutingRuleTest {
    
    @isTest static void test_FION_GenerateRenewalProformaBatch() {
        Account acc = new Account();
        acc.name = 'account test';
        insert acc;
        
        Contact ct = new Contact();
        ct.FirstName = 'contact';
        ct.LastName = 'test';
        ct.AccountId = acc.Id;
        insert ct;
        
        Sponsoring_Relationships__c sponsorRelationship = new Sponsoring_Relationships__c(
            Sponsoring_Organization__c = acc.Id,
            Sponsored_Organization__c = acc.Id,
            Primary_Contact_Lookup__c = ct.Id,
            Date_Accepted_by_ECCHO__c = Date.today()
        );
        insert sponsorRelationship;
        
        
        //Test.startTest();
        
        OrderApi__Sales_Order__c testSalesOrder = new OrderApi__Sales_Order__c();
        testSalesOrder.OrderApi__Contact__c = ct.Id;
        insert testSalesOrder;
        
        OrderApi__Sales_Order_Line__c testSalesOrderLine = new OrderApi__Sales_Order_Line__c();
        testSalesOrderLine.OrderApi__Contact__c = ct.Id;
        testSalesOrderLine.OrderApi__Account__c = ct.AccountId;
        testSalesOrderLine.Sponsoring_Relationship__c = sponsorRelationship.Id;
            testSalesOrderLine.OrderApi__Sales_Order__c = testSalesOrder.Id;
        testSalesOrderLine.OrderApi__Total__c = 1;
        testSalesOrderLine.OrderApi__Overall_Total__c = 0;
        testSalesOrderLine.OrderApi__Balance_Due__c = 0;
        insert testSalesOrderLine;
        
        
        //Test.stopTest();
    }
}