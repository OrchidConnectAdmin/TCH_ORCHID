/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Item extends FDService.WrapperBase {
    @AuraEnabled
    global String addToCartButtonLabelOverride;
    @AuraEnabled
    global String addToCartButtonOverride;
    @AuraEnabled
    global Id adjustmentAccount;
    @AuraEnabled
    global Id aRAccount;
    @AuraEnabled
    global String assignmentInstructions;
    @AuraEnabled
    global String assignmentsDisplayLabel;
    @AuraEnabled
    global List<FDService.Item> attributeItems;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Id deferredRevenueAccount;
    @AuraEnabled
    global Integer deferredRevenueTerm;
    @AuraEnabled
    global Boolean deferRevenue;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global Boolean disablePriceRules;
    @AuraEnabled
    global Id discountAccount;
    @AuraEnabled
    global String displayName;
    @AuraEnabled
    global Boolean enableAssignments;
    @AuraEnabled
    global Boolean enableCancellationRequest;
    @AuraEnabled
    global String eStoreDescription;
    @AuraEnabled
    global String eStoreShortDescription;
    @AuraEnabled
    global Integer flexDayOftheMonth;
    @AuraEnabled
    global Id form;
    @AuraEnabled
    global Id gainLossAccount;
    @AuraEnabled
    global Boolean hasIncludedItems;
    @AuraEnabled
    global String id;
    @AuraEnabled
    global List<String> images;
    @AuraEnabled
    global String imageUrl;
    @AuraEnabled
    global Id incomeAccount;
    @AuraEnabled
    global String interviewFormDisplayLabel;
    @AuraEnabled
    global String inventoryMessage;
    @AuraEnabled
    global Boolean isContribution;
    @AuraEnabled
    global Boolean isDefaultShippingRate;
    @AuraEnabled
    global Boolean isDefaultTaxRate;
    @AuraEnabled
    global Boolean isMultiCurrency;
    @AuraEnabled
    global Boolean isShippingCarrier;
    @AuraEnabled
    global Boolean isSubscription;
    @AuraEnabled
    global Boolean isTax;
    @AuraEnabled
    global Boolean isTaxable;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global Id itemClass;
    @AuraEnabled
    global List<FDService.PackageItem> itemPackageItems;
    @AuraEnabled
    global Decimal itemWeight;
    @AuraEnabled
    global String itemWeightUOM;
    @AuraEnabled
    global String lineDescription;
    @AuraEnabled
    global Decimal maximumValue;
    @AuraEnabled
    global Decimal maximumWeight;
    @AuraEnabled
    global Decimal minimumValue;
    @AuraEnabled
    global Decimal minimumWeight;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Decimal price;
    @AuraEnabled
    global List<FDService.PriceRule> priceRules;
    @AuraEnabled
    global Id refundAccount;
    @AuraEnabled
    global Id renewalForm;
    @AuraEnabled
    global Boolean requireAssignments;
    @AuraEnabled
    global Boolean requireShipping;
    @AuraEnabled
    global Date revenueRecognitionDate;
    @AuraEnabled
    global String revenueRecognitionRule;
    @AuraEnabled
    global String revenueRecognitionTermRule;
    @AuraEnabled
    global Id shippingRegion;
    @AuraEnabled
    global List<FDService.SubscriptionPlan> subscriptionPlans;
    @AuraEnabled
    global Id taxClass;
    @AuraEnabled
    global Id taxLocale;
    @AuraEnabled
    global Decimal taxPercent;
    global Item() {

    }
    global override virtual void fromSObject(SObject itemObj) {

    }
    global override virtual Object getFieldValueFromSObject(String fieldName) {
        return null;
    }
    global static FDService.Item getInstance() {
        return null;
    }
    global static FDService.Item getInstance(OrderApi__Item__c itemObj) {
        return null;
    }
    global static FDService.Item getInstance(OrderApi__Item__c itemObj, String className) {
        return null;
    }
    global static List<FDService.Item> getInstance(List<OrderApi__Item__c> itemObjs) {
        return null;
    }
    global static List<FDService.Item> getInstance(List<OrderApi__Item__c> itemObjs, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
