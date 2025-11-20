/**
 * @description       : 
 * @author            : Malik Gray
 * @group             : 
 * @last modified on  : 12-22-2020
 * @last modified by  : Malik Gray
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   12-14-2020   Malik Gray   Initial Version
**/
global without sharing class FON_SponsoringRelationshipController {
    @AuraEnabled(cacheable=true)
    public static List<Sponsoring_Relationships__c> getSponsoringRelationshipsBySponsoringOrganizationId(String Id) {
        return [
            SELECT Id, Sponsoring_Organization__r.Name, Sponsored_Organization__r.Name, Status__c,
            Primary_R_T_Number__c, Date_Accepted_by_ECCHO__c
            FROM Sponsoring_Relationships__c
            WHERE Sponsoring_Organization__c = :Id
            ORDER BY Sponsored_Organization__r.Name ASC
        ];
    }
}