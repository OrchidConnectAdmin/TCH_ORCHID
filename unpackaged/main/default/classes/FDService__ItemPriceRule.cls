/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ItemPriceRule extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global List<FDService.Badge> badges;
    @Deprecated
    global List<FDService.BadgeType> badgesTypes;
    @AuraEnabled
    global List<FDService.BadgeType> badgeTypes;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Decimal convertedPrice;
    @AuraEnabled
    global Decimal convertedRate;
    @AuraEnabled
    global Decimal convertedTaxIncludedPrice;
    @AuraEnabled
    global Boolean convertPrice;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global FDService.PriceRule priceRule;
    @AuraEnabled
    global String priceRuleCurrencyJSON;
    @AuraEnabled
    global Integer quantity;
    @AuraEnabled
    global Id sourceCode;
    @AuraEnabled
    global String sourceCurrency;
    @AuraEnabled
    global Decimal sourcePrice;
    @AuraEnabled
    global String sourceSObjectId;
    @AuraEnabled
    global Id subPlan;
    @AuraEnabled
    global String targetCurrency;
    global ItemPriceRule() {

    }
    global override void fromSObject(SObject priceRuleObj) {

    }
    global static FDService.ItemPriceRule getInstance() {
        return null;
    }
    global static FDService.ItemPriceRule getInstance(OrderApi__Price_Rule__c priceRuleObj) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
