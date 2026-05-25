@isTest
private class AvalaraTaxCalculationServiceTest {

    private static final String TEST_STREET = '1600 Pennsylvania Avenue NW';
    private static final String TEST_CITY = 'Washington';
    private static final String TEST_STATE = 'District of Columbia';
    private static final String TEST_POSTAL_CODE = '20500';
    private static final String TEST_COUNTRY = 'United States';

    // ─── Mock Implementations ───

    private class TaxCalculationSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            if (request.getMethod() == 'GET') {
                response.setBody(buildResolveAddressSuccessJson());
            } else {
                response.setBody(buildCreateTransactionSuccessJson());
            }

            return response;
        }
    }

    private class AddressValidationFailMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"address":{"line1":"999 Fake St","city":"Nowhere","region":"ZZ","country":"US","postalCode":"00000"},'
                + '"validatedAddresses":[{"addressType":"UnknownAddressType","line1":"999 Fake St","city":"Nowhere","region":"ZZ","country":"US","postalCode":"00000"}],'
                + '"resolutionQuality":"External",'
                + '"messages":[{"summary":"Address not geocoded.","details":"Cannot be geocoded.","refersTo":"Address","severity":"Error","source":"Avalara.AvaTax.Common"}]'
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
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 100.00
        );
    }

    // ─── Helpers ───

    private static OrderApi__Sales_Order__c getTestSalesOrder() {
        return [SELECT Id FROM OrderApi__Sales_Order__c WHERE OrderApi__Contact__c != null LIMIT 1];
    }

    private static String buildResolveAddressSuccessJson() {
        return '{'
            + '"address":{"line1":"1600 Pennsylvania Avenue NW","city":"Washington","region":"DC","country":"US","postalCode":"20500"},'
            + '"validatedAddresses":[{"addressType":"StreetOrResidentialAddress","line1":"1600 PENNSYLVANIA AVE NW","city":"WASHINGTON","region":"DC","country":"US","postalCode":"20500-0005","latitude":38.897199,"longitude":-77.036548}],'
            + '"coordinates":{"latitude":38.897199,"longitude":-77.036548},'
            + '"resolutionQuality":"Intersection"'
            + '}';
    }

    private static String buildCreateTransactionSuccessJson() {
        return '{'
            + '"id":123456789,"code":"TX-TEST-001","status":"Temporary","type":"SalesOrder",'
            + '"totalTax":6.00,"totalTaxable":100.00,"totalAmount":100.00,"totalExempt":0,"totalDiscount":0,'
            + '"lines":[{"lineNumber":"1","tax":6.00,"taxableAmount":100.00,"taxCalculated":6.00,"lineAmount":100.00,"rate":0.06,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
            + '}';
    }

    // ─── calculateTax Tests ───

    @isTest
    static void should_create_tax_sols_for_taxable_lines() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new TaxCalculationSuccessMock());
        OrderApi__Sales_Order__c so = getTestSalesOrder();

        Test.startTest();
        AvalaraTaxCalculationService.calculateTax(so.Id);
        Test.stopTest();

        List<OrderApi__Sales_Order_Line__c> taxLines = [
            SELECT Id, OrderApi__Sale_Price__c, OrderApi__Quantity__c,
                   OrderApi__Price_Override__c, OrderApi__Item__c,
                   OrderApi__Sales_Order_Line__c
            FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :so.Id
              AND OrderApi__Item__r.Avalara_Tax_Code__c != null
              AND OrderApi__Item__r.Avalara_Tax__c = null
        ];

        System.assertEquals(1, taxLines.size(), 'Should create one tax SOL');
        System.assertEquals(6.00, taxLines[0].OrderApi__Sale_Price__c, 'Tax amount should match Avalara response');
        System.assertEquals(1, taxLines[0].OrderApi__Quantity__c, 'Tax SOL quantity should be 1');
        System.assertEquals(true, taxLines[0].OrderApi__Price_Override__c, 'Price override should be true');
        System.assertNotEquals(null, taxLines[0].OrderApi__Sales_Order_Line__c, 'Tax SOL should link to parent product SOL');
    }

    @isTest
    static void should_return_early_when_no_taxable_lines() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        OrderApi__Item__c nonTaxItem = new OrderApi__Item__c(Name = 'Non-Taxable Item');
        insert nonTaxItem;

        OrderApi__Sales_Order__c emptySo = new OrderApi__Sales_Order__c(
            OrderApi__Account__c = acc.Id,
            OrderApi__Shipping_Street__c = TEST_STREET,
            OrderApi__Shipping_City__c = TEST_CITY,
            OrderApi__Shipping_State__c = TEST_STATE,
            OrderApi__Shipping_Postal_Code__c = TEST_POSTAL_CODE,
            OrderApi__Shipping_Country__c = TEST_COUNTRY
        );
        insert emptySo;

        insert new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = emptySo.Id,
            OrderApi__Item__c = nonTaxItem.Id,
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 50.00
        );

        Test.startTest();
        AvalaraTaxCalculationService.calculateTax(emptySo.Id);
        Test.stopTest();

        List<OrderApi__Sales_Order_Line__c> allLines = [
            SELECT Id FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :emptySo.Id
        ];
        System.assertEquals(1, allLines.size(), 'Should only have the original non-taxable SOL, no callouts made');
    }

    @isTest
    static void should_throw_when_shipping_address_incomplete() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        OrderApi__Item__c productItem = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'Test Product'];

        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c(
            OrderApi__Account__c = acc.Id
        );
        insert so;

        insert new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = so.Id,
            OrderApi__Item__c = productItem.Id,
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 100.00
        );

        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            AvalaraTaxCalculationService.calculateTax(so.Id);
        } catch (AvalaraAuthProviderService.AvalaraException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('shipping address is incomplete'),
                'Should mention incomplete address: ' + e.getMessage());
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'Should throw when shipping address fields are blank');
    }

    @isTest
    static void should_throw_when_address_validation_fails() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new AddressValidationFailMock());
        OrderApi__Sales_Order__c so = getTestSalesOrder();

        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            AvalaraTaxCalculationService.calculateTax(so.Id);
        } catch (AvalaraAuthProviderService.AvalaraException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Address validation failed'),
                'Should indicate address validation failure: ' + e.getMessage());
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'Should throw when Avalara returns validation messages');
    }

    @isTest
    static void should_delete_existing_tax_lines_before_creating_new() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new TaxCalculationSuccessMock());
        OrderApi__Sales_Order__c so = getTestSalesOrder();
        OrderApi__Item__c taxItem = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'General Merchandise Tax'];

        // Pre-create an old tax SOL (simulates a previous calculateTax run)
        insert new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = so.Id,
            OrderApi__Item__c = taxItem.Id,
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 5.00,
            OrderApi__Price_Override__c = true
        );

        Integer linesBefore = [
            SELECT COUNT()
            FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :so.Id
        ];

        Test.startTest();
        AvalaraTaxCalculationService.calculateTax(so.Id);
        Test.stopTest();

        List<OrderApi__Sales_Order_Line__c> taxLines = [
            SELECT Id, OrderApi__Sale_Price__c
            FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :so.Id
              AND OrderApi__Item__r.Avalara_Tax_Code__c != null
              AND OrderApi__Item__r.Avalara_Tax__c = null
        ];

        System.assertEquals(1, taxLines.size(), 'Old tax SOL should be deleted, only new one remains');
        System.assertEquals(6.00, taxLines[0].OrderApi__Sale_Price__c, 'New tax SOL should have updated amount from Avalara');
    }

    // ─── commitTax Tests ───

    @isTest
    static void should_commit_tax_and_save_transaction_details() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new TaxCalculationSuccessMock());
        OrderApi__Sales_Order__c so = getTestSalesOrder();

        Test.startTest();
        AvalaraTaxCalculationService.commitTax(so.Id);
        Test.stopTest();

        so = [
            SELECT Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
            FROM OrderApi__Sales_Order__c
            WHERE Id = :so.Id
        ];

        System.assertEquals('TX-TEST-001', so.Avalara_Transaction_Code__c,
            'Transaction code should be persisted after commitTax');
        System.assertEquals('123456789', so.Avalara_Transaction_Id__c,
            'Transaction ID should be persisted after commitTax');
    }

    @isTest
    static void should_return_early_on_commit_when_no_taxable_lines() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        OrderApi__Item__c nonTaxItem = new OrderApi__Item__c(Name = 'Non-Taxable Commit');
        insert nonTaxItem;

        OrderApi__Sales_Order__c emptySo = new OrderApi__Sales_Order__c(
            OrderApi__Account__c = acc.Id,
            OrderApi__Shipping_Street__c = TEST_STREET,
            OrderApi__Shipping_City__c = TEST_CITY,
            OrderApi__Shipping_State__c = TEST_STATE,
            OrderApi__Shipping_Postal_Code__c = TEST_POSTAL_CODE,
            OrderApi__Shipping_Country__c = TEST_COUNTRY
        );
        insert emptySo;

        insert new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = emptySo.Id,
            OrderApi__Item__c = nonTaxItem.Id,
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 50.00
        );

        Test.startTest();
        AvalaraTaxCalculationService.commitTax(emptySo.Id);
        Test.stopTest();

        emptySo = [
            SELECT Avalara_Transaction_Code__c
            FROM OrderApi__Sales_Order__c
            WHERE Id = :emptySo.Id
        ];
        System.assertEquals(null, emptySo.Avalara_Transaction_Code__c,
            'No commit should happen when there are no taxable lines');
    }

    // ─── customerCode resolution ───

    @isTest
    static void should_use_account_as_customer_code_when_no_contact() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new TaxCalculationSuccessMock());
        Account acc = [SELECT Id FROM Account LIMIT 1];
        OrderApi__Item__c productItem = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'Test Product'];

        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c(
            OrderApi__Account__c = acc.Id,
            OrderApi__Shipping_Street__c = TEST_STREET,
            OrderApi__Shipping_City__c = TEST_CITY,
            OrderApi__Shipping_State__c = TEST_STATE,
            OrderApi__Shipping_Postal_Code__c = TEST_POSTAL_CODE,
            OrderApi__Shipping_Country__c = TEST_COUNTRY
        );
        insert so;

        insert new OrderApi__Sales_Order_Line__c(
            OrderApi__Sales_Order__c = so.Id,
            OrderApi__Item__c = productItem.Id,
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 75.00
        );

        Test.startTest();
        AvalaraTaxCalculationService.calculateTax(so.Id);
        Test.stopTest();

        List<OrderApi__Sales_Order_Line__c> taxLines = [
            SELECT Id
            FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :so.Id
              AND OrderApi__Item__r.Avalara_Tax_Code__c != null
              AND OrderApi__Item__r.Avalara_Tax__c = null
        ];
        System.assertEquals(1, taxLines.size(), 'Should create tax SOL using Account as customer code');
    }
}
