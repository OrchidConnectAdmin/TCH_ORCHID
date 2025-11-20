/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class BusinessGroup extends FDService.WrapperBase {
    @AuraEnabled
    global Id aRAccount;
    @AuraEnabled
    global String businessEntityType;
    @AuraEnabled
    global Boolean calculateSalesTax;
    @AuraEnabled
    global Id createdById;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Id creditMemoAccount;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global String customerSupportURL;
    @AuraEnabled
    global Id defaultPaymentGateway;
    @AuraEnabled
    global Id depositAccount;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global String displayName;
    @AuraEnabled
    global String email;
    @AuraEnabled
    global Boolean enableShippingByOrderTotal;
    @AuraEnabled
    global String homepageURL;
    @AuraEnabled
    global Id id;
    @AuraEnabled
    global String invoiceFooter;
    @AuraEnabled
    global String invoiceFooterHTML;
    @AuraEnabled
    global String invoiceHeader;
    @AuraEnabled
    global String invoiceHeaderFieldsetCSV;
    @AuraEnabled
    global String invoiceHeaderHTML;
    @AuraEnabled
    global String invoiceLinesFieldset;
    @AuraEnabled
    global Decimal invoiceOverPaymentCreditMemoLimit;
    @AuraEnabled
    global String invoicePageOverride;
    @AuraEnabled
    global Id invoiceWriteOffAccount;
    @AuraEnabled
    global Decimal invoiceWriteOffLimit;
    @AuraEnabled
    global Boolean isDeleted;
    @AuraEnabled
    global Boolean isMaster;
    @AuraEnabled
    global Id lastModifiedById;
    @AuraEnabled
    global Datetime lastModifiedDate;
    @AuraEnabled
    global Datetime lastReferencedDate;
    @AuraEnabled
    global Datetime lastViewedDate;
    @AuraEnabled
    global String mailingAddress;
    @AuraEnabled
    global String merchantLocation;
    @AuraEnabled
    global String merchantName;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global Id ownerId;
    @AuraEnabled
    global Id parentBusinessGroup;
    @AuraEnabled
    global String phone;
    @AuraEnabled
    global Boolean proformaInvoiceAuthenticationRequired;
    @AuraEnabled
    global String proformaInvoiceEmailBody;
    @AuraEnabled
    global String proformaInvoiceEmailFromAddress;
    @AuraEnabled
    global String proformaInvoiceEmailFromName;
    @AuraEnabled
    global String proformaInvoiceEmailSubject;
    @AuraEnabled
    global String proformaInvoiceFooter;
    @AuraEnabled
    global String proformaInvoiceHeader;
    @AuraEnabled
    global String receiptFooterHTML;
    @AuraEnabled
    global String receiptHeaderFieldsetCSV;
    @AuraEnabled
    global String receiptHeaderHTML;
    @AuraEnabled
    global String receiptLinesFieldset;
    @AuraEnabled
    global String receiptPageOverride;
    @AuraEnabled
    global String requiredTaxFieldsCSV;
    @AuraEnabled
    global String shippingRateBasis;
    @AuraEnabled
    global Datetime systemModstamp;
    @AuraEnabled
    global Id theme;
    @AuraEnabled
    global Id transfersPayableAccount;
    @AuraEnabled
    global Id transfersReceivableAccount;
    @AuraEnabled
    global String type;
    global BusinessGroup() {

    }
    global override virtual void fromSObject(SObject BusinessGroupObj) {

    }
    global static FDService.BusinessGroup getInstance() {
        return null;
    }
    global static FDService.BusinessGroup getInstance(OrderApi__Business_Group__c BusinessGroup) {
        return null;
    }
    global static List<FDService.BusinessGroup> getInstance(List<OrderApi__Business_Group__c> BusinessGroups) {
        return null;
    }
    global override SObject toSObject() {
        return null;
    }
}
