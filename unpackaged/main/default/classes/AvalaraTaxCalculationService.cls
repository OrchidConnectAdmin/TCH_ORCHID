/**
 * Orchestrator for Avalara tax calculation.
 * Validates the shipping address, calls CreateTransaction (SalesOrder estimate),
 * then creates tax SOLs on the Sales Order for each response line.
 */
public without sharing class AvalaraTaxCalculationService {

    private class TaxContext {
        public Id salesOrderId;
        public OrderApi__Sales_Order__c salesOrder;
        public List<OrderApi__Sales_Order_Line__c> productLines;
        public Avalara_Config__mdt config;
        public AvalaraCreateTransaction.Address shipFrom;
        public AvalaraCreateTransaction.Address shipTo;
        public AvalaraCreateTransaction.Response response;
        public Map<String, Id> lineNumberToSolId;
        public Map<String, Id> lineNumberToTaxItemId;
    }

    public static void calculateTax(Id salesOrderId) {
        TaxContext ctx = new TaxContext();
        ctx.salesOrderId = salesOrderId;
        ctx.salesOrder = queryProductLines(salesOrderId);
        ctx.productLines = ctx.salesOrder.OrderApi__Sales_Order_Lines__r;

        if (ctx.productLines == null || ctx.productLines.isEmpty()) {
            return;
        }

        ctx.config = queryActiveConfig();
        ctx.shipFrom = buildShipFromAddress(ctx.config);
        ctx.shipTo = buildShipToAddress(ctx.salesOrder);

        validateAddress(ctx.shipTo);
        ctx.response = callCreateTransaction(ctx);
        replaceTaxLines(ctx);
    }

    // ─── Queries ───

    private static OrderApi__Sales_Order__c queryProductLines(Id salesOrderId) {
        return [
            SELECT Id, OrderApi__Contact__c, OrderApi__Account__c,
                   OrderApi__Shipping_Street__c, OrderApi__Shipping_City__c,
                   OrderApi__Shipping_State__c, OrderApi__Shipping_Postal_Code__c,
                   OrderApi__Shipping_Country__c,
                   (SELECT Id, OrderApi__Item__c, OrderApi__Item__r.Name,
                           OrderApi__Item__r.Avalara_Tax__c,
                           OrderApi__Item__r.Avalara_Tax__r.Avalara_Tax_Code__c,
                           OrderApi__Item__r.OrderApi__SKU__c,
                           OrderApi__Sale_Price__c, OrderApi__Quantity__c, OrderApi__Total__c
                    FROM OrderApi__Sales_Order_Lines__r
                    WHERE OrderApi__Item__r.Avalara_Tax__c != null
                      AND OrderApi__Is_Shipping_Rate__c = false)
            FROM OrderApi__Sales_Order__c
            WHERE Id = :salesOrderId
            WITH SYSTEM_MODE
        ];
    }

    private static Avalara_Config__mdt queryActiveConfig() {
        List<Avalara_Config__mdt> configs = [
            SELECT Company_Code__c, ShipFrom_Street__c, ShipFrom_City__c,
                   ShipFrom_State__c, ShipFrom_PostalCode__c, ShipFrom_Country__c
            FROM Avalara_Config__mdt
            WHERE Is_Active__c = true
            WITH SYSTEM_MODE
            LIMIT 1
        ];

        if (configs.isEmpty()) {
            throw new AvalaraAuthProviderService.AvalaraException('No active Avalara_Config__mdt record found.');
        }

        return configs[0];
    }

    // ─── Address ───

    private static AvalaraCreateTransaction.Address buildShipFromAddress(Avalara_Config__mdt config) {
        AvalaraCreateTransaction.Address address = new AvalaraCreateTransaction.Address();
        address.line1 = config.ShipFrom_Street__c;
        address.city = config.ShipFrom_City__c;
        address.region = config.ShipFrom_State__c;
        address.postalCode = config.ShipFrom_PostalCode__c;
        address.country = config.ShipFrom_Country__c;
        return address;
    }

    private static AvalaraCreateTransaction.Address buildShipToAddress(OrderApi__Sales_Order__c salesOrder) {
        AvalaraCreateTransaction.Address address = new AvalaraCreateTransaction.Address();
        address.line1 = salesOrder.OrderApi__Shipping_Street__c;
        address.city = salesOrder.OrderApi__Shipping_City__c;
        address.region = salesOrder.OrderApi__Shipping_State__c;
        address.postalCode = salesOrder.OrderApi__Shipping_Postal_Code__c;
        address.country = salesOrder.OrderApi__Shipping_Country__c;
        return address;
    }

    private static void validateAddress(AvalaraCreateTransaction.Address shipTo) {
        if (String.isBlank(shipTo.line1) || String.isBlank(shipTo.city) || String.isBlank(shipTo.region) || String.isBlank(shipTo.postalCode) || String.isBlank(shipTo.country)) {
            throw new AvalaraAuthProviderService.AvalaraException(
                'Address validation failed: shipping address is incomplete. Please update your address.'
            );
        }

        try {
            AvalaraResolveAddress.Request request = new AvalaraResolveAddress.Request();
            request.line1 = shipTo.line1;
            request.city = shipTo.city;
            request.region = shipTo.region;
            request.postalCode = shipTo.postalCode;
            request.country = shipTo.country;

            AvalaraResolveAddress.Response response = AvalaraResolveAddressService.execute(request);

            if (response.messages != null && !response.messages.isEmpty()) {
                throw new AvalaraAuthProviderService.AvalaraException(
                    'Address validation failed: ' + response.messages[0].summary
                );
            }
        } catch (AvalaraAuthProviderService.AvalaraException e) {
            if (e.getMessage().startsWith('Address validation failed')) {
                throw e;
            }
            throw new AvalaraAuthProviderService.AvalaraException(
                'Address validation failed: the shipping address could not be verified. Please update your address.'
            );
        }
    }

    // ─── Transaction ───

    private static AvalaraCreateTransaction.Response callCreateTransaction(TaxContext ctx) {
        AvalaraCreateTransaction.Request request = new AvalaraCreateTransaction.Request();
        request.companyCode = ctx.config.Company_Code__c;
        request.type = 'SalesOrder';
        request.transactionDate = String.valueOf(Date.today());
        request.customerCode = resolveCustomerCode(ctx.salesOrder);
        request.shipFromAddress = ctx.shipFrom;
        request.shipToAddress = ctx.shipTo;
        request.lineItems = buildLineItems(ctx.productLines);

        return AvalaraCreateTransactionService.execute(request);
    }

    private static String resolveCustomerCode(OrderApi__Sales_Order__c salesOrder) {
        if (salesOrder.OrderApi__Contact__c != null) {
            return salesOrder.OrderApi__Contact__c;
        }
        if (salesOrder.OrderApi__Account__c != null) {
            return salesOrder.OrderApi__Account__c;
        }
        return 'UNKNOWN';
    }

    private static List<AvalaraCreateTransaction.LineItem> buildLineItems(List<OrderApi__Sales_Order_Line__c> productLines) {
        List<AvalaraCreateTransaction.LineItem> lineItems = new List<AvalaraCreateTransaction.LineItem>();
        Integer lineNumber = 1;

        for (OrderApi__Sales_Order_Line__c sol : productLines) {
            AvalaraCreateTransaction.LineItem lineItem = new AvalaraCreateTransaction.LineItem();
            lineItem.number_x = String.valueOf(lineNumber);
            lineItem.quantity = sol.OrderApi__Quantity__c;
            lineItem.amount = sol.OrderApi__Total__c;
            lineItem.itemCode = String.isNotBlank(sol.OrderApi__Item__r.OrderApi__SKU__c)
                ? sol.OrderApi__Item__r.OrderApi__SKU__c
                : sol.OrderApi__Item__c;
            lineItem.taxCode = sol.OrderApi__Item__r.Avalara_Tax__r.Avalara_Tax_Code__c;
            lineItems.add(lineItem);
            lineNumber++;
        }

        return lineItems;
    }

    // ─── Tax SOL Management ───

    private static void replaceTaxLines(TaxContext ctx) {
        buildLineNumberMaps(ctx);
        deleteExistingTaxLines(ctx.salesOrderId);
        createTaxLines(ctx);
    }

    private static void buildLineNumberMaps(TaxContext ctx) {
        ctx.lineNumberToSolId = new Map<String, Id>();
        ctx.lineNumberToTaxItemId = new Map<String, Id>();
        Integer lineNumber = 1;

        for (OrderApi__Sales_Order_Line__c sol : ctx.productLines) {
            String key = String.valueOf(lineNumber);
            ctx.lineNumberToSolId.put(key, sol.Id);
            ctx.lineNumberToTaxItemId.put(key, sol.OrderApi__Item__r.Avalara_Tax__c);
            lineNumber++;
        }
    }

    private static void deleteExistingTaxLines(Id salesOrderId) {
        List<OrderApi__Sales_Order_Line__c> existingTaxLines = [
            SELECT Id
            FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :salesOrderId
              AND OrderApi__Item__r.Avalara_Tax_Code__c != null
              AND OrderApi__Item__r.Avalara_Tax__c = null
            WITH SYSTEM_MODE
        ];

        if (!existingTaxLines.isEmpty()) {
            delete existingTaxLines;
        }
    }

    private static void createTaxLines(TaxContext ctx) {
        List<OrderApi__Sales_Order_Line__c> taxLines = new List<OrderApi__Sales_Order_Line__c>();

        for (AvalaraCreateTransaction.ResponseLine responseLine : ctx.response.lines) {
            taxLines.add(new OrderApi__Sales_Order_Line__c(
                OrderApi__Sales_Order__c = ctx.salesOrderId,
                OrderApi__Price_Override__c = true,
                OrderApi__Sale_Price__c = responseLine.tax,
                OrderApi__Quantity__c = 1,
                OrderApi__Item__c = ctx.lineNumberToTaxItemId.get(responseLine.number_x),
                OrderApi__Sales_Order_Line__c = ctx.lineNumberToSolId.get(responseLine.number_x)
            ));
        }

        if (!taxLines.isEmpty()) {
            insert taxLines;
        }
    }
}
