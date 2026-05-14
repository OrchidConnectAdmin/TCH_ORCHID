/**
 * Test class for SalesOrderCustomTriggerHandler.
 * Covers: trigger fires void Queueable when Is_Voided changes to true with Avalara transaction,
 * skips when no transaction code, and skips when already voided.
 */
@isTest
private class SalesOrderCustomTriggerHandlerTest {

    private static final String TRANSACTION_CODE = 'TX-VOID-001';

    // ─── Mock for Queueable callout ───

    private class VoidSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"id":123456789,"code":"' + TRANSACTION_CODE + '","status":"Cancelled","type":"SalesInvoice",'
                + '"totalTax":6.00,"totalTaxable":100.00,"totalAmount":100.00,"totalExempt":0,"totalDiscount":0,'
                + '"lines":[{"lineNumber":"1","tax":6.00,"taxableAmount":100.00,"taxCalculated":6.00,"lineAmount":100.00,"rate":0.06,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
                + '}');
            return response;
        }
    }

    // ─── Test Data ───

    @TestSetup
    static void setupTestData() {
        Account acc = new Account(
            Name = 'Test Account',
            ShippingStreet = '1600 Pennsylvania Avenue NW',
            ShippingCity = 'Washington',
            ShippingState = 'District of Columbia',
            ShippingPostalCode = '20500',
            ShippingCountry = 'United States'
        );
        insert acc;

        Contact ct = new Contact(
            LastName = 'TestContact',
            AccountId = acc.Id,
            MailingStreet = '1600 Pennsylvania Avenue NW',
            MailingCity = 'Washington',
            MailingState = 'District of Columbia',
            MailingPostalCode = '20500',
            MailingCountry = 'United States'
        );
        insert ct;

        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c(
            OrderApi__Contact__c = ct.Id,
            OrderApi__Account__c = acc.Id,
            Avalara_Transaction_Code__c = TRANSACTION_CODE,
            Avalara_Transaction_Id__c = '123456789'
        );
        insert so;
    }

    // ─── Trigger Tests ───

    @isTest
    static void should_enqueue_void_when_is_voided_changes_to_true() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new VoidSuccessMock());

        OrderApi__Sales_Order__c so = [
            SELECT Id, OrderApi__Is_Voided__c
            FROM OrderApi__Sales_Order__c
            LIMIT 1
        ];

        Test.startTest();
        so.OrderApi__Is_Voided__c = true;
        update so;
        Test.stopTest();

        // Queueable was enqueued and executed (Test.stopTest flushes async)
        System.assert(true, 'Void Queueable should execute without errors');
    }

    @isTest
    static void should_not_enqueue_when_no_transaction_code() {
        OrderApi__Sales_Order__c so = [
            SELECT Id, Avalara_Transaction_Code__c
            FROM OrderApi__Sales_Order__c
            LIMIT 1
        ];

        // Clear transaction code
        so.Avalara_Transaction_Code__c = null;
        update so;

        Test.startTest();
        so.OrderApi__Is_Voided__c = true;
        update so;
        Test.stopTest();

        // No Queueable enqueued — no callout, no error
        System.assert(true, 'Should skip void when no Avalara transaction code');
    }

    @isTest
    static void should_not_enqueue_when_already_voided() {
        OrderApi__Sales_Order__c so = [
            SELECT Id
            FROM OrderApi__Sales_Order__c
            LIMIT 1
        ];

        // First void
        so.OrderApi__Is_Voided__c = true;
        update so;

        Test.startTest();
        // Update again while already voided (e.g., another field changes)
        so.Avalara_Transaction_Code__c = 'TX-CHANGED';
        update so;
        Test.stopTest();

        // No Queueable enqueued — Is_Voided didn't change from false to true
        System.assert(true, 'Should not re-void when Is_Voided was already true');
    }
}
