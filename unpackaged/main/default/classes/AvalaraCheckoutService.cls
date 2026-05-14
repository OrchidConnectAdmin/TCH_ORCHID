/**
 * AuraEnabled controller for the AvalaraCheckout Spark Plug component.
 * Handles UI concerns: checkout info, entity address management, and delegates tax calculation.
 */
public without sharing class AvalaraCheckoutService {

    public class TaxableItem {
        @AuraEnabled public String name;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal total;
    }

    public class CheckoutInfo {
        @AuraEnabled public List<TaxableItem> taxableItems;
        @AuraEnabled public String entityId;
        @AuraEnabled public String entityType;
        @AuraEnabled public String street;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String postalCode;
        @AuraEnabled public String country;
    }

    @AuraEnabled
    public static CheckoutInfo getCheckoutInfo(String encryptedSalesOrderId) {
        Id salesOrderId = resolveSalesOrderId(encryptedSalesOrderId);
        OrderApi__Sales_Order__c so = querySalesOrder(salesOrderId);

        CheckoutInfo info = new CheckoutInfo();
        info.taxableItems = buildTaxableItems(so.OrderApi__Sales_Order_Lines__r);
        populateEntityAddress(info, so);

        return info;
    }

    @AuraEnabled
    public static void updateEntityAddress(String encryptedSalesOrderId, String entityId, String entityType, Boolean saveForFuture, String street, String city, String state, String postalCode, String country) {
        if (saveForFuture) {
            updateEntity(entityId, entityType, street, city, state, postalCode, country);
        }

        Id salesOrderId = resolveSalesOrderId(encryptedSalesOrderId);
        update new OrderApi__Sales_Order__c(
            Id = salesOrderId,
            OrderApi__Shipping_Street__c = street,
            OrderApi__Shipping_City__c = city,
            OrderApi__Shipping_State__c = state,
            OrderApi__Shipping_Postal_Code__c = postalCode,
            OrderApi__Shipping_Country__c = country
        );
    }

    @AuraEnabled
    public static void calculateTax(String encryptedSalesOrderId) {
        Id salesOrderId = resolveSalesOrderId(encryptedSalesOrderId);
        AvalaraTaxCalculationService.calculateTax(salesOrderId);
    }

    // ─── Private Helpers ───

    private static List<TaxableItem> buildTaxableItems(List<OrderApi__Sales_Order_Line__c> lines) {
        List<TaxableItem> items = new List<TaxableItem>();

        if (lines == null) {
            return items;
        }

        for (OrderApi__Sales_Order_Line__c sol : lines) {
            TaxableItem item = new TaxableItem();
            item.name = sol.OrderApi__Item__r.Name;
            item.quantity = sol.OrderApi__Quantity__c;
            item.total = sol.OrderApi__Total__c;
            items.add(item);
        }

        return items;
    }

    private static void populateEntityAddress(CheckoutInfo info, OrderApi__Sales_Order__c so) {
        if (so.OrderApi__Contact__c != null) {
            Contact ct = [
                SELECT MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                FROM Contact
                WHERE Id = :so.OrderApi__Contact__c
                WITH SYSTEM_MODE
            ];
            info.entityId = ct.Id;
            info.entityType = 'Contact';
            info.street = ct.MailingStreet;
            info.city = ct.MailingCity;
            info.state = ct.MailingState;
            info.postalCode = ct.MailingPostalCode;
            info.country = ct.MailingCountry;
        } else if (so.OrderApi__Account__c != null) {
            Account acc = [
                SELECT ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
                FROM Account
                WHERE Id = :so.OrderApi__Account__c
                WITH SYSTEM_MODE
            ];
            info.entityId = acc.Id;
            info.entityType = 'Account';
            info.street = acc.ShippingStreet;
            info.city = acc.ShippingCity;
            info.state = acc.ShippingState;
            info.postalCode = acc.ShippingPostalCode;
            info.country = acc.ShippingCountry;
        }
    }

    private static void updateEntity(String entityId, String entityType, String street, String city, String state, String postalCode, String country) {
        if (entityType == 'Contact') {
            update new Contact(
                Id = entityId,
                MailingStreet = street,
                MailingCity = city,
                MailingState = state,
                MailingPostalCode = postalCode,
                MailingCountry = country
            );
        } else if (entityType == 'Account') {
            update new Account(
                Id = entityId,
                ShippingStreet = street,
                ShippingCity = city,
                ShippingState = state,
                ShippingPostalCode = postalCode,
                ShippingCountry = country
            );
        }
    }

    private static OrderApi__Sales_Order__c querySalesOrder(Id salesOrderId) {
        return [
            SELECT Id, OrderApi__Contact__c, OrderApi__Account__c,
                   (SELECT Id, OrderApi__Item__r.Name,
                           OrderApi__Quantity__c, OrderApi__Total__c
                    FROM OrderApi__Sales_Order_Lines__r
                    WHERE OrderApi__Item__r.Avalara_Tax__c != null
                      AND OrderApi__Is_Shipping_Rate__c = false)
            FROM OrderApi__Sales_Order__c
            WHERE Id = :salesOrderId
            WITH SYSTEM_MODE
        ];
    }

    private static Id resolveSalesOrderId(String encryptedSalesOrderId) {
        List<OrderApi__Sales_Order__c> salesOrders = [
            SELECT Id
            FROM OrderApi__Sales_Order__c
            WHERE OrderApi__Encrypted_Id__c = :encryptedSalesOrderId
            WITH SYSTEM_MODE
            LIMIT 1
        ];

        if (salesOrders.isEmpty()) {
            throw new AvalaraAuthProviderService.AvalaraException('Sales Order not found for encrypted ID.');
        }

        return salesOrders[0].Id;
    }

}
