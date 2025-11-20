/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class SalesOrderLine extends FDService.WrapperBase {
    @AuraEnabled
    global Id account;
    @AuraEnabled
    global Date activationDate;
    @AuraEnabled
    global Integer activeAssignments;
    @AuraEnabled
    global String adjustmentReason;
    @AuraEnabled
    global Decimal adjustments;
    @AuraEnabled
    global Decimal amountPaid;
    @AuraEnabled
    global Decimal amountRefunded;
    @AuraEnabled
    global Id aRAccount;
    @AuraEnabled
    global Integer assignmentsAllowed;
    @AuraEnabled
    global Integer assignmentsAvailable;
    @AuraEnabled
    global Id attendee;
    @AuraEnabled
    global Boolean autoAssign;
    @AuraEnabled
    global Boolean autoAssignAccountContacts;
    @AuraEnabled
    global Boolean autoAssignContact;
    @AuraEnabled
    global String autoAssignRule;
    @AuraEnabled
    global Boolean autoCalculateActivationDate;
    @AuraEnabled
    global Boolean autoRenew;
    @AuraEnabled
    global Decimal balanceDue;
    @AuraEnabled
    global Id businessGroup;
    @AuraEnabled
    global Boolean calculateShippingDetails;
    @AuraEnabled
    global Id contact;
    @AuraEnabled
    global Decimal conversionRate;
    @AuraEnabled
    global Id CreatedById;
    @AuraEnabled
    global String CreatedDate;
    @AuraEnabled
    global Id creditMemo;
    @AuraEnabled
    global Id creditNote;
    @AuraEnabled
    global Decimal creditsApplied;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global Boolean deferredRevenueAdjustment;
    @AuraEnabled
    global Boolean disableScheduling;
    @AuraEnabled
    global Boolean displayItem;
    @AuraEnabled
    global Boolean doNotCollectPayment;
    @AuraEnabled
    global Boolean enableAutoRenew;
    @AuraEnabled
    global Date endDate;
    @AuraEnabled
    global String entity;
    @AuraEnabled
    global Id event;
    global String foreignKey;
    @AuraEnabled
    global Id gLAccount;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global Boolean incomplete;
    @AuraEnabled
    global Boolean isAdjustment;
    @AuraEnabled
    global Boolean isAmendment;
    @AuraEnabled
    global Boolean IsDeleted;
    @AuraEnabled
    global Boolean isInstallmentCalculated;
    @AuraEnabled
    global Boolean isLinePosted;
    @AuraEnabled
    global Boolean isMultiCurrencyOrg;
    @AuraEnabled
    global Boolean isPosted;
    @AuraEnabled
    global Boolean isRenewal;
    @AuraEnabled
    global Boolean isRequiredPackageItem;
    @AuraEnabled
    global Boolean isRequiredScheduleItem;
    @AuraEnabled
    global Boolean isShippingRate;
    @AuraEnabled
    global Boolean isSubscription;
    @AuraEnabled
    global Boolean isTax;
    @AuraEnabled
    global Boolean isValid;
    @AuraEnabled
    global Id item;
    @AuraEnabled
    global Id itemClass;
    @AuraEnabled
    global Decimal itemTaxPercent;
    @AuraEnabled
    global Id LastModifiedById;
    @AuraEnabled
    global String LastModifiedDate;
    @AuraEnabled
    global String lineDescription;
    @AuraEnabled
    global List<FDService.SalesOrderLine> lines;
    @AuraEnabled
    global Decimal listPrice;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Decimal overallTotal;
    @AuraEnabled
    global String packageItem;
    global String parentForeignKey;
    @AuraEnabled
    global Boolean parentIsInstallmentCalculated;
    @AuraEnabled
    global Decimal parentTotal;
    @AuraEnabled
    global Decimal parentTotalInstallmentPrice;
    @AuraEnabled
    global Decimal paymentAmount;
    @AuraEnabled
    global Id paymentMethod;
    @AuraEnabled
    global Integer paymentPriority;
    @AuraEnabled
    global Date postedDate;
    @AuraEnabled
    global Boolean priceOverride;
    @AuraEnabled
    global Id priceRule;
    @AuraEnabled
    global Integer quantity;
    @AuraEnabled
    global Decimal requiredPackageItems;
    global Boolean requirePaymentMethod;
    @AuraEnabled
    global Decimal salePrice;
    @AuraEnabled
    global Id salesOrder;
    @AuraEnabled
    global Id salesOrderLine;
    @AuraEnabled
    global Id salesOrderLineR;
    @AuraEnabled
    global Id scheduleItem;
    @AuraEnabled
    global String shippingCity;
    @AuraEnabled
    global String shippingContact;
    @AuraEnabled
    global String shippingCountry;
    @AuraEnabled
    global String shippingMethod;
    @AuraEnabled
    global String shippingPostalCode;
    @AuraEnabled
    global String shippingState;
    @AuraEnabled
    global String shippingStreet;
    @AuraEnabled
    global String shippingTrackingNumber;
    @AuraEnabled
    global Id sponsorPackage;
    @AuraEnabled
    global Id subscription;
    @AuraEnabled
    global Id subscriptionPlan;
    @AuraEnabled
    global Date subscriptionStartDate;
    @AuraEnabled
    global Decimal subtotal;
    @AuraEnabled
    global Datetime SystemModstamp;
    @AuraEnabled
    global Boolean systemOverride;
    @AuraEnabled
    global Decimal taxAmount;
    @AuraEnabled
    global Boolean taxOverride;
    @AuraEnabled
    global Decimal taxPercent;
    @AuraEnabled
    global Id ticketType;
    @AuraEnabled
    global Decimal total;
    @AuraEnabled
    global Decimal totalInstallmentPrice;
    @AuraEnabled
    global Decimal totalWithTax;
    global SalesOrderLine() {

    }
    global override virtual void fromSObject(SObject salesOrderLineObj) {

    }
    global static FDService.SalesOrderLine getInstance() {
        return null;
    }
    global static FDService.SalesOrderLine getInstance(OrderApi__Sales_Order_Line__c sol) {
        return null;
    }
    global static List<FDService.SalesOrderLine> getInstance(List<OrderApi__Sales_Order_Line__c> sols) {
        return null;
    }
    global static List<FDService.SalesOrderLine> getInstance(List<OrderApi__Sales_Order_Line__c> sols, String className) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
