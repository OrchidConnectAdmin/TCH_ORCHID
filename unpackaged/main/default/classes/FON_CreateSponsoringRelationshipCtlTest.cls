@IsTest public class FON_CreateSponsoringRelationshipCtlTest 
{
    private static User CreateTestCommunityUser(Id sourceContactId, String lastName)
    {
        Profile targetProfile = [SELECT Id FROM Profile WHERE Name = 'Fonteva Customer Community Login User' LIMIT 1];
        return new User(
            FirstName='Test',
            LastName='Community User',
            Alias='cstuser',
            Email='createsponsortestuser@fonteva.com',
            LanguageLocaleKey='en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId=targetProfile.Id,
            UserName='test' + Date.today().day() + Date.today().month() + Date.today().year() + 'createsponsor' + lastName + '@fonteva.com',
            ContactId=sourceContactId,
            LocaleSidKey='en_US',
            EmailEncodingKey='UTF-8'
        );
    }

    private static Sponsoring_Relationships__c InsertNewSponsorRelationship(Account sponsoringAccount, 
                                                                            Account sponsoredAccount, 
                                                                            Contact primaryContact,
                                                                            Boolean insertRecord)
    {
        Sponsoring_Relationships__c sponsorRelationship;

        System.runAs(CreateTestCommunityUser(primaryContact.Id, primaryContact.LastName))
        {
            sponsorRelationship = new Sponsoring_Relationships__c(
                Sponsoring_Organization__c = sponsoringAccount.Id,
                Sponsored_Organization__c = sponsoredAccount.Id,
                Primary_Contact_Lookup__c = primaryContact.Id
            );
            
            if (insertRecord)
            {
                insert sponsorRelationship;
            }
        }

        return sponsorRelationship;
    }

    @TestSetup static void Setup()
    {
        Account testSponsorAccount = new Account(Name='Test Sponsoring Account');
        insert testSponsorAccount;

        Contact testContact = new Contact(
            FirstName = 'CreateSponsor', 
            LastName = 'TestContact', 
            Email = 'auefheiufssgrrhshttrhth@adaffgrryjyjyj.com');
        insert testContact;

        Account testSponsoredAccount = new Account(
            Name='Test Sponsored Account', 
            OrderApi__Primary_Contact__c=testContact.Id);
        insert testSponsoredAccount;

        testContact.AccountId = testSponsoredAccount.Id;
        update testContact;

        InsertNewSponsorRelationship(testSponsorAccount, testSponsoredAccount, testContact, true);
    }

    @IsTest static void TestGetSponsoringRelationship()
    {
        Sponsoring_Relationships__c sponsorRelationship = [SELECT Id FROM Sponsoring_Relationships__c LIMIT 1];

        Test.startTest();
        Sponsoring_Relationships__c foundSponsorRecord = FON_CreateSponsoringRelationshipCtl.getSponsoringRelationship(sponsorRelationship.Id);
        Test.stopTest();

        System.assert(foundSponsorRecord != null);
        System.assertEquals(sponsorRelationship.Id, foundSponsorRecord.Id, 'The Received Record Id doesn\'t match the expected Id');
    }

    @IsTest static void TestGetSponsoringOrganization()
    {
        Account targetAccount = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Account receivedAccount = FON_CreateSponsoringRelationshipCtl.getSponsoringOrganization(targetAccount.Id);
        Test.stopTest();

        System.assert(receivedAccount != null);
        System.assertEquals(targetAccount.Id, receivedAccount.Id, 'The Received Record Id doesn\'t match the expected Id');
    }

    @IsTest static void TestGetSponsoredOrganization()
    {
        Account targetAccount = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Account receivedAccount = FON_CreateSponsoringRelationshipCtl.getSponsoredOrganization(targetAccount.Id);
        Test.stopTest();

        System.assert(receivedAccount != null);
        System.assertEquals(targetAccount.Id, receivedAccount.Id, 'The Received Record Id doesn\'t match the expected Id');
    }

    @IsTest static void TestGetPrimaryContact()
    {
        Contact targetContact = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();
        Contact receivedContact = FON_CreateSponsoringRelationshipCtl.getPrimaryContact(targetContact.Id);
        Test.stopTest();

        System.assert(receivedContact != null);
        System.assertEquals(targetContact.Id, receivedContact.Id, 'The Received Record Id doesn\'t match the expected Id');
    }

    @IsTest static void TestCreateCommunityUser()
    {
        User systemAdminUser = [SELECT Id FROM User WHERE Profile.Name='System Administrator' AND IsActive = true AND UserRoleId != null LIMIT 1];
        Account targetAccount = [SELECT Id FROM Account LIMIT 1];

        Contact newContact = new Contact(FirstName='Unique', LastName='Community Contact', Email='testcommunity222@test.com', AccountId=targetAccount.Id);
        insert newContact;

        System.runAs(systemAdminUser)
        {
            Test.startTest();
            FON_CreateSponsoringRelationshipCtl.CreateCommunityUser(newContact.Id); 
            Test.stopTest();
        }

        User createdUser = [SELECT Id, Email, UserName, ContactId, FirstName, LastName FROM User WHERE UserName = :newContact.Email LIMIT 1];

        System.assert(createdUser != null, 'A user with a UserName of ' + newContact.Email + ' was not created');
        System.assertEquals(newContact.Email, createdUser.UserName);
        System.assertEquals(newContact.Email, createdUser.Email);
        System.assertEquals(newContact.FirstName, createdUser.FirstName);
        System.assertEquals(newContact.LastName, createdUser.LastName);
        System.assertEquals(newContact.Id, createdUser.ContactId);
    }

    @IsTest static void TestCreateSponsoringRelationship()
    {
        Account sponsoringAccount = [SELECT Id FROM Account WHERE Name='Test Sponsoring Account' LIMIT 1];
        Account sponsoredAccount = [SELECT Id FROM Account WHERE Name='Test Sponsored Account' LIMIT 1];
        
        Contact primaryContact = new Contact(LastName='TestCreateSponsoringRelationshipContact', AccountId=sponsoringAccount.Id);
        insert primaryContact;

        Sponsoring_Relationships__c relationShipToInsert = new Sponsoring_Relationships__c(
            Sponsoring_Organization__c = sponsoringAccount.Id,
            Sponsored_Organization__c = sponsoredAccount.Id,
            Primary_Contact_Lookup__c = primaryContact.Id
        );

        Sponsoring_Relationships__c newRelationship;
        Integer contactCountBeforeTest = [SELECT count() FROM Contact];

        System.runAs(CreateTestCommunityUser(primaryContact.Id, primaryContact.LastName))
        {
            Test.startTest();
            newRelationship = FON_CreateSponsoringRelationshipCtl.createSponsoringRelationship(relationShipToInsert, new Contact(FirstName='New', 
                                                                                                                                LastName='Contact'));
            Test.stopTest();
        }

        Integer contactCountAfterTest = [SELECT count() FROM Contact];
        
        System.assert(contactCountAfterTest > contactCountBeforeTest, 'A new contact wasn\'t inserted');
        System.assert(newRelationship != null);
    }

    @IsTest static void TestUpdateSponsoringRelationship()
    {
        Account sponsoringAccount = [SELECT Id FROM Account WHERE Name='Test Sponsoring Account' LIMIT 1];
        Account sponsoredAccount = [SELECT Id FROM Account WHERE Name='Test Sponsored Account' LIMIT 1];
        
        Contact primaryContact = new Contact(LastName='TestUpdateSponsoringRelationship', AccountId=sponsoringAccount.Id);
        insert primaryContact;

        Sponsoring_Relationships__c initalRelationship = InsertNewSponsorRelationship(sponsoringAccount, sponsoredAccount, primaryContact, true);
        initalRelationship.End_Date__c = Date.today();

        Test.startTest();
        Sponsoring_Relationships__c updatedRelationship = FON_CreateSponsoringRelationshipCtl.updateSponsoringRelationship(initalRelationship);
        Test.stopTest();

        System.assertEquals(initalRelationship.End_Date__c, updatedRelationship.End_Date__c);
    }

    @IsTest static void TestSendInvitation()
    {
        OrderApi__Badge_Type__c sponsorBadgeType = new OrderApi__Badge_Type__c(
            Name='Sponsor Agreement Badge'
        );
        insert sponsorBadgeType;

        OrderApi__Badge__c sponsorBadge = new OrderApi__Badge__c(
            OrderApi__Badge_Type__c=sponsorBadgeType.Id
        );
        insert sponsorBadge;

        Contact invitationTestContact = new Contact(LastName='TestSendInvitationContact', Email='testsendinvitation@fontevatest.com');
        insert invitationTestContact;

        Sponsoring_Relationships__c sponsorRelationship = [SELECT Id FROM Sponsoring_Relationships__c LIMIT 1];
        String message = 'HERE IS [formURL]';

        String returnedEmail;

        Test.startTest();
        try {
            returnedEmail = FON_CreateSponsoringRelationshipCtl.sendInvitation(invitationTestContact.Id, sponsorRelationship.Id, message);
        } catch (Exception ex) {
            System.debug('Received Error: ' + ex.getMessage());
        }
        // System.assertEquals(1, Limits.getEmailInvocations(), 'No Email was sent out'); 
        Test.stopTest();

        // System.assertEquals(invitationTestContact.Email, returnedEmail);
    }
}