# Avalara Tax Integration - SOA Analysis & TCH Implementation Plan

**Ticket**: 26657020 - Avalara Taxes
**Project**: TCH (The Clearing House Payments Company L.L.C.)
**Date**: 2026-05-11
**Decision**: Pure REST API (no managed package / no connector)

---

## 1. SOA_ENG5 Architecture Summary

SOA uses a **hybrid approach**: managed packages (`AVA_B2BLEX`, `AVA_MAPPER`, `AVA_SFCLOUD`) + custom Apex orchestration built by Orchid Connect.

### Two tax calculation flows in SOA

#### Flow A: Portal Orders (buyer checkout)
```
OrchCartCalc (CartExtension.CartCalculate)
  -> prices -> promotions -> inventory -> shipping -> taxes
  -> Avalara managed package runs automatically via CartExtension
  -> CartCalcTaxAdjustmentFix corrects AdjustmentTaxAmount sign mismatch
```

#### Flow B: Admin-Created Orders (3-phase async queueable chain)
```
Triggers:
  - OrderItem AfterInsert/AfterUpdate -> OrderTaxCalculationService
  - Order AfterUpdate (status -> 'Pending Payment'/'Invoiced'/'Closed') -> OrderAfterUpdateHandler

Phase 1: OrderTaxCalculationQueueable (DML only)
  -> Load Order, validate eligibility (admin-created = no ContactId on CreatedBy)
  -> Create temporary secondary WebCart via WebCartManager
  -> Copy OrderItems -> CartItems (only products with AvaTax_TaxCode__c)
  -> Setup delivery address from ContactPointAddress
  -> Apply OrderItem adjustments to CartItems

Phase 2: OrderTaxCalloutQueueable (Callout)
  -> AVA_B2BLEX.AvaTaxCalculation.getTax(request) -- managed package callout
  -> Avalara creates CartTax records asynchronously

Phase 3: OrderTaxCopyQueueable (DML)
  -> Delete existing OrderItemTaxLineItem records
  -> Copy CartTax/CartItem tax -> OrderItemTaxLineItem (matched by Product2Id + Quantity)
  -> Cleanup: mark temp cart as secondary
```

### SOA Classes Inventory

| Class | Role | Type |
|-------|------|------|
| `OrderTaxCalculationService` | Orchestrator + @AuraEnabled entry point | Custom |
| `OrderTaxCalculationQueueable` | Phase 1: Cart creation (DML) | Custom |
| `OrderTaxCalloutQueueable` | Phase 2: Avalara callout | Custom |
| `OrderTaxCopyQueueable` | Phase 3: Tax copy to OrderItemTaxLineItem | Custom |
| `WebCartManager` | Creates/manages temporary WebCarts | Custom |
| `CartCalcTaxAdjustmentFix` | Fixes AdjustmentTaxAmount sign mismatch | Custom |
| `AvalaraSyncService` | Product sync to Avalara (CRUD, HTTP callouts) | Custom |
| `AvalaraProductManagerController` | LWC controller for product management UI | Custom |
| `AvalaraBulkUpdateAction` | @InvocableMethod for Flow bulk product updates | Custom |
| `Product2TriggerHandler` | Auto-assigns tax codes, syncs to AVA_B2BLEX__TaxCode__c | Custom |
| `OrchCartCalc` | Cart calculation orchestrator (portal checkout) | Custom |
| `OrderAfterUpdateHandler` | Triggers tax calc on Order status change | Custom |
| `OC_OrderItemAfterInsertHandler` | Triggers tax calc on item insert | Custom |
| `OC_OrderItemAfterUpdateHandler` | Triggers tax calc on item update | Custom |
| `AVA_B2BLEX__AvaTaxCalculation` | Managed package - actual Avalara API callout | Managed |
| `AVA_MAPPER__*` | Managed package - TaxCalculator, PostTaxCalculator, etc. | Managed |

### SOA Configuration

| Item | Value |
|------|-------|
| Named Credential | `AvalaraAPI_External` |
| Custom Metadata | `AvalaraSyncConfig__mdt` (CompanyId, BatchSize, MaxRetries, IsEnabled) |
| Product2 custom fields | `Is_Product_Taxable__c`, `AvaTax_TaxCode__c`, `AvaTax_Item_Code__c`, `AvaTax_Sync_Status__c`, `AvaTax_Sync_Date__c`, `AvaTax_Product_Item_Id__c`, `AvaTax_Error_Message__c`, `AvaTax_Flag_Item_for_Deletion__c`, `AvaTax_Item_Type__c` |
| Managed Package Field | `AVA_B2BLEX__TaxCode__c` on Product2 |
| WebStore | `9.18store` (hardcoded default) |
| Tax record target | `OrderItemTaxLineItem` (standard object) |
| Flows | `Avalara_Product_Creation_Manual`, `Avalara_Products_Deletion`, `Avalara_Sync_Item_IDs` |
| LWCs | `avalaraProductManager`, `avalaraCustomDatatable`, `avalaraEditablePicklist` |

---

## 2. Why Pure REST API

### Blocker
Avalara sandbox (Account ID: 2000002768) only has "API" as available integration. User lacks admin permissions to install any connector. Tanya Renne requested admin access (Apr 30, 2026) -- no update yet.

### Consequence
- Cannot install `AVA_B2BLEX` (B2B Commerce connector)
- Cannot install `AVA_MAPPER` (generic XML mapper framework)
- Cannot install `AVA_SFCLOUD` (Sales Cloud connector)
- Must build HTTP callouts directly to AvaTax REST API v2

### Object model difference
- SOA uses standard B2B Commerce: `Product2`, `WebCart`, `CartItem`, `Order`, `OrderItem`, `OrderItemTaxLineItem`
- TCH uses Fonteva: `OrderApi__Item__c`, `OrderApi__Sales_Order__c`, `OrderApi__Sales_Order_Line__c`
- This means SOA's WebCart/CartItem flow is NOT reusable

---

## 3. What SOA Gives Us (Reusable for TCH)

### Code patterns (~10% direct reuse)

| What | Source | Value |
|------|--------|-------|
| HTTP callout with Named Credential + pagination | `AvalaraSyncService.fetchAvalaraItems()` | Base pattern for all Avalara API calls |
| Custom Metadata config structure | `AvalaraSyncConfig__mdt` | Copy, add CompanyCode + Environment |
| 3-phase Queueable chain (DML -> Callout -> DML) | `OrderTaxCalculation*Queueable` | Architecture pattern for async tax calc |
| Concurrency guards | `FOR UPDATE` lock, `TaxCalc_` dedup, 10min cutoff | Prevent duplicate calculations |

### Knowledge (~30% design reuse)

| What | Source | Value |
|------|--------|-------|
| Request field mappings | AVA_MAPPER PDF pages 38-43 | Exactly which fields go into the JSON payload |
| Response field mappings | AVA_MAPPER PDF pages 38-43 | Which response fields to write back |
| API flow sequence | AVA_MAPPER PDF pages 30-49 | calculateTax -> postTax -> commitTax -> cancelTax/voidTax |
| Authentication pattern | AVA_MAPPER PDF page 30 | Basic auth: AccountId + LicenseKey |
| DocumentType enums | AVA_MAPPER PDF | SalesInvoice, SalesOrder, ReturnInvoice |

### NOT reusable (~60% -- must build from scratch)

| SOA Class | Why not reusable |
|-----------|------------------|
| `WebCartManager` | Depends on WebCart, CartItem, ConnectApi.CommerceCart -- B2B Commerce only |
| `OrderTaxCalculationQueueable` | Creates WebCart temporary, copies OrderItem -> CartItem |
| `OrderTaxCalloutQueueable` | Calls `AVA_B2BLEX.AvaTaxCalculation.getTax()` |
| `OrderTaxCopyQueueable` | Copies CartTax -> OrderItemTaxLineItem |
| `OrderTaxCalculationService` | Orchestrates all above |
| `OrchCartCalc` | CartExtension.CartCalculate -- B2B Commerce only |
| `Product2TriggerHandler` | All queries reference Product2 fields |
| `AvalaraProductManagerController` | All queries reference Product2 fields |
| LWCs | Columns/fields reference Product2 |

---

## 4. Avalara REST API v2 - Payload Reference

Derived from the AVA_MAPPER XML mappings and PDF documentation.

### Request: POST /api/v2/transactions/create

```json
{
  "type": "SalesInvoice",
  "companyCode": "TCH_COMPANY_CODE",
  "date": "2026-05-11",
  "customerCode": "ACME_CORP",
  "commit": false,
  "addresses": {
    "shipFrom": {
      "line1": "TCH Origin Address",
      "city": "New York",
      "region": "NY",
      "country": "US",
      "postalCode": "10006"
    },
    "shipTo": {
      "line1": "123 Main St",
      "city": "Chicago",
      "region": "IL",
      "country": "US",
      "postalCode": "60601"
    }
  },
  "lines": [
    {
      "number": "1",
      "itemCode": "ANNUAL-MEMBERSHIP",
      "taxCode": "SW054000",
      "amount": 500.00,
      "quantity": 1,
      "description": "Annual Membership"
    }
  ]
}
```

### Response (relevant fields)

```json
{
  "id": 123456789,
  "code": "a1B5f00000XYZ",
  "status": "Saved",
  "totalAmount": 500.00,
  "totalTax": 41.25,
  "totalTaxCalculated": 41.25,
  "lines": [
    {
      "lineNumber": "1",
      "tax": 41.25,
      "taxableAmount": 500.00,
      "taxCalculated": 41.25,
      "itemCode": "ANNUAL-MEMBERSHIP",
      "isItemTaxable": true,
      "details": [
        {
          "taxName": "IL STATE TAX",
          "rate": 0.0625,
          "tax": 31.25,
          "taxableAmount": 500.00
        },
        {
          "taxName": "COOK COUNTY TAX",
          "rate": 0.02,
          "tax": 10.00,
          "taxableAmount": 500.00
        }
      ]
    }
  ]
}
```

### Other endpoints needed

| Endpoint | When |
|----------|------|
| `POST /api/v2/transactions/create` | Calculate tax |
| `POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/commit` | Commit (make reportable) |
| `POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/void` | Void cancelled orders |
| `GET /api/v2/companies/{companyId}/items?$top=1000&$skip=0` | Sync product items (SOA already does this) |

---

## 5. Fonteva Object Mapping

| Avalara Concept | Fonteva Object | Key Fields |
|-----------------|---------------|------------|
| Transaction (header) | `OrderApi__Sales_Order__c` | Account, addresses, status, total tax |
| Transaction line | `OrderApi__Sales_Order_Line__c` | Item, quantity, price, line tax |
| Product/Item | `OrderApi__Item__c` | Name, tax code, taxable flag |
| Customer | `Account` | Name, shipping/billing address |
| Tax result (header) | `OrderApi__Sales_Order__c` | Tax amount field |
| Tax result (line) | `OrderApi__Sales_Order_Line__c` | Tax amount field |

**Note**: Exact field API names on `OrderApi__Sales_Order__c` and `OrderApi__Sales_Order_Line__c` need to be confirmed by inspecting the TCH org schema. The fields above are Fonteva standard -- TCH may have custom tax fields added.

---

## 6. Components to Build

See next section for detailed breakdown.
