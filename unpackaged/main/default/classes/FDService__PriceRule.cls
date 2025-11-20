/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PriceRule extends FDService.WrapperBase {
    @AuraEnabled
    global String additionalCurrenciesJSON;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Integer currentNumAvailable;
    @AuraEnabled
    global Date endDate;
    @AuraEnabled
    global String id;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Boolean isDefault;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isEarlyBirdPrice;
    @AuraEnabled
    global Boolean isMultiCurrency;
    @AuraEnabled
    global Boolean isOnSitePrice;
    @AuraEnabled
    global Boolean isPromotionalPrice;
    @AuraEnabled
    global String item;
    @AuraEnabled
    global Id itemClass;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global Integer limitPerAccount;
    @AuraEnabled
    global Integer limitPerContact;
    @AuraEnabled
    global Integer maxAssignments;
    @AuraEnabled
    global Integer maxNumAvailable;
    @AuraEnabled
    global Integer maxQuantity;
    @AuraEnabled
    global Integer minAssignments;
    @AuraEnabled
    global Integer minQuantity;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Integer numTimesUsed;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global Decimal price;
    @AuraEnabled
    global List<FDService.PriceRuleVariable> priceRuleVariables;
    @AuraEnabled
    global String requiredBadgeTypes;
    @AuraEnabled
    global String requiredSourceCodes;
    @AuraEnabled
    global String requiredSubscriptionPlans;
    @AuraEnabled
    global Id scheduleItem;
    @AuraEnabled
    global Date startDate;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global Decimal taxInclusivePrice;
    @AuraEnabled
    global Id ticketType;
    global PriceRule() {

    }
    global override virtual void fromSObject(SObject priceRuleObj) {

    }
    global static FDService.PriceRule getInstance() {
        return null;
    }
    global static FDService.PriceRule getInstance(OrderApi__Price_Rule__c priceRuleObj) {
        return null;
    }
    global static List<FDService.PriceRule> getInstance(List<OrderApi__Price_Rule__c> priceRuleObjs) {
        return null;
    }
    global static List<FDService.PriceRule> getInstance(List<OrderApi__Price_Rule__c> priceRuleObjs, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
