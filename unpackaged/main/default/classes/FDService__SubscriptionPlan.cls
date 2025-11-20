/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SubscriptionPlan extends FDService.WrapperBase {
    @AuraEnabled
    global String autoRenewOption;
    @AuraEnabled
    global String billCycle;
    @AuraEnabled
    global String billCycleDay;
    @AuraEnabled
    global String billCycleMonth;
    @AuraEnabled
    global String calenderEndDay;
    @AuraEnabled
    global String calenderEndMonth;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global Boolean disableRenew;
    @AuraEnabled
    global Boolean enableAutomaticInvoicePayment;
    @AuraEnabled
    global Boolean enableSchedule;
    @AuraEnabled
    global String gracePeriod;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Boolean isDefault;
    @AuraEnabled
    global String itemRenewalInstructions;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String paymentSettingsInstructions;
    @AuraEnabled
    global Decimal postTermRenewalWindow;
    @AuraEnabled
    global Decimal preTermRenewalWindow;
    @AuraEnabled
    global String prorationRule;
    @AuraEnabled
    global String renewalTermMonths;
    @AuraEnabled
    global Boolean requirePaymentMethod;
    @AuraEnabled
    global String scheduleFrequency;
    @AuraEnabled
    global String scheduleType;
    @AuraEnabled
    global String type;
    global SubscriptionPlan() {

    }
    global static FDService.SubscriptionPlan getInstance() {
        return null;
    }
    global static FDService.SubscriptionPlan getInstance(OrderApi__Subscription_Plan__c sub) {
        return null;
    }
    global static List<FDService.SubscriptionPlan> getInstance(List<OrderApi__Subscription_Plan__c> subs) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
