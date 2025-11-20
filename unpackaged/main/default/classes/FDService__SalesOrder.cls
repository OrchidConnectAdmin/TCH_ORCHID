/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class SalesOrder extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global String adjustmentReason;
    @AuraEnabled
    global Decimal amountPaid;
    @AuraEnabled
    global Decimal amountRefunded;
    @AuraEnabled
    global Decimal balanceDue;
    @AuraEnabled
    global String billingCity;
    @AuraEnabled
    global String billingCountry;
    @AuraEnabled
    global String billingPostalCode;
    @AuraEnabled
    global String billingState;
    @AuraEnabled
    global String billingStreet;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Boolean calculateBillingDetails;
    @AuraEnabled
    global Boolean calculateShippingDetails;
    @AuraEnabled
    global Date closedDate;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Datetime CreatedDate;
    @AuraEnabled
    global Decimal creditsAndAdjustments;
    @AuraEnabled
    global Decimal creditsApplied;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Date dueDate;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global Id epayment;
    @AuraEnabled
    global Boolean generateInstallments;
    @AuraEnabled
    global Boolean hasInstallments;
    @AuraEnabled
    global Boolean hasSubscription;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Date invoiceDate;
    @AuraEnabled
    global Boolean isClosed;
    @AuraEnabled
    global Boolean isInvoiced;
    @AuraEnabled
    global Boolean isMultiCurrencyOrg;
    @AuraEnabled
    global Boolean isOpen;
    @AuraEnabled
    global Boolean isPendingPayment;
    @AuraEnabled
    global Boolean isPosted;
    @AuraEnabled
    global Boolean isProforma;
    @AuraEnabled
    global Boolean isScheduled;
    @AuraEnabled
    global Boolean isVoided;
    @AuraEnabled
    global List<FDService.SalesOrderLine> lines;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Integer numberOfInstallments;
    @AuraEnabled
    global Decimal overallTotal;
    @AuraEnabled
    global Date paidDate;
    @AuraEnabled
    global Decimal paymentAmount;
    @AuraEnabled
    global String paymentGateway;
    @AuraEnabled
    global Id paymentMethod;
    @AuraEnabled
    global String paymentTerms;
    @AuraEnabled
    global Date postedDate;
    @AuraEnabled
    global String postingEntity;
    @AuraEnabled
    global String postingStatus;
    @AuraEnabled
    global Id receipt;
    @AuraEnabled
    global Boolean requirePaymentMethod;
    @AuraEnabled
    global Id salesOrderR;
    @AuraEnabled
    global String salesOrderStatus;
    @AuraEnabled
    global String scheduleFrequency;
    @AuraEnabled
    global String scheduleType;
    @AuraEnabled
    global String shippingCity;
    @AuraEnabled
    global String shippingCountry;
    @AuraEnabled
    global String shippingPostalCode;
    @AuraEnabled
    global String shippingState;
    @AuraEnabled
    global String shippingStreet;
    @AuraEnabled
    global Id sourceCode;
    @AuraEnabled
    global Date startDate;
    @AuraEnabled
    global String status;
    @AuraEnabled
    global Decimal total;
    @AuraEnabled
    global Boolean validPaymentMethod;
    global SalesOrder() {

    }
    global override virtual void fromSObject(SObject salesOrderObj) {

    }
    global static FDService.SalesOrder getInstance() {
        return null;
    }
    global static FDService.SalesOrder getInstance(OrderApi__Sales_Order__c so) {
        return null;
    }
    global static List<FDService.SalesOrder> getInstance(List<OrderApi__Sales_Order__c> sos) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
