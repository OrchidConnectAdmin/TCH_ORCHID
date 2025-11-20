/**
 * @description       : 
 * @author            : Malik Gray
 * @group             : 
 * @last modified on  : 11-12-2020
 * @last modified by  : Malik Gray
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   11-12-2020   Malik Gray   Initial Version
**/
public class FON_UserDetailsController {
    @AuraEnabled(cacheable=true)
    public static String getUserAccountId(String userId) {
        String accountId = null;
        User user = [SELECT Id, Contact.AccountId FROM User WHERE Id = :userId];
        if(user.Contact != null && user.Contact.AccountId != null) {
            accountId = user.Contact.AccountId;
        }

        return accountId;
    }

    @AuraEnabled(cacheable=true)
    public static String getUserDetails(String userId) {
        User user = [SELECT Id, Name FROM User WHERE Id = :userId];
        return user.Name;
    }
}