/**
 * Tests for GetCYRILPCSparkPlugController.
 *
 * getSalesOrder() resolves an order number to either a Sales Order (preferred)
 * or, failing that, a Receipt, and always returns the matching Sales Order Lines.
 * enqueueAvalaraCommit() delegates to AvalaraPaymentConfirmationService.
 *
 * Both controller methods operate on a single order/receipt number, so there is
 * no meaningful bulk path; coverage focuses on the order / receipt / not-found
 * branches and the commit delegation (happy path + receipt-not-found).
 */
@isTest
private class GetCYRILPCSparkPlugControllerTest {

    // Reuses the commit response shape from AvalaraPaymentConfirmationServiceTest
    private class CommitMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            if (request.getMethod() == 'GET') {
                response.setBody('{'
                    + '"address":{"line1":"1600 Pennsylvania Avenue NW","city":"Washington","region":"DC","country":"US","postalCode":"20500"},'
                    + '"validatedAddresses":[{"addressType":"StreetOrResidentialAddress","line1":"1600 PENNSYLVANIA AVE NW","city":"WASHINGTON","region":"DC","country":"US","postalCode":"20500-0005"}],'
                    + '"resolutionQuality":"Intersection"'
                    + '}');
            } else {
                response.setBody('{'
                    + '"id":987654321,"code":"TX-COMMIT-001","status":"Committed","type":"SalesInvoice",'
                    + '"totalTax":8.00,"totalTaxable":100.00,"totalAmount":100.00,"totalExempt":0,"totalDiscount":0,'
                    + '"lines":[{"lineNumber":"1","tax":8.00,"taxableAmount":100.00,"taxCalculated":8.00,"lineAmount":100.00,"rate":0.08,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
                    + '}');
            }

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

        OrderApi__Item__c taxItem = new OrderApi__Item__c(
            Name = 'General Merchandise Tax',
            Avalara_Tax_Code__c = 'P0000000'
        );
        insert taxItem;

        OrderApi__Item__c productItem = new OrderApi__Item__c(
            Name = 'Test Product',
            Avalara_Tax__c = taxItem.Id
        );
        insert productItem;

        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c(
            OrderApi__Contact__c = ct.Id,
            OrderApi__Account__c = acc.Id,
            OrderApi__Shipping_Street__c = '1600 Pennsylvania Avenue NW',
            OrderApi__Shipping_City__c = 'Washington',
            OrderApi__Shipping_State__c = 'District of Columbia',
            OrderApi__Shipping_Postal_Code__c = '20500',
            OrderApi__Shipping_Country__c = 'United States'
        );
        insert so;

        insert new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = so.Id,
            OrderApi__Item__c = productItem.Id,
            OrderApi__Quantity__c = 2,
            OrderApi__Sale_Price__c = 50.00
        );

        insert new OrderApi__Receipt__c(
            OrderApi__Sales_Order__c = so.Id,
            OrderApi__Contact__c = ct.Id
        );
    }

    // ─── Helpers ───

    private static OrderApi__Sales_Order__c getSalesOrder() {
        return [
            SELECT Id, Name
            FROM OrderApi__Sales_Order__c
            WHERE OrderApi__Contact__c != null
            LIMIT 1
        ];
    }

    private static String getReceiptName() {
        return [SELECT Name FROM OrderApi__Receipt__c LIMIT 1].Name;
    }

    // ─── getSalesOrder: order-number branch ───

    @isTest
    static void should_return_order_and_lines_when_order_number_matches() {
        OrderApi__Sales_Order__c so = getSalesOrder();

        Test.startTest();
        Map<String, List<SObject>> result =
            GetCYRILPCSparkPlugController.getSalesOrder(so.Name);
        Test.stopTest();

        System.assert(result.containsKey('order'), 'Order key should be present when the Sales Order name matches');
        System.assertEquals(1, result.get('order').size(), 'Exactly one Sales Order should be returned');
        System.assertEquals(so.Name,
            ((OrderApi__Sales_Order__c) result.get('order')[0]).Name,
            'Returned Sales Order should be the one queried by name');

        System.assert(!result.containsKey('receipt'), 'Receipt key should NOT be set when the order is found directly');

        System.assertEquals(1, result.get('lines').size(), 'The single Sales Order Line should be returned');
        System.assertEquals('Test Product',
            ((OrderApi__Sales_Order_Line__c) result.get('lines')[0]).OrderApi__Item__r.Name,
            'Returned line should reference the product item');
    }

    // ─── getSalesOrder: receipt branch (no matching order) ───

    @isTest
    static void should_return_receipt_and_lines_when_only_receipt_matches() {
        OrderApi__Sales_Order__c so = getSalesOrder();
        String receiptName = getReceiptName();

        Test.startTest();
        Map<String, List<SObject>> result =
            GetCYRILPCSparkPlugController.getSalesOrder(receiptName);
        Test.stopTest();

        System.assert(!result.containsKey('order'), 'Order key should be absent when no Sales Order name matches');
        System.assert(result.containsKey('receipt'), 'Receipt key should be present when the receipt name matches');
        System.assertEquals(1, result.get('receipt').size(), 'Exactly one Receipt should be returned');
        System.assertEquals(so.Id,
            ((OrderApi__Receipt__c) result.get('receipt')[0]).OrderApi__Sales_Order__r.Id,
            'Receipt should be linked to the test Sales Order');

        System.assertEquals(1, result.get('lines').size(),
            'Lines for the receipt\'s Sales Order should be returned');
        System.assertEquals('Test Product',
            ((OrderApi__Sales_Order_Line__c) result.get('lines')[0]).OrderApi__Item__r.Name,
            'Returned line should reference the product item');
    }

    // ─── getSalesOrder: neither order nor receipt matches (ListException path) ───

    @isTest
    static void should_return_empty_collections_when_nothing_matches() {
        Test.startTest();
        Map<String, List<SObject>> result =
            GetCYRILPCSparkPlugController.getSalesOrder('NO-SUCH-ORDER-9999');
        Test.stopTest();

        System.assert(!result.containsKey('order'), 'Order key should be absent when nothing matches');
        System.assert(result.get('receipt').isEmpty(), 'Receipt list should be empty when nothing matches');
        System.assert(result.get('lines').isEmpty(), 'Lines should be empty when no Sales Order could be resolved');
    }

    // ─── enqueueAvalaraCommit: delegates to AvalaraPaymentConfirmationService ───

    @isTest
    static void should_enqueue_commit_for_valid_receipt() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new CommitMock());

        Test.startTest();
        GetCYRILPCSparkPlugController.enqueueAvalaraCommit(getReceiptName());
        Test.stopTest();

        OrderApi__Sales_Order__c so = [
            SELECT Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
            FROM OrderApi__Sales_Order__c
            WHERE OrderApi__Contact__c != null
            LIMIT 1
        ];
        System.assertEquals('TX-COMMIT-001', so.Avalara_Transaction_Code__c,
            'Delegated commit should persist the Avalara transaction code');
        System.assertEquals('987654321', so.Avalara_Transaction_Id__c,
            'Delegated commit should persist the Avalara transaction id');
    }

    @isTest
    static void should_throw_when_receipt_not_found_on_commit() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            GetCYRILPCSparkPlugController.enqueueAvalaraCommit('INVALID-RECEIPT');
        } catch (AvalaraAuthProviderService.AvalaraException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Receipt not found'),
                'Exception should indicate the receipt was not found: ' + e.getMessage());
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'enqueueAvalaraCommit should surface the receipt-not-found error');
    }
}
