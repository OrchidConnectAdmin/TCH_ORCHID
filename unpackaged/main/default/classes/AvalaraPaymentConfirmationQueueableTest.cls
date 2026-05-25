@isTest
private class AvalaraPaymentConfirmationQueueableTest {

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
                    + '"id":111222333,"code":"TX-Q-001","status":"Committed","type":"SalesInvoice",'
                    + '"totalTax":5.00,"totalTaxable":100.00,"totalAmount":100.00,"totalExempt":0,"totalDiscount":0,'
                    + '"lines":[{"lineNumber":"1","tax":5.00,"taxableAmount":100.00,"taxCalculated":5.00,"lineAmount":100.00,"rate":0.05,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
                    + '}');
            }

            return response;
        }
    }

    private class FailingMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setBody('{"error":{"code":"ServerError","message":"Internal error"}}');
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
            OrderApi__Quantity__c = 1,
            OrderApi__Sale_Price__c = 100.00
        );
    }

    @isTest
    static void should_commit_tax_and_persist_transaction_details() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new CommitMock());
        OrderApi__Sales_Order__c so = [SELECT Id FROM OrderApi__Sales_Order__c LIMIT 1];

        Test.startTest();
        System.enqueueJob(new AvalaraPaymentConfirmationQueueable(so.Id));
        Test.stopTest();

        so = [
            SELECT Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
            FROM OrderApi__Sales_Order__c
            WHERE Id = :so.Id
        ];

        System.assertEquals('TX-Q-001', so.Avalara_Transaction_Code__c,
            'Transaction code should be persisted');
        System.assertEquals('111222333', so.Avalara_Transaction_Id__c,
            'Transaction ID should be persisted');
    }

    @isTest
    static void should_not_throw_when_commit_fails() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new FailingMock());
        OrderApi__Sales_Order__c so = [SELECT Id FROM OrderApi__Sales_Order__c LIMIT 1];

        Test.startTest();
        System.enqueueJob(new AvalaraPaymentConfirmationQueueable(so.Id));
        Test.stopTest();

        so = [
            SELECT Avalara_Transaction_Code__c
            FROM OrderApi__Sales_Order__c
            WHERE Id = :so.Id
        ];

        System.assertEquals(null, so.Avalara_Transaction_Code__c,
            'Transaction code should remain null when commit fails (error caught gracefully)');
    }
}
