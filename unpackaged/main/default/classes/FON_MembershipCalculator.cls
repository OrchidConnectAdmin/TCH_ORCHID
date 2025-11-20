public without sharing class FON_MembershipCalculator {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String searchText) {
        String escapedSearchText = '%' + searchText.trim() + '%';
        return [
            SELECT Id, Name, Primary_R_T_Number__c, FON_Billing_Type__c, FON_Annual_Dues__c, FON_Is_Member__c,
            BillingAddress
            FROM Account WHERE Name LIKE :escapedSearchText AND FON_Billing_Type__c !='Exception'
            AND FON_Account_is_Archived__c = false AND FON_Is_Subsidiary__c = false AND Primary_R_T_Number__c != null
            LIMIT 50
        ];
    }
}