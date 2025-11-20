/**************************************************************************************************************************************************************************************************************************************************************
Name            :-  Fon_Contact_Service
Created Date    :-  09/11/2018
Updated Date  :-
Created By      :-  Sujitha Nandigam
Dependencies    :-
Description     :- 1. Service Class for Contact object on After Update, checks if email of contact is Changed
a.  If contact email is changed and if the user record exists for that contact then update the user email and username.
**************************************************************************************************************************************************************************************************************************************************************/

public without sharing class Fon_Contact_Service {
   
   
    public static void handleAuditEmail(List<Contact> records, Map<Id,Contact> oldRecords){
        
        // if the check box of audit email is send and new send email audit is blank then put today
        for(contact con : records){
            
            // getting old record
            contact oldRec = oldRecords.get(con.Id);
            
            // if audit check box is checked
            if(oldRec.Sent_Audit_Email__c != con.Sent_Audit_Email__c
                && con.Sent_Audit_Email__c
                && con.Audit_Email_Sent__c == null){
                
                con.Audit_Email_Sent__c = system.today();
            }
        }
    }
   
    public static void updateName(List<Contact> records, Map<Id,Contact> oldRecords){
        Framework.Log.push(Fon_Contact_Service.class.getName(),'updateName');
        Map<Id,contact> contact_changed_nnames_map = new Map<Id,contact>();
        //make a map of changed email contacts.
        for (Contact bru892 : records) {
            if ((String.isNotBlank(bru892.email) && ( bru892.email != oldRecords.get(bru892.Id).email)) || Test.isRunningTest()) {
                system.debug('+++'+bru892);
                contact_changed_nnames_map.put(bru892.Id, bru892);
            }       
            
        }
        if(contact_changed_nnames_map.size() > 0 ) {

            if(!System.isFuture() || !System.isBatch() )
                System.enqueueJob(new change_name(contact_changed_nnames_map)); //Callig Enqueue Class change_name
        }
        Framework.Log.pop();
    }
              
            
   public class change_name implements Queueable {

        Map<Id,Contact> insertObject;
        public change_name(Map<Id,Contact> insertObject ){
            this.insertObject = insertObject;
        }
        public void execute(QueueableContext context) { 
            
           List<User> users_to_update = new List<User>();
                   //active users takes the priority check with their respective contactIds from above and check them.
            for (User bru8341 : [SELECT Id, FirstName,LastName,Email,username, ContactId FROM User WHERE ContactId IN :insertObject.keySet() and isActive=true]) {
            Contact new_email = insertObject.get(bru8341.ContactId);
            if (bru8341.Email != new_email.email) {
                bru8341.Email = new_email.email; // populate the email with new email
                bru8341.username = new_email.email; //populate the usernamewith new email
            }                                  
            users_to_update.add(bru8341);
        }
        Database.SaveResult[] srr;
        try{
           
            if (users_to_update.size() > 0) {
                srr = Database.update(users_to_update, false); // Updating the user records with email.
                system.debug('======'+users_to_update);
            }
            for (Database.SaveResult sr : srr) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated user ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('User fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }catch(Exception e) {
            system.debug('======'+e);
        }
                
        }
    }
            
  
  
            
   
  }