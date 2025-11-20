/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class TransactionLine extends FDService.WrapperBase {
    @AuraEnabled
    global Date activationDate;
    @AuraEnabled
    global Boolean autoCalculateActivationDate;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Decimal conversionRate;
    @AuraEnabled
    global Id CreatedById;
    @AuraEnabled
    global Datetime CreatedDate;
    @AuraEnabled
    global Decimal credit;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Decimal debit;
    @AuraEnabled
    global Date endDate;
    @AuraEnabled
    global Id ePaymentLine;
    global static String FEATURE;
    @AuraEnabled
    global Id gLAccount;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global Id invoiceLine;
    @AuraEnabled
    global Boolean IsDeleted;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global Id itemClass;
    @AuraEnabled
    global Id LastModifiedById;
    @AuraEnabled
    global Datetime LastModifiedDate;
    @AuraEnabled
    global String memo;
    @AuraEnabled
    global String Name;
    @AuraEnabled
    global Id receipt;
    @AuraEnabled
    global Id receiptLine;
    @AuraEnabled
    global Id receiptLineR;
    @AuraEnabled
    global Id receiptR;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global Id salesOrderLine;
    @AuraEnabled
    global Id salesOrderLineR;
    @AuraEnabled
    global Id salesOrderR;
    @AuraEnabled
    global Id subscription;
    @AuraEnabled
    global Id subscriptionLine;
    @AuraEnabled
    global Id subscriptionPlan;
    @AuraEnabled
    global Datetime SystemModstamp;
    @AuraEnabled
    global Id transactionId;
    @AuraEnabled
    global Date transactionLineDate;
    @AuraEnabled
    global String type;
    global TransactionLine() {

    }
    global override void fromSObject(SObject transactionLineObj) {

    }
    global static FDService.TransactionLine getInstance() {
        return null;
    }
    global static FDService.TransactionLine getInstance(SObject tx) {
        return null;
    }
    global static List<FDService.TransactionLine> getInstance(List<SObject> txs) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
