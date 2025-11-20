/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Term extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global Decimal activeAssignments;
    @AuraEnabled
    global List<FDService.Assignment> assignments;
    @AuraEnabled
    global Decimal assignmentsAllowed;
    @AuraEnabled
    global Boolean cancellationRequested;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Datetime CreatedDate;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Date nextScheduledPaymentDate;
    @AuraEnabled
    global Id subscription;
    @AuraEnabled
    global List<FDService.SubscriptionLine> subscriptionLines;
    @AuraEnabled
    global Id subscriptionPlan;
    @AuraEnabled
    global Date termEndDate;
    @AuraEnabled
    global Date termStartDate;
    global Term() {

    }
    global static FDService.Term getInstance() {
        return null;
    }
    global static FDService.Term getInstance(OrderApi__Renewal__c term) {
        return null;
    }
    global static List<FDService.Term> getInstance(List<OrderApi__Renewal__c> terms) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
