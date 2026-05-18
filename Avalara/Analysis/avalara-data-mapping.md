# Avalara AvaTax: Data Mapping (TCH)

Field-level mapping between Fonteva/Salesforce objects and Avalara AvaTax REST API v2 request/response models.

---

## 1. Tax Calculation:[`CreateTransaction`](https://developer.avalara.com/products/avatax/api/methods/Transactions/CreateTransaction/)

**API Method:** `CreateTransaction`
**Endpoint:** `POST /api/v2/transactions/create`
**Purpose:** Calculates sales tax in real time for a Fonteva Sales Order. Sends the order details (customer, addresses, line items) to Avalara and receives the calculated tax per line and total. This is the core API call of the integration:every checkout triggers this.

**Document Types:**
- `SalesOrder`:temporary estimate (not saved in Avalara). Used when the customer is browsing the cart or checkout page.
- `SalesInvoice`:permanent record (saved in Avalara). Used after payment is confirmed. Can be committed and later voided.

**Doc:** https://developer.avalara.com/products/avatax/api/methods/Transactions/CreateTransaction/

### 1.1 Request: Transaction Header (`CreateTransactionModel`)

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `companyCode` | String | Yes | `Avalara_Config__mdt.Company_Code__c` | Stored in Custom Metadata: same for all transactions |
| `type` | Enum | Yes | Derived from checkout stage | `SalesOrder` for estimates, `SalesInvoice` after payment |
| `date` | DateTime | Yes | `OrderApi__Sales_Order__c.OrderApi__Date__c` | Falls back to `CreatedDate` or `System.today()` |
| `customerCode` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Contact__c` | Contact ID as unique customer identifier. If `Entity__c = 'Account'`, use Account ID instead |
| `currencyCode` | String | No | `'USD'` | Hardcoded unless TCH operates in multiple currencies |
| `commit` | Boolean | No | Derived from checkout stage | `false` for estimates, `true` for final payment |
| `customerUsageType` | String | No | Custom field on Account (TBD) | Only if customer has a tax exemption. E.g., `A` = Federal Gov |
| `referenceCode` | String | No | `OrderApi__Sales_Order__c.Id` | Salesforce record ID for traceability |

### 1.2 Request: Ship-To Address (`addresses.shipTo`)

The customer's address:determines the **destination jurisdiction** for tax calculation.

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `line1` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_Street__c` | Customer billing address |
| `city` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_City__c` | |
| `region` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_State__c` | US state code (e.g., `NY`, `CA`) |
| `postalCode` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_Postal_Code__c` | |
| `country` | String | Yes | `OrderApi__Sales_Order__c.OrderApi__Billing_Country__c` | ISO 2-char (e.g., `US`). Default to `US` if blank |

> **Note:** Fonteva Sales Order also has Shipping address fields (`Shipping_Street__c`, `Shipping_City__c`, etc.). If TCH ships physical goods, use Shipping address instead of Billing. To be confirmed.

### 1.3 Request: Ship-From Address (`addresses.shipFrom`)

TCH's business address:determines the **origin jurisdiction**. Tax rates in some states depend on the combination of origin + destination.

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `line1` | String | Yes | `Avalara_Config__mdt.ShipFrom_Street__c` | TCH headquarters address: stored in Custom Metadata |
| `city` | String | Yes | `Avalara_Config__mdt.ShipFrom_City__c` | |
| `region` | String | Yes | `Avalara_Config__mdt.ShipFrom_State__c` | |
| `postalCode` | String | Yes | `Avalara_Config__mdt.ShipFrom_PostalCode__c` | |
| `country` | String | Yes | `Avalara_Config__mdt.ShipFrom_Country__c` | Default `US` |

> **Pending:** TCH business address not yet confirmed. See TeamWork comment.

### 1.4 Request: Line Items (`lines[]`)

Each product line in the Fonteva Sales Order becomes one line in the Avalara request. The `taxCode` tells Avalara how to classify the product for tax purposes.

Each `OrderApi__Sales_Order_Line__c` where `OrderApi__Is_Tax__c = false` becomes one Avalara line.

| Avalara Field | Type | Required | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------|----------------------------|-------|
| `number` | String | No | `OrderApi__Sales_Order_Line__c.Id` | Unique line identifier |
| `quantity` | Decimal | Yes | `OrderApi__Sales_Order_Line__c.OrderApi__Quantity__c` | |
| `amount` | Decimal | Yes | `OrderApi__Sales_Order_Line__c.OrderApi__Sale_Price__c * OrderApi__Quantity__c` | Or use `OrderApi__Total__c` if it represents line total before tax |
| `itemCode` | String | No | `OrderApi__Sales_Order_Line__c.OrderApi__Item__r.Name` | Fonteva Item name: for reporting in Avalara portal |
| `taxCode` | String | No | `OrderApi__Sales_Order_Line__c.OrderApi__Item__r.Avalara_Tax_Code__c` | **New field** to be created. Falls back to `P0000000` if blank |
| `description` | String | No | `OrderApi__Sales_Order_Line__c.OrderApi__Item__r.OrderApi__Description__c` | Optional: for readability in Avalara |

> **Filter:** Exclude lines where `OrderApi__Is_Tax__c = true` (these are Fonteva's native tax lines, not product lines).

### 1.5 Response: Transaction Level (`TransactionModel`)

Returned by Avalara after tax calculation. Contains the total tax and metadata needed for commit/void operations.

| Avalara Response Field | Target (Fonteva/Salesforce) | Notes |
|------------------------|-----------------------------|-------|
| `totalTax` | `OrderApi__Sales_Order__c`: custom field (TBD) or derived from line-level tax lines | Total tax for the entire order |
| `code` | `OrderApi__Sales_Order__c.Avalara_Transaction_Code__c` | **New field**: stores Avalara transaction code for commit/void operations |
| `id` | `OrderApi__Sales_Order__c.Avalara_Transaction_Id__c` | **New field** (optional): Avalara numeric ID |
| `status` | Not stored | Used for runtime validation only (Saved, Committed, Cancelled) |

### 1.6 Response: Line Level

For each Avalara response line with `tax > 0`, create a tax `OrderApi__Sales_Order_Line__c`.

| Avalara Response Field | Target (Fonteva/Salesforce) | Notes |
|------------------------|-----------------------------|-------|
| `lines[].tax` | New tax SOL → `OrderApi__Tax_Amount__c` and `OrderApi__Sale_Price__c` | Tax amount for this line |
| `lines[].rate` | Tax SOL → `OrderApi__Tax_Percent__c` | Avalara returns decimal (e.g., `0.0825`): multiply by 100 to store as Percent(7,4) |
| `lines[].taxableAmount` | Not stored | Reference only. No `OrderApi__Total_With_Tax__c` field exists |
| `lines[].lineNumber` | Used to match response line to the product `Sales_Order_Line__c.Id` | Matching key: `number` in the request = product SOL Id |

### 1.7 Response: Tax Line Creation Pattern

The Spark Plug deletes any existing Avalara tax SOLs (`Is_Tax__c = true AND Tax_Override__c = true`) and creates fresh ones from the response:

| Field | Value | Source |
|-------|-------|--------|
| `OrderApi__Sales_Order__c` | Parent Sales Order ID | Same as product line |
| `OrderApi__Is_Tax__c` | `true` | Marks this as a tax line |
| `OrderApi__Tax_Override__c` | `true` | Prevents Fonteva from recalculating |
| `OrderApi__Tax_Amount__c` | Tax amount | `lines[].tax` from Avalara response |
| `OrderApi__Tax_Percent__c` | Tax rate (as percent) | `lines[].rate * 100`. Percent(7,4) |
| `OrderApi__Sale_Price__c` | Tax amount | `lines[].tax` from Avalara response |
| `OrderApi__Quantity__c` | `1` | One tax SOL per taxable product line |
| `OrderApi__Item__c` | Tax Rate Item ID | Single `Item__c` with `Is_Tax__c = true` (for GL accounting) |
| `OrderApi__Sales_Order_Line__c` | Parent product line ID | Self-lookup linking tax SOL to its product SOL |

> **Downstream propagation**: Invoice Lines, Receipt Lines, and ePayment Lines are created automatically by the managed package when the Sales Order is processed. The `Sales_Order_Line__c` lookup on these objects is "System Calculated" — populated for ALL SOLs regardless of how they were created.
>
> **Field notes**:
> - `OrderApi__Sales_Order_Line__c` (self-lookup) links tax to product. `OrderApi__Sales_Order_Line_R__c` is for multi-currency reporting — do NOT use.
> - `OrderApi__Item_Tax_Percent__c` is a read-only formula. Do not set directly.

---

## 2. Transaction Commit:[`CommitTransaction`](https://developer.avalara.com/products/avatax/api/methods/Transactions/CommitTransaction/)

**API Method:** `CommitTransaction`
**Endpoint:** `POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/commit`
**Purpose:** Marks a `SalesInvoice` transaction as final in Avalara. Committed transactions are included in Avalara's tax filing/returns. Called after payment is confirmed in Fonteva. Can be skipped if `commit: true` is set in the `CreateTransaction` request.

**Doc:** https://developer.avalara.com/products/avatax/api/methods/Transactions/CommitTransaction/

### Request

| Avalara Field | Type | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------------------------|-------|
| `companyCode` (URL) | String | `Avalara_Config__mdt.Company_Code__c` | URL path parameter |
| `transactionCode` (URL) | String | `OrderApi__Sales_Order__c.Avalara_Transaction_Code__c` | URL path parameter:stored from CreateTransaction response |
| `commit` (body) | Boolean | `true` | Always `true` |

### Response

No new fields to store. Validates that `status` changed to `Committed`.

---

## 3. Transaction Void:[`VoidTransaction`](https://developer.avalara.com/products/avatax/api/methods/Transactions/VoidTransaction/)

**API Method:** `VoidTransaction`
**Endpoint:** `POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/void`
**Purpose:** Cancels a previously committed transaction. The transaction remains in Avalara's records but is excluded from tax filing. Used when a Fonteva Sales Order is cancelled or fully refunded.

**Doc:** https://developer.avalara.com/products/avatax/api/methods/Transactions/VoidTransaction/

### Request

| Avalara Field | Type | Source (Fonteva/Salesforce) | Notes |
|---------------|------|----------------------------|-------|
| `companyCode` (URL) | String | `Avalara_Config__mdt.Company_Code__c` | URL path parameter |
| `transactionCode` (URL) | String | `OrderApi__Sales_Order__c.Avalara_Transaction_Code__c` | URL path parameter |
| `code` (body) | Enum | `'DocVoided'` | Only supported value for full cancellation |

### Trigger & Cleanup

| Action | Details |
|--------|---------|
| **Trigger** | `OrderApi__Sales_Order__c.OrderApi__Status__c` changes to `Cancelled` |
| **Void** | Call `VoidTransaction` using the stored `Avalara_Transaction_Code__c` |
| **Cleanup** | Delete or deactivate Fonteva tax lines (`Is_Tax__c = true`) for that Sales Order |

---

## 4. Address Validation:[`ResolveAddress`](https://developer.avalara.com/products/avatax/api/methods/Addresses/ResolveAddress/) (Optional)

**API Method:** `ResolveAddress`
**Endpoint:** `POST /api/v2/addresses/resolve`
**Purpose:** Validates and normalizes a US/Canadian address. Returns the corrected address with latitude/longitude. Ensures the ShipTo address maps to the correct tax jurisdiction before calling `CreateTransaction`. An incorrect address can result in tax calculated for the wrong state/county/city.

**When to use:** Controlled by `Avalara_Config__mdt.Enable_Address_Validation__c`. Can be called on every checkout or once when the address is first saved.

**Doc:** https://developer.avalara.com/products/avatax/api/methods/Addresses/ResolveAddress/

### Request: Fonteva → `ResolveAddress`

| Avalara Field | Source |
|---------------|--------|
| `line1` | `OrderApi__Sales_Order__c.OrderApi__Billing_Street__c` |
| `city` | `OrderApi__Sales_Order__c.OrderApi__Billing_City__c` |
| `region` | `OrderApi__Sales_Order__c.OrderApi__Billing_State__c` |
| `postalCode` | `OrderApi__Sales_Order__c.OrderApi__Billing_Postal_Code__c` |
| `country` | `OrderApi__Sales_Order__c.OrderApi__Billing_Country__c` |

### Response: `AddressResolutionModel` → Fonteva

| Avalara Response Field | Target |
|------------------------|--------|
| `validatedAddresses[0].line1` | `OrderApi__Sales_Order__c.OrderApi__Billing_Street__c` |
| `validatedAddresses[0].city` | `OrderApi__Sales_Order__c.OrderApi__Billing_City__c` |
| `validatedAddresses[0].region` | `OrderApi__Sales_Order__c.OrderApi__Billing_State__c` |
| `validatedAddresses[0].postalCode` | `OrderApi__Sales_Order__c.OrderApi__Billing_Postal_Code__c` |

> **Decision needed:** Should the validated address overwrite the original, or be stored separately?

---

## 5. New Fields Required

### On `OrderApi__Item__c`

| Field API Name | Type | Description |
|----------------|------|-------------|
| `Avalara_Tax_Code__c` | Text(25) | Avalara Tax Code for this item (e.g., `P0000000`, `SW054000`, `NT`). Used in `CreateTransaction` request. |

### On `OrderApi__Sales_Order__c`

| Field API Name | Type | Description |
|----------------|------|-------------|
| `Avalara_Transaction_Code__c` | Text(50) | Avalara transaction code returned by `CreateTransaction`. Needed for `CommitTransaction` and `VoidTransaction`. |
| `Avalara_Transaction_Id__c` | Text(20) | Avalara numeric transaction ID (optional: for portal reference). |

### Custom Metadata: `Avalara_Config__mdt`

| Field | Type | Description |
|-------|------|-------------|
| `Company_Code__c` | Text(25) | Avalara Company Code |
| `Environment__c` | Picklist | `Sandbox` / `Production` |
| `ShipFrom_Street__c` | Text(255) | TCH business address: street |
| `ShipFrom_City__c` | Text(100) | TCH business address: city |
| `ShipFrom_State__c` | Text(2) | TCH business address: state |
| `ShipFrom_PostalCode__c` | Text(10) | TCH business address: postal code |
| `ShipFrom_Country__c` | Text(2) | TCH business address: country (default `US`) |
| `Auto_Commit__c` | Checkbox | If true, SalesInvoice transactions are auto-committed |
| `Enable_Address_Validation__c` | Checkbox | If true, validates ShipTo address before tax calculation |
