global class CreateUserInvocable {
    // https://developer.salesforce.com/forums/?id=9060G0000005nusQAA

    @InvocableMethod(label='Create User' Description='Create User')
    global static List<User> fetchUser(List<methodVars> vars) {
        Profile communityProfile = [
            SELECT Id FROM Profile
            WHERE Name =: vars[0].profile
            LIMIT 1
        ];

        Contact contact = [
            SELECT Id, Email, FirstName, LastName FROM Contact
            WHERE Id =: vars[0].contact
            LIMIT 1
        ];

        User user = new User(
            Username = contact.Email,
            FirstName = contact.FirstName,
            LastName = contact.LastName,
            Email = contact.Email,
            Alias = contact.FirstName.left(1)+contact.LastName.right(1)+String.valueOf(contact.Id).right(6),
            CommunityNickname = contact.FirstName.left(1)+contact.LastName.right(1)+String.valueOf(contact.Id).right(6),
            ContactId = contact.Id,
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
		
        return lstUser;
    }
    global class methodVars{
        @InvocableVariable
        global String profile;
        
        @InvocableVariable
        global String contact;
        
    }
}