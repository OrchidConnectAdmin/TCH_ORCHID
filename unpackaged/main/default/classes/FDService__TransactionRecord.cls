/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class TransactionRecord extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global Id batch;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Id CreatedById;
    @AuraEnabled
    global Datetime CreatedDate;
    @AuraEnabled
    global Id creditMemo;
    @AuraEnabled
    global Id creditMemoLine;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global String customerLink;
    @AuraEnabled
    global String entity;
    global static String FEATURE;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global Boolean IsDeleted;
    @AuraEnabled
    global Boolean isValid;
    @AuraEnabled
    global Date LastActivityDate;
    @AuraEnabled
    global Id LastModifiedById;
    @AuraEnabled
    global Datetime LastModifiedDate;
    @AuraEnabled
    global Datetime LastReferencedDate;
    @AuraEnabled
    global Datetime LastViewedDate;
    @AuraEnabled
    global List<FDService.TransactionLine> lines;
    @AuraEnabled
    global String memo;
    @AuraEnabled
    global String Name;
    @AuraEnabled
    global Integer numLines;
    @AuraEnabled
    global Id OwnerId;
    @AuraEnabled
    global Id receipt;
    @AuraEnabled
    global String receiptType;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global Id sourceCode;
    @AuraEnabled
    global Id subscription;
    @AuraEnabled
    global Datetime SystemModstamp;
    @AuraEnabled
    global Decimal totalCredits;
    @AuraEnabled
    global Decimal totalDebits;
    @AuraEnabled
    global Date transactionDate;
    @AuraEnabled
    global String type;
    global TransactionRecord() {

    }
    global override void fromSObject(SObject transactionObj) {

    }
    global static FDService.TransactionRecord getInstance() {
        return null;
    }
    global static FDService.TransactionRecord getInstance(SObject tx) {
        return null;
    }
    global static List<FDService.TransactionRecord> getInstance(List<SObject> txs) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
