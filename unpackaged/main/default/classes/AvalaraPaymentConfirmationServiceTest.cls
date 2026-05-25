@isTest
private class AvalaraPaymentConfirmationServiceTest {

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

        OrderApi__Receipt__c receipt = new OrderApi__Receipt__c(
            OrderApi__Sales_Order__c = so.Id,
            OrderApi__Contact__c = ct.Id
        );
        insert receipt;
    }

    // ─── Helpers ───

    private static String getReceiptName() {
        return [SELECT Name FROM OrderApi__Receipt__c LIMIT 1].Name;
    }

    // ─── enqueueCommitTax Tests ───

    @isTest
    static void should_enqueue_commit_when_taxable_lines_exist() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new CommitMock());

        Test.startTest();
        AvalaraPaymentConfirmationService.enqueueCommitTax(getReceiptName());
        Test.stopTest();

        OrderApi__Sales_Order__c so = [
            SELECT Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
            FROM OrderApi__Sales_Order__c
            WHERE OrderApi__Contact__c != null
            LIMIT 1
        ];

        System.assertEquals('TX-COMMIT-001', so.Avalara_Transaction_Code__c,
            'Transaction code should be persisted after commit');
        System.assertEquals('987654321', so.Avalara_Transaction_Id__c,
            'Transaction ID should be persisted after commit');
    }

    @isTest
    static void should_not_enqueue_when_no_taxable_lines() {
        OrderApi__Sales_Order__c so = [SELECT Id FROM OrderApi__Sales_Order__c LIMIT 1];

        // Remove all SOLs linked to taxable items
        delete [
            SELECT Id FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :so.Id
        ];

        // Create a non-taxable SOL
        OrderApi__Item__c nonTaxItem = new OrderApi__Item__c(Name = 'Non-Taxable');
        insert nonTaxItem;
        insert new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = so.Id,
            OrderApi__Item__c = nonTaxItem.Id,
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 25.00
        );

        Test.startTest();
        AvalaraPaymentConfirmationService.enqueueCommitTax(getReceiptName());
        Test.stopTest();

        so = [
            SELECT Avalara_Transaction_Code__c
            FROM OrderApi__Sales_Order__c
            WHERE Id = :so.Id
        ];

        System.assertEquals(null, so.Avalara_Transaction_Code__c,
            'No commit should happen when there are no taxable lines');
    }

    @isTest
    static void should_throw_when_receipt_not_found() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            AvalaraPaymentConfirmationService.enqueueCommitTax('INVALID-RECEIPT');
        } catch (AvalaraAuthProviderService.AvalaraException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Receipt not found'),
                'Should mention receipt not found: ' + e.getMessage());
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'Should throw when receipt number does not exist');
    }
}
