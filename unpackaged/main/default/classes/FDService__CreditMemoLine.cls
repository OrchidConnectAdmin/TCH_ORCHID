/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CreditMemoLine extends FDService.WrapperBase {
    @AuraEnabled
    global Decimal amount;
    @AuraEnabled
    global Id CreatedById;
    @AuraEnabled
    global Datetime CreatedDate;
    @AuraEnabled
    global Id creditAccount;
    @AuraEnabled
    global Id creditMemo;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Id invoice;
    @AuraEnabled
    global Id invoiceLine;
    @AuraEnabled
    global Boolean IsDeleted;
    @AuraEnabled
    global Boolean isDrafted;
    @AuraEnabled
    global Boolean isPosted;
    @AuraEnabled
    global Id LastModifiedById;
    @AuraEnabled
    global Datetime LastModifiedDate;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id salesOrderLine;
    @AuraEnabled
    global String status;
    @AuraEnabled
    global Datetime SystemModstamp;
    global CreditMemoLine() {

    }
    global override void fromSObject(SObject CreditMemoLineObj) {

    }
    global static FDService.CreditMemoLine getInstance() {
        return null;
    }
    global static FDService.CreditMemoLine getInstance(SObject CreditMemoLine) {
        return null;
    }
    global static List<FDService.CreditMemoLine> getInstance(List<SObject> CreditMemoLines) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
