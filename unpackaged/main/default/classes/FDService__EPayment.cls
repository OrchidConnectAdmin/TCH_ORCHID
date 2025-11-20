/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class EPayment extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global Decimal amount;
    @AuraEnabled
    global String apiAmount;
    @AuraEnabled
    global String apiResponse;
    @AuraEnabled
    global String avsCode;
    @AuraEnabled
    global String avsMessage;
    @AuraEnabled
    global String bankAccountHolderType;
    @AuraEnabled
    global String bankAccountNumber;
    @AuraEnabled
    global String bankAccountType;
    @AuraEnabled
    global String bankName;
    @AuraEnabled
    global String bankRoutingNumber;
    @AuraEnabled
    global Id batch;
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
    global Boolean cancelled;
    @AuraEnabled
    global String cardNumber;
    @AuraEnabled
    global String cardType;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Boolean createPaymentSchedule;
    @AuraEnabled
    global String currencyCode;
    @AuraEnabled
    global String cvvCode;
    @AuraEnabled
    global String cvvMessage;
    @AuraEnabled
    global Id depositAccount;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global Boolean eligibleForCardUpdater;
    @AuraEnabled
    global String email;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global Id ePayment;
    @AuraEnabled
    global Date epaymentDate;
    @AuraEnabled
    global List<FDService.EPaymentLine> ePaymentLines;
    @AuraEnabled
    global String errorCode;
    @AuraEnabled
    global String errors;
    @AuraEnabled
    global String firstName;
    @AuraEnabled
    global String firstSixDigits;
    @AuraEnabled
    global String fullName;
    @AuraEnabled
    global String gatewayToken;
    @AuraEnabled
    global String gatewayTransactionID;
    @AuraEnabled
    global Boolean hasErrors;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global String ipAddress;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isScheduled;
    @AuraEnabled
    global Boolean isVoided;
    @AuraEnabled
    global String last4Digits;
    @AuraEnabled
    global String lastFourDigits;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global String lastName;
    @AuraEnabled
    global Datetime lastReferencedDate;
    @AuraEnabled
    global Datetime lastViewedDate;
    @AuraEnabled
    global String maskedNumber;
    @AuraEnabled
    global String merchantLocationDescriptor;
    @AuraEnabled
    global String merchantNameDescriptor;
    @AuraEnabled
    global String message;
    @AuraEnabled
    global Integer month;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Integer numberOfInstallments;
    @AuraEnabled
    global Boolean onTestGateway;
    @AuraEnabled
    global String orderID;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global String path;
    @AuraEnabled
    global Id paymentGateway;
    @AuraEnabled
    global Id paymentMethod;
    @AuraEnabled
    global String paymentMethodToken;
    @AuraEnabled
    global String paymentMethodType;
    @AuraEnabled
    global Boolean pending;
    @AuraEnabled
    global String phone;
    @AuraEnabled
    global Boolean processPayment;
    @AuraEnabled
    global Boolean processVoid;
    @AuraEnabled
    global Boolean receiptCreated;
    @AuraEnabled
    global String referenceToken;
    @AuraEnabled
    global Id refundReceipt;
    @AuraEnabled
    global Boolean retainOnSuccess;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global Id scheduledPayment;
    @AuraEnabled
    global String scheduleFrequency;
    @AuraEnabled
    global String scheduleType;
    @AuraEnabled
    global Id sourceCode;
    @AuraEnabled
    global Date startDate;
    @AuraEnabled
    global String state;
    @AuraEnabled
    global String status;
    @AuraEnabled
    global String storageState;
    @AuraEnabled
    global Boolean succeeded;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global Decimal total;
    @AuraEnabled
    global String transactionToken;
    @AuraEnabled
    global String transactionType;
    @AuraEnabled
    global String verificationValue;
    @AuraEnabled
    global Integer year;
    global EPayment() {

    }
    global static FDService.EPayment getInstance() {
        return null;
    }
    global static FDService.EPayment getInstance(OrderApi__EPayment__c EPayment) {
        return null;
    }
    global static List<FDService.EPayment> getInstance(List<OrderApi__EPayment__c> EPayments) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
