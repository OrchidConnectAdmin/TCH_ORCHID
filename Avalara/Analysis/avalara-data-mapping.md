# Avalara AvaTax: Data Mapping (TCH)

> Last updated: 2026-05-25
> Branch: `feature/26657020`

Field-level mapping between Fonteva/Salesforce objects and Avalara AvaTax REST API v2 request/response models.

---

## 1. Tax Calculation: `CreateTransaction`

**API Method:** `CreateTransaction`
**Endpoint:** `POST /api/v2/transactions/create`
**Apex Service:** `AvalaraCreateTransactionService` > `AvalaraCreateTransactionTransformer` > `AvalaraCreateTransaction` (DTO)
**Business Orchestrator:** `AvalaraTaxCalculationService.calculateTax()` (SalesOrder) / `.commitTax()` (SalesInvoice)

**Document Types:**
- `SalesOrder`: temporary estimate (not saved in Avalara). Used at checkout.
- `SalesInvoice`: permanent record (saved in Avalara). Used post-payment with `commit=true`.

### 1.1 Request: Transaction Header (`CreateTransactionModel`)

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `companyCode` | String | Yes | `Avalara_Config__mdt.Company_Code__c` | Stored in Custom Metadata: same for all transactions |
| `type` | Enum | Yes | Derived from checkout stage | `SalesOrder` for estimates, `SalesInvoice` after payment |
| `date` | DateTime | Yes | `OrderApi__Sales_Order__c.OrderApi__Date__c` | Falls back to `CreatedDate` or `System.today()` |
| `customerCode` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Contact__c` | Contact ID as customer identifier. Uses Account ID if `Entity__c = 'Account'` |
| `currencyCode` | String | No | `'USD'` | Hardcoded (TCH single currency) |
| `commit` | Boolean | No | Derived from checkout stage | `false` for SalesOrder, `true` for SalesInvoice |
| `referenceCode` | String | No | `OrderApi__Sales_Order__c.Id` | Salesforce record ID for traceability |

### 1.2 Request: Ship-To Address (`addresses.shipTo`)

The customer's address: determines the **destination jurisdiction** for tax calculation.

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `line1` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_Street__c` | Customer billing address |
| `city` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_City__c` | |
| `region` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_State__c` | US state code (e.g., `NY`, `CA`) |
| `postalCode` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_Postal_Code__c` | |
| `country` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_Country__c` | ISO 2-char. Default to `US` if blank |

### 1.3 Request: Ship-From Address (`addresses.shipFrom`)

TCH's business address: determines the **origin jurisdiction**. Stored in Custom Metadata.

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `line1` | String | Yes | `Avalara_Config__mdt.ShipFrom_Street__c` | `1114 Avenue of The Americas, 17th Floor` |
| `city` | String | Yes | `Avalara_Config__mdt.ShipFrom_City__c` | `New York` |
| `region` | String | Yes | `Avalara_Config__mdt.ShipFrom_State__c` | `NY` |
| `postalCode` | String | Yes | `Avalara_Config__mdt.ShipFrom_PostalCode__c` | `10036` |
| `country` | String | Yes | `Avalara_Config__mdt.ShipFrom_Country__c` | `US` |

### 1.4 Request: Line Items (`lines[]`)

Each `OrderApi__Sales_Order_Line__c` where `Is_Tax__c = false AND Is_Shipping_Rate__c = false` becomes one Avalara line.

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `number` | String | No | `OrderApi__Sales_Order_Line__c.Id` | Unique line identifier (matching key for response) |
| `quantity` | Decimal | Yes | `OrderApi__Sales_Order_Line__c.OrderApi__Quantity__c` | |
| `amount` | Decimal | Yes | `OrderApi__Sales_Order_Line__c.OrderApi__Sale_Price__c * OrderApi__Quantity__c` | Line total before tax |
| `itemCode` | String | No | `OrderApi__Sales_Order_Line__c.OrderApi__Item__r.Name` | For Avalara portal reporting |
| `taxCode` | String | No | `OrderApi__Sales_Order_Line__c.OrderApi__Item__r.Avalara_Tax_Code__c` | Falls back to `Avalara_Config__mdt.Default_Tax_Code__c` or `P0000000` |
| `description` | String | No | `OrderApi__Sales_Order_Line__c.OrderApi__Item__r.OrderApi__Description__c` | Optional readability |

### 1.5 Response: Transaction Level (`TransactionModel`)

| Avalara Response Field | Type | Target (Fonteva/Salesforce) | Notes |
|------------------------|------|-----------------------------|-------|
| `id` | Long | `OrderApi__Sales_Order__c.Avalara_Transaction_Id__c` | Stored only on SalesInvoice (post-payment commit) |
| `code` | String | `OrderApi__Sales_Order__c.Avalara_Transaction_Code__c` | Stored only on SalesInvoice. Used for commit/void. |
| `status` | String | Not stored | Runtime validation (Saved, Committed, Cancelled) |
| `totalTax` | Decimal | Derived from tax SOLs | Total tax for the entire order |
| `totalTaxable` | Decimal | Not stored | Reference only |
| `totalAmount` | Decimal | Not stored | Reference only |
| `totalExempt` | Decimal | Not stored | Reference only |
| `totalDiscount` | Decimal | Not stored | Reference only |

### 1.6 Response: Line Level

For each Avalara response line, a tax `OrderApi__Sales_Order_Line__c` is created (including $0 lines for audit trail).

| Avalara Response Field | Type | Target (Fonteva/Salesforce) | Notes |
|------------------------|------|-----------------------------|-------|
| `lines[].lineNumber` | String | Matching key to product SOL | Maps to `number` sent in request = product SOL Id |
| `lines[].tax` | Decimal | Tax SOL > `OrderApi__Tax_Amount__c` and `OrderApi__Sale_Price__c` | Tax amount for this line |
| `lines[].rate` | Decimal | Tax SOL > `OrderApi__Tax_Percent__c` | Avalara returns decimal (e.g., `0.0825`): multiply by 100 |
| `lines[].taxableAmount` | Decimal | Not stored | Reference only |
| `lines[].taxCalculated` | Decimal | Not stored | Reference only |
| `lines[].isItemTaxable` | Boolean | Not stored | Reference only |
| `lines[].itemCode` | String | Not stored | Echo of request |
| `lines[].taxCode` | String | Not stored | Resolved tax code |
| `lines[].details[]` | Array | Not stored | Jurisdiction breakdown (jurisName, jurisType, rate, tax, taxableAmount, taxName) |

### 1.7 Tax SOL Creation Pattern

| Tax SOL Field | Value | Source |
|-------|-------|--------|
| `OrderApi__Sales_Order__c` | Parent Sales Order ID | Same as product line |
| `OrderApi__Is_Tax__c` | `true` | Marks as tax line |
| `OrderApi__Tax_Override__c` | `true` | Prevents Fonteva recalculation; cleanup identifier |
| `OrderApi__Tax_Amount__c` | Tax amount | `lines[].tax` from Avalara |
| `OrderApi__Tax_Percent__c` | Tax rate (percent) | `lines[].rate * 100`. Percent(7,4) |
| `OrderApi__Sale_Price__c` | Tax amount | `lines[].tax` from Avalara |
| `OrderApi__Quantity__c` | `1` | One tax SOL per product line |
| `OrderApi__Item__c` | Tax Rate Item ID | `Item__c` with `Is_Tax__c = true` (GL accounting) |
| `OrderApi__Sales_Order_Line__c` | Product line ID | Self-lookup linking tax to product SOL |

> **Downstream propagation**: Invoice Lines, Receipt Lines, ePayment Lines created automatically by the managed package for ALL SOLs. `Sales_Order_Line__c` lookup is "System Calculated".
>
> **Field notes**:
> - `OrderApi__Sales_Order_Line__c` (self-lookup) links tax to product. `OrderApi__Sales_Order_Line_R__c` is for multi-currency: do NOT use.
> - `OrderApi__Item_Tax_Percent__c` is a read-only formula. Do not set directly.

---

## 2. Transaction Commit: `CommitTransaction`

**API Method:** `CommitTransaction`
**Endpoint:** `POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/commit`
**Apex Service:** `AvalaraTransactionStatusService.commitTransaction()`

> **Note**: In the primary flow, commit happens inline via `CreateTransaction` with `type=SalesInvoice` + `commit=true`. This standalone endpoint is auxiliary for edge cases.

### Request

| Avalara Field | Type | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------------------------|-------|
| `companyCode` (URL) | String | `Avalara_Config__mdt.Company_Code__c` | URL path parameter |
| `transactionCode` (URL) | String | `OrderApi__Sales_Order__c.Avalara_Transaction_Code__c` | URL path parameter |
| `commit` (body) | Boolean | `true` | Always `true` |

### Response

No new fields stored. Validates that `status` changed to `Committed`.

---

## 3. Transaction Void: `VoidTransaction`

**API Method:** `VoidTransaction`
**Endpoint:** `POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/void`
**Apex Service:** `AvalaraTransactionStatusService.voidTransaction()`
**Async:** `AvalaraVoidTransactionQueueable` (batch of 25, self-chaining)

### Request

| Avalara Field | Type | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------------------------|-------|
| `companyCode` (URL) | String | `Avalara_Config__mdt.Company_Code__c` | URL path parameter |
| `transactionCode` (URL) | String | `OrderApi__Sales_Order__c.Avalara_Transaction_Code__c` | URL path parameter |
| `code` (body) | Enum | `'DocVoided'` | Only supported value for full cancellation |

### Trigger and Cleanup

| Action | Details |
|--------|---------|
| **Trigger** | TBD: Sales Order status change to `Cancelled` (not yet implemented) |
| **Void** | Call `VoidTransaction` using stored `Avalara_Transaction_Code__c` |
| **Cleanup** | Fonteva native engine handles tax SOL cleanup on cancellation |

---

## 4. Address Validation: `ResolveAddress`

**API Method:** `ResolveAddress`
**Endpoint:** `POST /api/v2/addresses/resolve`
**Apex Service:** `AvalaraResolveAddressService`
**Called by:** `AvalaraTaxCalculationService` (before tax calculation)

### Request

| Avalara Field | Source |
|---------------|--------|
| `line1` | `OrderApi__Sales_Order__c.OrderApi__Billing_Street__c` |
| `city` | `OrderApi__Sales_Order__c.OrderApi__Billing_City__c` |
| `region` | `OrderApi__Sales_Order__c.OrderApi__Billing_State__c` |
| `postalCode` | `OrderApi__Sales_Order__c.OrderApi__Billing_Postal_Code__c` |
| `country` | `OrderApi__Sales_Order__c.OrderApi__Billing_Country__c` |

### Response (`AddressResolutionModel`)

| Avalara Response Field | Usage | Notes |
|------------------------|-------|-------|
| `validatedAddresses[0].line1` | Used as `shipTo.line1` in tax calc | Corrected address |
| `validatedAddresses[0].city` | Used as `shipTo.city` | |
| `validatedAddresses[0].region` | Used as `shipTo.region` | |
| `validatedAddresses[0].postalCode` | Used as `shipTo.postalCode` | |
| `resolutionQuality` | Logged, not stored | Match precision indicator |
| `coordinates.latitude` / `.longitude` | Not used | Available for future use |
| `taxAuthorities[]` | Not used | Jurisdiction info |
| `messages[]` | Logged if severity is error | Validation warnings |

> The validated address is used for the subsequent `CreateTransaction` call but does not overwrite the original address on the Sales Order.

---

## 5. ECM: Customer Registration (`CreateCustomers`)

**API Method:** `CreateCustomers`
**Endpoint:** `POST /api/v2/companies/{companyId}/customers`
**Apex Service:** `AvalaraCreateCustomerService`
**Called by:** `AvalaraTaxExemptionService.registerAndInvite()`

### Request

| Avalara Field | Type | Source | Notes |
|---------------|------|--------|-------|
| `companyId` (URL) | String | `Avalara_Config__mdt.Company_Id__c` | `312140` (sandbox) |
| `customerCode` | String | `Account.Id` | Salesforce Account ID as unique identifier |
| `name` | String | User input (LWC form) | Contact/company name |
| `line1` | String | User-selected address | Street |
| `city` | String | User-selected address | City |
| `region` | String | User-selected address | State code |
| `postalCode` | String | User-selected address | Postal code |
| `country` | String | User-selected address | ISO 2-char |
| `emailAddress` | String | User input | For CertExpress email delivery |

> The API accepts an array; the transformer wraps the single request in `[...]`.

### Response

| Avalara Response Field | Target | Notes |
|------------------------|--------|-------|
| `id` | `Account.Avalara_Customer_Id__c` | Persisted to prevent duplicate registrations |
| `customerCode` | Not stored separately | Echoes the Account ID sent |

---

## 6. ECM: CertExpress Invitation (`CreateCertExpressInvitation`)

**API Method:** `CreateCertExpressInvitation`
**Endpoint:** `POST /api/v2/companies/{companyId}/customers/{customerCode}/certexpressinvites`
**Apex Service:** `AvalaraCertExpressInvitationService`
**Called by:** `AvalaraTaxExemptionService.registerAndInvite()` and `.requestNewExemption()`

### Request

| Avalara Field | Type | Source | Notes |
|---------------|------|--------|-------|
| `companyId` (URL) | String | `Avalara_Config__mdt.Company_Id__c` | Path variable |
| `customerCode` (URL) | String | `Account.Id` | Path variable |
| `recipient` | String | User email | CertExpress link recipient |
| `coverLetterTitle` | String | `'REQUEST'` | Standard invitation |
| `deliveryMethod` | String | `'Download'` | Returns URL directly (no email sent) |

> The API accepts an array; the transformer wraps the single request in `[...]`.

### Response

| Avalara Response Field | Target | Notes |
|------------------------|--------|-------|
| `requestLink` | Returned to LWC as `certExpressUrl` | Portal URL opened in new tab |
| `status` | Not stored | Logged for debugging |
| `id` | Not stored | Invitation ID |

---

## 7. ECM: Certificate Listing (`ListCertificatesForCustomer`)

**API Method:** `ListCertificatesForCustomer`
**Endpoint:** `GET /api/v2/companies/{companyId}/customers/{customerCode}/certificates`
**Apex Service:** `AvalaraListCertificatesService`
**Called by:** `AvalaraTaxExemptionService.getExemptionInfo()` (for registered customers)

### Request (URL Parameters Only)

| Avalara Field | Source | Notes |
|---------------|--------|-------|
| `companyId` (URL) | `Avalara_Config__mdt.Company_Id__c` | Path variable |
| `customerCode` (URL) | `Account.Id` | Path variable |

### Response

| Avalara Response Field | Target | Notes |
|------------------------|--------|-------|
| `@recordsetCount` | Displayed in LWC | Total certificate count |
| `value[].id` | `CertificateInfo.id` | Certificate ID |
| `value[].status` | `CertificateInfo.status` | Complete, Expired, Pending, etc. |
| `value[].signedDate` | `CertificateInfo.signedDate` | Formatted for display |
| `value[].expirationDate` | `CertificateInfo.expirationDate` | Formatted for display |
| `value[].exposureZone.name` | `CertificateInfo.exposureZone` | State/jurisdiction name |
| `value[].exemptionReason.name` | `CertificateInfo.exemptionReason` | Reason description |

---

## 8. Custom Fields Summary

### `OrderApi__Item__c` (Managed Package Object)

| Field API Name | Type | Description | Deployed |
|----------------|------|-------------|----------|
| `Avalara_Tax_Code__c` | Text(25) | Avalara Tax Code (e.g., `P0000000`, `SW054000`, `NT`) | Yes |

### `OrderApi__Sales_Order__c` (Managed Package Object)

| Field API Name | Type | Description | Deployed |
|----------------|------|-------------|----------|
| `Avalara_Transaction_Code__c` | Text(50) | Avalara transaction code for commit/void | Yes |
| `Avalara_Transaction_Id__c` | Text(20) | Avalara numeric transaction ID | Yes |

### `Account` (Standard Object)

| Field API Name | Type | Description | Deployed |
|----------------|------|-------------|----------|
| `Avalara_Customer_Id__c` | Text | Avalara ECM customer ID | Yes |

### `Avalara_Config__mdt` (Custom Metadata Type)

| Field | Type | Description | Deployed |
|-------|------|-------------|----------|
| `Company_Code__c` | Text(25) | Avalara Company Code | Yes |
| `Company_Id__c` | Text(25) | Avalara Company ID (numeric) | Yes |
| `Environment__c` | Picklist | Sandbox / Production | Yes |
| `Is_Active__c` | Checkbox | Active configuration flag | Yes |
| `ShipFrom_Street__c` | Text(255) | TCH business address: street | Yes |
| `ShipFrom_City__c` | Text(100) | City | Yes |
| `ShipFrom_State__c` | Text(2) | State code | Yes |
| `ShipFrom_PostalCode__c` | Text(10) | Postal code | Yes |
| `ShipFrom_Country__c` | Text(2) | Country (ISO 2-char) | Yes |
| `Default_Tax_Code__c` | Text(25) | Fallback tax code | Yes |
| `Tax_Exemption_Page_Path__c` | Text(255) | Community page path for Tax Exemption LWC | Yes |

### `Avalara_Service__mdt` (Custom Metadata Type)

| Field | Type | Description | Deployed |
|-------|------|-------------|----------|
| `HTTP_Method__c` | Text | GET, POST, etc. | Yes |
| `Resource_Path__c` | Text | API path with `{variable}` placeholders | Yes |
| `API_Reference__c` | URL | Link to Avalara docs | Yes |
