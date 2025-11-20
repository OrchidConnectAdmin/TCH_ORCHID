global class CreateAttendeeUserInvocable {
    // https://developer.salesforce.com/forums/?id=9060G0000005nusQAA

    @InvocableMethod(label='Create User from Sales Order' Description='Create User from Sales Order')
    global static void fetchUser(List<methodVars> vars) {
        List<User> lstUser = new List<User>();
        
       
        // Get AttendeesEventApi__Contact__c	
        List<EventApi__Attendee__c> att = [SELECT ContactID__c FROM EventApi__Attendee__c WHERE EventApi__Sales_Order__c =: vars[0].so LIMIT 100];
            
        if(att.size() > 0){

			for (Integer i = 0, j = 0; i < att.size(); i++) {
                
                // check if there's user record already
                String cid = String.valueOf(att[i].get('ContactID__c'));
                createUser(cid);

            }
            
            
        }
		//Database.insert(lstUser);
		
        //return lstUser;
    }
    @future(callout=true) public static void createUser(String rid) {
                // get contact
                Contact contact = [
                    SELECT Id, Email, FirstName, LastName FROM Contact
                    WHERE Id =: rid
                    LIMIT 1
                ];
        
                // get profile    
                Profile communityProfile = [
                    SELECT Id FROM Profile
                    WHERE Name = 'Fonteva Customer Community Login User'
                    LIMIT 1
                ];
                
                try{
                	User cuser = [SELECT Id FROM User WHERE ContactID__c =: rid];
                
                } catch (Exception e) {
                //if(cuser.size() < 1){
                    User usr = new User();
                    usr.Username = contact.Email;
                    usr.FirstName = contact.FirstName;
                    usr.LastName = contact.LastName;
                    usr.Email = contact.Email;
                    usr.Alias = contact.FirstName;
                    usr.CommunityNickname = contact.FirstName;
                    usr.ContactId = rid;
                    usr.Profile = communityProfile;
                    usr.ProfileId = communityProfile.Id;
                    usr.EmailEncodingKey = 'UTF-8';
                    usr.TimeZoneSidKey = 'America/Los_Angeles';
                    usr.LocaleSidKey = 'en_US';
                    usr.LanguageLocaleKey = 'en_US';
                    //usr.IsActive = true;
                    //Insert usr;
            
                    System.debug('CommunityUser ' + usr);
                    
                    List<User> lstUser = new List<User>();
                    lstUser.add(usr);
                    Database.DMLOptions dlo = new Database.DMLOptions();
                    dlo.EmailHeader.triggerUserEmail = true;
                    Database.insert(lstUser,dlo);
                   
                    //
                }
    }
    global class methodVars{
        @InvocableVariable
        global String profile;
        
        @InvocableVariable
        global String so;
        
    }
}