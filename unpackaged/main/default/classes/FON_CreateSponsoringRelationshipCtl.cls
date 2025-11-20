/**
 * @description       : 
 * @author            : Malik Gray
 * @group             : 
 * @last modified on  : 01-20-2021
 * @last modified by  : Malik Gray
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   11-12-2020   Malik Gray   Initial Version
**/
global without sharing class FON_CreateSponsoringRelationshipCtl {
    @AuraEnabled(cacheable=true)
    public static Sponsoring_Relationships__c getSponsoringRelationship(String Id) {
        return [
            SELECT Id, Sponsoring_Organization__c, Sponsored_Organization__c, Primary_Contact_Lookup__c,
            Executed_By_Lookup__c, Mailing_Address_Street__c, Mailing_Address_City__c,
            Mailing_State__c, Mailing_Address_Zip_Code_Postal_Code__c, Mailing_Country__c,
            Future_Notification_Address_Street__c, Future_Notification_Address_City__c,
            Future_Notification_Address_State__c, Future_Notification_Address_Zip_Code__c,
            Future_Notification_Address_Country__c, Same_as_Mailing_Address__c,
            Legal_Organization_Name__c, Charter_Number__c, Organization_URL__c, Application_Submission_Options__c,
            Primary_R_T_Number__c, Status__c
            FROM Sponsoring_Relationships__c WHERE Id = :Id LIMIT 1
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Account getSponsoringOrganization(String Id) {
        return [SELECT Id, Name, Parent_Type__c, TCH_Membership_Type__c FROM Account WHERE Id = :Id LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static Account getSponsoredOrganization(String Id) {
        return [
            SELECT Id, Name, Primary_R_T_Number__c, FON_Charter_Number__c, Phone, Organization_URL__c
            //BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode
            FROM Account WHERE Id = :Id LIMIT 1
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getPrimaryContact(String Id) {
        return [
            SELECT Id, FirstName, LastName, Title, Email, OrderApi__Work_Phone__c 
            FROM Contact WHERE Id = :Id LIMIT 1
        ];
    }

    @AuraEnabled
    public static void createCommunityUser(String Id) {
        createCommunityUserAsync(Id);
    }

    @TestVisible @Future
    private static void createCommunityUserAsync(String Id) {
        System.debug('createCommunityUserAsync');
        
        Profile communityProfile = [
            SELECT Id FROM Profile
            WHERE Name = 'Fonteva Customer Community Login User' 
            LIMIT 1
        ];

        Contact contact = [
            SELECT Id, Email, FirstName, LastName FROM Contact
            WHERE Id = :Id
            LIMIT 1
        ];

        User user = new User(
            Username = contact.Email,
            FirstName = contact.FirstName,
            LastName = contact.LastName,
            Email = contact.Email,
            Alias = contact.FirstName.left(8),
            ContactId = Id,
            Profile = communityProfile,
            ProfileId = communityProfile.Id,
            EmailEncodingKey = 'UTF-8',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );

        System.debug('Profile ' + communityProfile);
        System.debug('Contact ' + contact);
        System.debug('CommunityUser ' + user);

        List<User> lstUser = new List<User>();
        lstUser.add(user);

        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = true;
        Database.insert(lstUser,dlo);
        //insert user;
    }

    @AuraEnabled
    public static Sponsoring_Relationships__c createSponsoringRelationship(
        Sponsoring_Relationships__c sponsoringRelationship,
        Contact contact
    ) {
        Savepoint savepoint = Database.setSavepoint();
        try {
            if(contact != null) {
                insert contact;
            }

            insert sponsoringRelationship;
        } catch (Exception ex) {
            System.debug('Found Exception: ' + ex.getMessage());

            Database.rollback(savepoint);
            return null;
        }

        return sponsoringRelationship;
    }

    @AuraEnabled
    public static Sponsoring_Relationships__c updateSponsoringRelationship(
        Sponsoring_Relationships__c sponsoringRelationship
    ) {
        Savepoint savepoint = Database.setSavepoint();
        try {
            update sponsoringRelationship;
        } catch (Exception ex) {
            Database.rollback(savepoint);
            throw new AuraHandledException(ex.getMessage());
        }

        return sponsoringRelationship;
    }

    @AuraEnabled(cacheable=false)
    public static String sendInvitation(String executedByContactId, String sponsoringRelationshipId, String message) {
        List<Contact> contacts = [SELECT Id, Name,FirstName,LastName, Email FROM Contact WHERE Id = :executedByContactId];
        List<OrderApi__Badge__c> badges = [
            SELECT Id, Name, OrderApi__Badge_Type__r.Name
            FROM OrderApi__Badge__c 
            WHERE OrderApi__Contact__c = :executedByContactId
            AND OrderApi__Badge_Type__r.Name = 'Sponsor Agreement Badge'
        ];
        List<Sponsoring_Relationships__c> sponsoringRelationships = [
            SELECT Id, Legal_Organization_Name__c,Sponsored_Organization__c,Sponsoring_Organization__c
            FROM Sponsoring_Relationships__c
            WHERE Id = :sponsoringRelationshipId
        ];
        Contact contact = contacts.get(0);

        // get contact user
        /*List<User> cusr = new List<User>();
        try {
            cusr = [SELECT Id FROM User WHERE ContactId = :executedByContactId];
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        if (cusr.size() < 1) {
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Fonteva Customer Community Login User'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = contact.FirstName;
            user.LastName = contact.LastName;
            user.Username = contact.Email;   
            user.CommunityNickname = String.valueOf(contact.Id).substring(0,6);
            user.Alias = String.valueOf(contact.Id).substring(0,6);
            user.Email = contact.Email;
            user.IsActive = true;
            user.ContactId = contact.Id;
          
            insert user;
        }*/

        Sponsoring_Relationships__c sponsoringRelationship = sponsoringRelationships.get(0);
        sponsoringRelationship.Status__c = 'Submitted to Sponsored Org Account for Review';
        sponsoringRelationship.Date_Submitted_for_Review__c = System.today();

        // setup form url
        String formURL = Label.Sponsoring_Agreement_Form_URL;
        String formURLCo = Label.Sponsoring_Agreement_Form_Coordinator_URL;
        //formURL = formURL.replace('[sponsor]', sponsoringRelationship.Sponsoring_Organization__c);
        //formURL = formURL.replace('[member]', sponsoringRelationship.Sponsored_Organization__c);
        formURL = formURL.replace('[relationship]', sponsoringRelationship.Id);
        formURL = formURL + '&soid='+ String.valueOf(sponsoringRelationship.Sponsoring_Organization__c);
        formURLCo = formURLCo.replace('[relationship]', sponsoringRelationship.Id);
        //formURLCo = formURLCo + '&soid='+ String.valueOf(sponsoringRelationship.Sponsoring_Organization__c) + '&smid='+String.valueOf(sponsoringRelationship.Sponsored_Organization__c) + '&srid='+String.valueOf(sponsoringRelationship.Id);
        formURLCo = formURLCo + '&srid='+String.valueOf(sponsoringRelationship.Id);

        sponsoringRelationship.Agreement_URL__c = formURL;
        sponsoringRelationship.Agreement_URL_Coordinator__c = formURLCo;

        formURL = formURL + '&srid='+String.valueOf(sponsoringRelationship.Id);

        formURL = '<a href="' + formURL + '">' + formURL + '</a>';
        message = message.replace('[formURL]', formURL);



        List<OrderApi__Badge_Type__c> badgeTypes = [
            SELECT Id, Name
            FROM OrderApi__Badge_Type__c
            WHERE Name = 'Sponsor Agreement Badge'
        ];

        OrderApi__Badge_Type__c sponsorAgreementBadgeType;

        if(!badgeTypes.isEmpty()) {
            sponsorAgreementBadgeType = badgeTypes.get(0);
        }

        if(badges.isEmpty()) {
            // Create a new Sponsor Agreement Badge
        }
        
        try {
            List<String> toAddresses = new List<String> { contact.Email };
            //String subject = 'Email for ' + contact.Name + ' Sponsoring Agreement with ' + 
            //    sponsoringRelationship.Legal_Organization_Name__c;
            String subject = 'Please complete your ECCHO Sponsored Member Agreement';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setHtmlBody(message);
            mail.setPlainTextBody(message);

            mail.setUseSignature(false);

            Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });

            update sponsoringRelationship;

            //display success or error message
            String resp;
            if (resultMail[0].isSuccess()) {
                resp = 'ok sent!';
            } else {
                resp = resultMail[0].getErrors().get(0).getMessage();
            }

            return contact.Email;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}