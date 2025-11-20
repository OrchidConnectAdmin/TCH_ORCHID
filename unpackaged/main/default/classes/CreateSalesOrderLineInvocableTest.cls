/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest 
public class CreateSalesOrderLineInvocableTest {

    private static User CreateTestCommunityUser(Id contactId) 
    {
        Profile targetProfile = [SELECT Id FROM Profile WHERE Name = 'Fonteva Customer Community Login User' LIMIT 1];
        User newUser = new User(
            FirstName = 'Test',
            LastName = 'Community User',
            Alias = 'cstuser',
            Email = 'createsponsortestuser@fonteva.com',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = targetProfile.Id,
            UserName = 'createsponsortestuser@fonteva.com',
            ContactId = contactId,
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8'
        );
        return newUser;
    }

    @TestSetup static void setup()
    {
        Account testSponsorAccount = new Account(name = 'Test Sponsoring Account');
        insert testSponsorAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Tester', Email = 'createsponsertest@fontevatest.com');
        insert testContact;

        Account testSponsoredAccount = new Account(Name = 'Test Sponsored Account', OrderApi__Primary_Contact__c = testContact.Id);
        insert testSponsoredAccount;

        testContact.AccountId = testSponsoredAccount.Id;
        update testContact;

        User testCommunityUser = [SELECT Id, ContactId, UserName FROM User WHERE ContactId != null LIMIT 1];

        Account test = [SELECT Id, OrderApi__Primary_Contact__c, OrderApi__Primary_Contact__r.FirstName, OrderApi__Primary_Contact__r.Email 
                        FROM Account 
                        WHERE Id=:testSponsoredAccount.Id 
                        LIMIT 1];

        OrderApi__Item_Class__c newItemClass = new OrderApi__Item_Class__c(Name = 'Test Item Class', 
                                                                            OrderApi__Is_Subscription__c = true, 
                                                                            OrderApi__Is_Active__c = true);
        insert newItemClass;

        OrderApi__Item__c newItem = new OrderApi__Item__c(Name = 'Test Item', 
                                                        OrderApi__Is_Subscription__c = true,
                                                        OrderApi__Item_Class__c = newItemClass.Id);
        insert newItem;

        OrderApi__Sales_Order__c testSalesOrder = new OrderApi__Sales_Order__c();
        insert testSalesOrder;

        OrderApi__Subscription_Plan__c testSubscriptionPlan = new OrderApi__Subscription_Plan__c();
        insert testSubscriptionPlan;

        System.runAs(CreateTestCommunityUser(testContact.Id))
        {
            Sponsoring_Relationships__c sponsorRelationship = new Sponsoring_Relationships__c(
                Sponsoring_Organization__c = testSponsoredAccount.Id,
                Sponsored_Organization__c = testSponsorAccount.Id,
                Primary_Contact_Lookup__c = testContact.Id,
                Date_Accepted_by_ECCHO__c = Date.today().addDays(-90)
            );
            insert sponsorRelationship;
        }
    }
    
    @isTest static void CreateSalesOrderLineInvocableTest_HappyPath() 
    {
        Sponsoring_Relationships__c sponsoringRelationship = [SELECT Id FROM Sponsoring_Relationships__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        OrderApi__Item__c testItem = [SELECT Id FROM OrderApi__Item__c LIMIT 1];
        OrderApi__Sales_Order__c testSO = [SELECT Id FROM OrderApi__Sales_Order__c LIMIT 1];
        OrderApi__Subscription_Plan__c testSubPlan = [SELECT Id FROM OrderApi__Subscription_Plan__c LIMIT 1];
        

        List<CreateSalesOrderLineInvocable.methodVars> argumentList = new List<CreateSalesOrderLineInvocable.methodVars>();
        CreateSalesOrderLineInvocable.methodVars arguments = new CreateSalesOrderLineInvocable.methodVars();

        arguments.quarter = '1QFull'; // options - 1Q, 2Q, 3Q, 4Q, 1QFull
        arguments.item = (String) testItem.Id;
        arguments.so = (String) testSO.Id;
        arguments.plan = (String) testSubPlan.Id;
        arguments.acc = (String) testAccount.Id;
        arguments.contact = (String) testContact.Id;
        arguments.rel = (String) sponsoringRelationship.Id;
        arguments.sups = new List<String>();
        arguments.timing = 'Annual';
        arguments.is_prorate = 'true';   // Test using an IsBlank = true value as well
        arguments.prev_sol =  '';    // Not needed unless quarter != '1QFull' OrderApi__Sales_Order_Line__c.Id
        arguments.year = '23';
        arguments.eDate = '';
        arguments.subQuarter = '2Q';

        argumentList.add(arguments);

        System.debug(arguments.rel);

        List<String> testSOLine = CreateSalesOrderLineInvocable.fetchSalesOrderLine(argumentList);
        System.assert(testSOLine != null);
    }

    @isTest static void CreateSalesOrderLineInvocableTest_isProrate() 
    {
        Test.startTest();
        Sponsoring_Relationships__c sponsoringRelationship = [SELECT Id FROM Sponsoring_Relationships__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        OrderApi__Item__c testItem = [SELECT Id FROM OrderApi__Item__c LIMIT 1];
        OrderApi__Sales_Order__c testSO = [SELECT Id FROM OrderApi__Sales_Order__c LIMIT 1];
        OrderApi__Subscription_Plan__c testSubPlan = [SELECT Id FROM OrderApi__Subscription_Plan__c LIMIT 1];
        Test.stopTest();

        List<CreateSalesOrderLineInvocable.methodVars> argumentList = new List<CreateSalesOrderLineInvocable.methodVars>();
        CreateSalesOrderLineInvocable.methodVars arguments = new CreateSalesOrderLineInvocable.methodVars();

        arguments.quarter = '1QFull'; // options - 1Q, 2Q, 3Q, 4Q, 1QFull
        arguments.item = (String) testItem.Id;
        arguments.so = (String) testSO.Id;
        arguments.plan = (String) testSubPlan.Id;
        arguments.acc = (String) testAccount.Id;
        arguments.contact = (String) testContact.Id;
        arguments.rel = (String) sponsoringRelationship.Id;
        arguments.sups = new List<String>();
        arguments.timing = 'Annual';
        arguments.is_prorate = ''; 
        arguments.prev_sol =  ''; 
        arguments.year = '23';
        arguments.eDate = '';
        arguments.subQuarter = '2Q';

        argumentList.add(arguments);

        System.debug(arguments.rel);

        List<String> testSOLine = CreateSalesOrderLineInvocable.fetchSalesOrderLine(argumentList);
        System.assert(testSOLine != null);
    }

    @isTest static void CreateSalesOrderLineInvocableTest_fixedDues() 
    {
        Test.startTest();
        Sponsoring_Relationships__c sponsoringRelationship = [SELECT Id FROM Sponsoring_Relationships__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        OrderApi__Item__c testItem = [SELECT Id FROM OrderApi__Item__c LIMIT 1];
        OrderApi__Sales_Order__c testSO = [SELECT Id FROM OrderApi__Sales_Order__c LIMIT 1];
        OrderApi__Subscription_Plan__c testSubPlan = [SELECT Id FROM OrderApi__Subscription_Plan__c LIMIT 1];
        Test.stopTest();

        List<CreateSalesOrderLineInvocable.methodVars> argumentList = new List<CreateSalesOrderLineInvocable.methodVars>();
        CreateSalesOrderLineInvocable.methodVars arguments = new CreateSalesOrderLineInvocable.methodVars();

        arguments.quarter = '1QFull'; // options - 1Q, 2Q, 3Q, 4Q, 1QFull
        arguments.item = (String) testItem.Id;
        arguments.so = (String) testSO.Id;
        arguments.plan = (String) testSubPlan.Id;
        arguments.acc = (String) testAccount.Id;
        arguments.contact = (String) testContact.Id;
        arguments.rel = (String) sponsoringRelationship.Id;
        arguments.sups = new List<String>();
        arguments.timing = 'Annual';
        arguments.is_prorate = '';   
        arguments.prev_sol =  '';    
        arguments.year = '23';
        arguments.eDate = '';
        arguments.subQuarter = '2Q';
        arguments.fixedDues = 0.05;

        argumentList.add(arguments);

        List<String> testSOLine = CreateSalesOrderLineInvocable.fetchSalesOrderLine(argumentList);
        System.assert(testSOLine != null);
    }
}