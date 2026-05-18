# Avalara AvaTax Integration: Overview & LOE

**Approach**: Direct REST API integration with Avalara AvaTax v2. A Spark Plug component at checkout calls Avalara, gets jurisdiction-accurate tax per item, and creates tax lines on the Sales Order. The customer sees the tax before confirming payment. Post-payment, the transaction is committed to Avalara for tax filing/reporting.

Fonteva is the product master — tax codes are stored on each Item and sent in the API request. Avalara is the tax calculation engine — it applies jurisdiction rules, nexus, and rates. No native Fonteva tax configuration (Tax Class, Tax Locale, Tax Rate) is needed, avoiding duplication of logic across two systems.

---

## Phase 1: Core Tax Integration (~40h)

| Module | What |
|--------|------|
| Setup & Config | Deploy custom fields (`Avalara_Tax_Code__c` on Item, `Avalara_Transaction_Code__c` and `Avalara_Transaction_Id__c` on Sales Order), create `Avalara_Config__mdt` (company code, environment, ShipFrom address, feature flags), create Tax Rate Item for GL accounting, Named Credential |
| Tax Code Data Load | Populate `Avalara_Tax_Code__c` on all Fonteva Items with appropriate Avalara tax codes (default `P0000000`, reclassified per product type after TCH review) |
| Foundation | Auth provider, HTTP client |
| Address Validation | Optional pre-validation of customer address before tax calculation (configurable on/off) |
| Tax Calculation | `CreateTransaction` (estimate at checkout + final after payment), `CommitTransaction`, `VoidTransaction` on cancellation |
| Checkout Integration | Aura Spark Plug at `LTE__Load_Checkout` + Apex controller that queries cart, calls Avalara, creates tax Sales Order Lines |
| Testing | Unit tests with HttpCalloutMock, integration tests |

## Phase 2: Tax Exemption Certificates (~20h)

| Module | What |
|--------|------|
| ECM Integration | Customer creation in Avalara ECM, certificate query, CertExpress invite generation |
| LWC Components | CertExpress redirect button + certificate viewer on Account/Contact |

---

## Defaults (development proceeds, TCH reviews before go-live)

| Item | What we use | TCH review |
|------|-------------|------------|
| ShipFrom address | Configurable in Custom Metadata, pending confirmation | Confirm exact address |
| Tax codes | `P0000000` (general taxable) for all products | Reclassify by product type (SaaS, services, memberships, events) |
| Non-taxable products | All items sent to Avalara, Avalara determines taxability | Review which products need specific tax codes |
| GL Account | Existing `2300 - Taxes Payable (Placeholder)` | Finance confirms or provides real account |
