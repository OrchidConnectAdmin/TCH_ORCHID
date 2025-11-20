/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Subscription extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global String currentTermEndDate;
    @AuraEnabled
    global String currentTermStartDate;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global Boolean enableAutoRenew;
    @AuraEnabled
    global Date gracePeriodEndDate;
    @AuraEnabled
    global Boolean hideInPortal;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean inGracePeriod;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Boolean isCancelled;
    @AuraEnabled
    global Boolean isExpired;
    @AuraEnabled
    global Boolean isPending;
    @AuraEnabled
    global Boolean isSuspended;
    @AuraEnabled
    global Boolean isUpgraded;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global Id itemClass;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Date nextScheduledPaymentDate;
    @AuraEnabled
    global Date paidThroughDate;
    @AuraEnabled
    global Id paymentMethod;
    @AuraEnabled
    global String renewalOverride;
    @AuraEnabled
    global Id salesOrderLine;
    @AuraEnabled
    global String status;
    @AuraEnabled
    global String subscriptionManagementPageOverride;
    @AuraEnabled
    global String subscriptionPlan;
    @AuraEnabled
    global Decimal termActiveAssignments;
    @AuraEnabled
    global Decimal termAssignmentsAllowed;
    @AuraEnabled
    global Date termEndDate;
    @AuraEnabled
    global List<FDService.Term> terms;
    @AuraEnabled
    global Date termStartDate;
    @AuraEnabled
    global Id upgradedSubscription;
    global Subscription() {

    }
    global override virtual void fromSObject(SObject subscriptionObj) {

    }
    global static FDService.Subscription getInstance() {
        return null;
    }
    global static FDService.Subscription getInstance(OrderApi__Subscription__c sub) {
        return null;
    }
    global static List<FDService.Subscription> getInstance(List<OrderApi__Subscription__c> subs) {
        return null;
    }
}
