/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CreditMemo extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global Decimal amount;
    @AuraEnabled
    global Decimal appliedAmount;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Id creditAccount;
    @AuraEnabled
    global String customerLink;
    @AuraEnabled
    global Id debitAccount;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global Boolean isDrafted;
    @AuraEnabled
    global Boolean isPosted;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Date postedDate;
    @AuraEnabled
    global Decimal remainingAmount;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global String status;
    global CreditMemo() {

    }
    global override void fromSObject(SObject CreditMemoObj) {

    }
    global static FDService.CreditMemo getInstance() {
        return null;
    }
    global static FDService.CreditMemo getInstance(OrderApi__Credit_Memo__c CreditMemo) {
        return null;
    }
    global static List<FDService.CreditMemo> getInstance(List<OrderApi__Credit_Memo__c> CreditMemos) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
