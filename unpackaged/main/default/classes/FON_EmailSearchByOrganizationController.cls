public with sharing class FON_EmailSearchByOrganizationController {
    @AuraEnabled
    public static Contact getSearchResults(String accountId, String email) {
        Contact contact = null;
        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Email = :email];
        if(!contacts.isEmpty()) {
            contact = contacts.get(0);
        }

        return contact;
    }
}