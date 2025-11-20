/**
 * @description       : 
 * @author            : Malik Gray
 * @group             : 
 * @last modified on  : 01-20-2021
 * @last modified by  : Malik Gray
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   01-20-2021   Malik Gray   Initial Version
**/
public without sharing class FON_RTNSearchController {
    public static String exactDigitsRequired = 'Please enter 9 digits for the R/T Number';
    public static String atLeast7DigitsRequired = 'Please enter at least 7 digits for the R/T Number';

    @AuraEnabled
    public static Account getSearchResults(String rtn, Boolean exactMatch) {
        Account account = null;

        if(String.isNotBlank(rtn)) {
            if(exactMatch) {
                if(rtn.length() != 9) {
                    throw new AuraHandledException(exactDigitsRequired);
                }

                account = searchByRTN(rtn);
            } else {
                if(rtn.length() < 7) {
                    throw new AuraHandledException(atLeast7DigitsRequired);
                }

                String calculatedRTN = FON_RTNCalculator.calculate(rtn);

                account = searchByRTN(calculatedRTN);
            }
        }

        return account;
    }

    private static Account searchByRTN(String rtn) {
        Account account = null;

        List<Account> accounts = [
            SELECT Id, Name, BillingCity, BillingState FROM Account 
            WHERE Primary_R_T_Number__c = :rtn
            AND FON_Account_is_Archived__c = false AND FON_Is_Subsidiary__c = false
        ];
        if(accounts.size() > 0) {
            account = accounts.get(0);
        } else {
            List<Account> additionalRTNAccounts = [
                SELECT Id, Name, BillingCity, BillingState FROM Account 
                WHERE  Id IN (SELECT Account__c FROM Additional_RT_Number__c WHERE Additional_RT_Number__c = :rtn)
            ];

            if(additionalRTNAccounts.size() > 0) {
                account = additionalRTNAccounts.get(0);
            }
        }

        return account;
    }
}