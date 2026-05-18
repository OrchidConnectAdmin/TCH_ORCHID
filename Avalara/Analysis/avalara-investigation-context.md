# Avalara Tax Integration - Investigation Context

## Task
- **Ticket**: [26657020] Avalara Taxes
- **Project**: TCH (The Clearing House Payments Company L.L.C.)
- **Assigned to**: Matheus A. | **Assigned by**: Nolan Burke
- **Company**: Orchid Suites

## Objective
Integrate Avalara AvaTax with Salesforce/Fonteva for sales tax calculation on TCH org.

## Current Blocker
- Avalara sandbox (Account ID: 2000002768) only has **API** as available integration
- Cannot install Salesforce connector — user lacks admin permissions:
  > "Contact Avalara Support to add an integration. Your current access rights prevent you from adding one."
- Tanya Renne requested admin access (Apr 30, 2026) — no update yet
- Opening Avalara support ticket requires production access (not available)

## Two Integration Options from Nolan's Dev Plan

### Option 1: Avalara Connector (LOE: ~50h) — BLOCKED
- Install Salesforce connector from Avalara Portal (Integration Tab)
- Perform initial sync (may need SF Product records mimicking Fonteva Items)
- Install Avalara Mapper
- Add Fonteva objects/products/shopping cart to Avalara Mapper Static Resource XML
- Verify integration/calculation works
- **Guide attached**: "Avalara AvaTax Mapper-Guide for Extending Avalara AvaTax for Salesforce v1.92.pdf"

### Option 2: API Direct / SOA Pattern (LOE: ~60h) — AVAILABLE NOW
- Copy integration pattern used by **SOA Tax Manager** (Society of Actuaries)
- Use **Avalara Tax API** (AvaTax REST API) to send transaction details
- Get the tax calculation response
- Create **Fonteva Adjustment Tax Item** records in Salesforce
- **Tax Exemption Certificates**:
  - If Avalara doesn't provide LWC, create custom ones
  - LWC button to redirect to Avalara guest portal (user creation for tracking)
  - LWC to visualize user exempt certificates (redirect to User certificate page)

## What to Investigate in SOA Org (SOA_ENG5)
1. **Apex classes** related to Avalara/AvaTax/Tax — look for the integration pattern
2. **Named Credentials** — how SOA connects to Avalara API
3. **Static Resources** — Avalara Mapper XML configuration
4. **Custom Metadata / Custom Settings** — tax configuration
5. **Fonteva Adjustment Tax Item** — how tax records are created
6. **LWC components** — any tax exemption certificate UIs
7. **Trigger/handler** — where tax calculation is invoked in the order/checkout flow

## SOA Reference
- SOA already has connector **"Salesforce B2B & D2C Commerce Lightning" v10.2.0** installed
- Avalara Account: Society of Actuaries (Account ID: 2006505273)
- SOA_ENG5 org: `societyofacturies--eng5.sandbox.my.salesforce.com`
- Username: `matheus@orchidconnect.com.soa.eng5`

## Key Questions to Answer
1. Does SOA use the Avalara managed package OR custom Apex callouts to the AvaTax API?
2. If managed package — which classes/triggers does it use?
3. If custom Apex — what are the service classes, request/response wrappers, and Named Credentials?
4. How is the tax calculation triggered (checkout flow, trigger, scheduled)?
5. How are Fonteva Tax Item records created from the Avalara response?
6. Is there any Tax Exemption Certificate functionality implemented?

## Next Steps
- [ ] Query SOA_ENG5 for Apex classes matching Avalara/AvaTax/Tax patterns
- [ ] Examine Named Credentials and Remote Site Settings
- [ ] Read the integration code to understand the flow
- [ ] Determine what can be reused/adapted for TCH
- [ ] Decide: reuse SOA managed package approach OR build custom API integration
