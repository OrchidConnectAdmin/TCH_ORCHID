# Avalara AvaTax Integration: Test Script

## Prerequisites

### Test User

The test user used during development is **Tanya Test**:
- Contact: [003Vy00000D8gXGIAZ](https://cha--tchfull.sandbox.lightning.force.com/lightning/r/Contact/003Vy00000D8gXGIAZ/view)
- Community access: from this Contact's record in Salesforce, use **"Log in as"** (no community password needed) — see Navigation Basics → **N1**
- Portal URL: `https://cha--tchfull.sandbox.my.site.com/LightningMemberPortal`

You may use any community user whose Contact has a mailing address in a **nexus state** (see below).

### Nexus States (where tax WILL be calculated)

TCH has tax nexus in 7 US states. Only orders shipped to these states will have tax > $0.

| State | Example City | Tax? |
|-------|-------------|------|
| DC (District of Columbia) | Washington | Yes |
| IL (Illinois) | Chicago | Yes |
| MI (Michigan) | Detroit | Yes |
| NC (North Carolina) | Charlotte | Yes |
| NY (New York) | New York | Yes |
| OH (Ohio) | Columbus | Yes |
| TX (Texas) | Houston | Yes (state + local) |

Orders shipped to any other state (e.g., California, Florida) will have **$0.00 tax** because TCH has no nexus there.

### Products Available for Testing

Only products whose `Avalara_Tax__c` lookup is populated will trigger tax calculation. `Avalara_Tax__c` points to a **Tax Item** (another `OrderApi__Item__c` record, e.g. *"Tax: Tangible Personal Property"*) that carries the `Avalara_Tax_Code__c` text (e.g. `P0000000`). Products with no `Avalara_Tax__c` value are **not** configured and will always show $0.00 tax regardless of address. Verify the current configuration in the Developer Console:

```sql
SELECT Id, Name, Avalara_Tax__c, Avalara_Tax__r.Name, Avalara_Tax__r.Avalara_Tax_Code__c
FROM OrderApi__Item__c
WHERE Avalara_Tax__c != NULL
ORDER BY Avalara_Tax__r.Avalara_Tax_Code__c, Name
```

#### Currently Configured Tax Codes (TCH Sandbox)

As of the latest TCH Sandbox check, **115 products** are configured across **11 sellable tax codes** (plus one internal *Discount* item). Only the codes and products below are configured — **anything not listed here is not set up for tax** and will never be taxed.

| Tax Code | Tax Item (Name) | Products | Tested E2E | Example product |
|----------|-----------------|---------:|:----------:|-----------------|
| P0000000 | Tangible Personal Property | 6 | ✅ Yes | NCP Power Bank |
| ST087640 | Pre-recorded Training | 34 | ✅ Yes | Recording: UCC Basics |
| OA020500 | Admissions / Events | 29 | ⬜ Not yet | Day 1 Participation |
| OD020500 | Membership Dues | 16 | ⬜ Not yet | ECCHO - Full Member Dues |
| ST080010 | Online Skill Assessments | 9 | ⬜ Not yet | NCP Exam 2025 |
| SF096370 | Catering Services | 8 | ⬜ Not yet | (A) ECCHO Reception |
| SA030000 | Advertising Services | 5 | ⬜ Not yet | NCP Partnership - Gold Level |
| PB100000 | Books / Manuals | 2 | ⬜ Not yet | ECCHO Rules Book - Printed Advertisement |
| ST080000 | Training and Seminar | 2 | ⬜ Not yet | 5 for 4 NCP Workshop Bundle |
| ST087650 | Training Subscription | 2 | ⬜ Not yet | Individual Education Subscription |
| PC040100 | Clothing | 1 | ⬜ Not yet | NCP Golf Hat |
| OD010000 | Discounts | 1 | — | *Discount* (internal adjustment item — not a storefront product) |

> **Confirmed working:** the **P0000000** and **ST087640** products were tested end-to-end with ShipFrom = TCH headquarters (1114 Avenue of The Americas, 17th Floor, New York, NY 10036) and ShipTo = `351 Fifth Avenue, New York, NY, 10118, United States` using the test user "Tanya Test". For the remaining codes the mapping is configured but the end-to-end checkout has not been exercised yet.

> **Do not test tax against unlisted products.** Products outside the codes above have no `Avalara_Tax__c` mapping and will always return $0.00 — a $0 result there is expected, not a bug.

---

## Navigation Basics

These are general "how to get there" steps referenced throughout the test cases below (as **N1**–**N9**). If you already know your way around the portal and Salesforce, skip ahead to **Test Cases**. Exact button labels may differ slightly by environment — look for the closest match.

### N1. Log in to the member portal
1. In Salesforce, open the **Contact** record for the test user (e.g., "Tanya Test"; the Contact is linked at the top of this document — see **N6**).
2. On the Contact record, select **"Log in as"** (the *"Log in to Experience as User"* action). If it isn't a visible button, open the actions dropdown ("▾" / **"Show more actions"**, see **N8**).
3. A new session opens in the member portal as that user, with the top navigation bar. *(No community password needed — this requires Salesforce admin/staff access.)*

### N2. Reach the ECCHO Store and add a product to the cart
1. In the top navigation bar click **"ECCHO Store"** (or go directly to `https://cha--tchfull.sandbox.my.site.com/LightningMemberPortal/s/store`).
2. Click a product to open it, then click **"Add to Cart"**.
3. Open the **cart** (the cart/bag icon, usually top-right) to review your items.
4. Click **"Checkout"** / **"Proceed to Checkout"** to start the checkout flow.

### N3. The Tax Review screen
The custom **"Tax Review"** card appears automatically during checkout, before the Fonteva payment page. If your cart has no taxable products — or your organization is Tax Exempt — this step is skipped and you go straight to payment.

### N4. Open the profile menu
Click your **name or avatar** in the top-right corner of the portal. The dropdown contains your profile links.

### N5. Open the Developer Console and run a SOQL query
1. In Salesforce (Lightning), click the **gear icon** (Setup) at the top-right, then **"Developer Console"** (it opens in a new window).
2. In Developer Console, open the **"Query Editor"** tab along the bottom.
3. Paste a SOQL query and click **"Execute"**; results appear in the grid. *(Any SOQL tool — e.g. Workbench — works just as well.)*

### N6. Open a Salesforce record
- **By Id:** paste into the URL `https://cha--tchfull.sandbox.lightning.force.com/lightning/r/<OBJECT>/<RECORD_ID>/view` (`<OBJECT>` is the API name, e.g. `Account`, `Contact`, `OrderApi__Sales_Order__c`) — **or**
- **By search:** use the global **search bar** at the top, or the **App Launcher** (grid icon, top-left) → choose the object (e.g., Accounts, Sales Orders) → open the record.

### N7. Edit a field on a record
On the record's **Details** tab, click the **pencil icon** next to the field (or the **Edit** button), change the value, then **Save**. If a field is missing or read-only, you are likely lacking Field-Level Security / the required permission set.

### N8. Run a Quick Action on a record
Quick Actions appear as **buttons in the highlights panel** at the top of the record. If you don't see the one you need, click the **dropdown arrow (▾)** / **"Show more actions"** to reveal the full list.

### N9. Log in to the Avalara portal and find a transaction
1. Open `https://sandbox.admin.avalara.com` and log in with the TCH Avalara **sandbox** credentials.
2. In the left-hand menu click **"Transactions"**.
3. Filter by **Date** (today) and **Company** (TCHPC, if shown), or paste a value into the **"Doc Code"** search box.
4. Click a transaction row to open its details.

### N10. Complete payment on the Fonteva payment page
After the Tax Review step, the Fonteva **payment page** loads. Enter the test payment details (or select the sandbox/test payment method configured in the org), then click the **confirm/pay** button. The **Payment Confirmation** page ("Payment Successful") then appears.

---

## Test Cases

### TC-01: Checkout with Tax Calculation (Happy Path)

**Objective:** Verify that Avalara calculates and displays tax during checkout.

**What you will see:** A "Tax Review" card appears during checkout showing your items and shipping address. After you click "Continue", the system validates your address with Avalara and calculates tax. The checkout page then shows Subtotal + Tax + Total.

**Steps:**

1. **Log in** to the member portal as the test user — from the Contact record in Salesforce, use **"Log in as"** (see Navigation Basics → **N1**)

2. **Go to the ECCHO Store** by clicking "ECCHO Store" in the top navigation bar, or go directly to:
   `https://cha--tchfull.sandbox.my.site.com/LightningMemberPortal/s/store`

3. **Find a taxable product.** Look for one of the confirmed products:
   - "NCP Power Bank" or "NCP Mouse Pad" (tax code P0000000), OR
   - Any "Recording:" product (tax code ST087640)

4. **Add the product to your cart and proceed to checkout** (see Navigation Basics → **N2**): click **"Add to Cart"**, open the **cart** (top-right), then click **"Checkout"**.

5. **The Tax Review screen appears.** You should see:
   - A card titled **"Tax Review"** with a cart icon
   - A table showing your items (name, quantity, total)
   - Your current shipping address displayed below the table
   - Two buttons: **"Continue"** and **"Edit Address"**

6. **Check the shipping address.** It should be in a nexus state (NY, TX, DC, IL, MI, NC, OH). If it's not:
   - Click "Edit Address" and enter one of the test addresses listed at the end of this document

7. **Click "Continue."** You should see:
   - A spinner with the message **"Calculating Tax"** and "Validating your address and calculating applicable taxes..."
   - After a few seconds, the Fonteva checkout page loads with tax applied

8. **Verify the checkout shows tax.** The checkout should display:
   - **Subtotal:** the product price
   - **Tax:** a dollar amount greater than $0.00
   - **Total:** Subtotal + Tax

**Pass Criteria:**
- [ ] Tax Review card appears with items table and shipping address
- [ ] "Calculating Tax" spinner shows briefly
- [ ] Checkout displays tax amount > $0.00 (for nexus state addresses)
- [ ] Total = Subtotal + Tax

---

### TC-02: Edit Address During Checkout

**Objective:** Verify that the user can change their shipping address and that the "Use this address for future purchases" checkbox works correctly.

**Background: Where is the address saved?**

When the user edits the address during checkout, the address is **always** saved on the Sales Order (used for this specific order's tax calculation). The checkbox controls whether it's **also** saved to the user's profile for future orders:

| Checkbox | Sales Order (`OrderApi__Sales_Order__c`) | Contact or Account |
|----------|------------------------------------------|-------------------|
| **Unchecked** (default) | Updated: `OrderApi__Shipping_Street__c`, `OrderApi__Shipping_City__c`, `OrderApi__Shipping_State__c`, `OrderApi__Shipping_Postal_Code__c`, `OrderApi__Shipping_Country__c` | NOT updated (original address preserved) |
| **Checked** | Updated (same fields as above) | ALSO updated: `Contact.MailingStreet`, `MailingCity`, `MailingState`, `MailingPostalCode`, `MailingCountry` (or `Account.ShippingStreet`, etc. if entity is Account) |

#### Scenario A: Edit address WITHOUT "Use this address for future purchases" (default)

**Steps:**

1. Reach the Tax Review screen (steps 1-5 from TC-01)

2. **Click "Edit Address."** You should see:
   - A form with fields: Street, City, State, Postal Code, Country
   - A checkbox: **"Use this address for future purchases"** (unchecked by default)
   - A tooltip/help text explaining: "If checked, this address will be saved to your profile and used for this and all future orders. If unchecked, the change applies only to this order."
   - Two buttons: **"Save & Continue"** and **"Back"**

3. **Enter a new address** in a different nexus state:
   - Street: `100 Congress Ave`
   - City: `Austin`
   - State: `Texas`
   - Postal Code: `78701`
   - Country: `United States`

4. **Leave the checkbox UNCHECKED** (this is the default)

5. **Click "Save & Continue."** Tax will recalculate using the new address.

**Verification:**
```sql
-- Sales Order should have the new address
SELECT OrderApi__Shipping_Street__c, OrderApi__Shipping_City__c,
       OrderApi__Shipping_State__c, OrderApi__Shipping_Postal_Code__c
FROM OrderApi__Sales_Order__c WHERE Id = '<SO_ID>'

-- Contact should still have the ORIGINAL address (unchanged)
SELECT MailingStreet, MailingCity, MailingState, MailingPostalCode
FROM Contact WHERE Id = '<CONTACT_ID>'
```

**Pass Criteria:**
- [ ] Sales Order shipping address is updated to the new address
- [ ] Contact mailing address is **NOT** changed (still has the original address)
- [ ] Tax recalculates using the new address (Texas rate instead of NY rate)

#### Scenario B: Edit address WITH "Use this address for future purchases"

**Steps:**

1. Reach the Tax Review screen (steps 1-5 from TC-01)

2. **Click "Edit Address"**

3. **Enter a new address:**
   - Street: `233 S Wacker Dr`
   - City: `Chicago`
   - State: `Illinois`
   - Postal Code: `60606`
   - Country: `United States`

4. **CHECK the "Use this address for future purchases" checkbox**

5. **Click "Save & Continue."** Tax will recalculate using the new address.

**Verification:**
```sql
-- Sales Order should have the new address
SELECT OrderApi__Shipping_Street__c, OrderApi__Shipping_City__c,
       OrderApi__Shipping_State__c, OrderApi__Shipping_Postal_Code__c
FROM OrderApi__Sales_Order__c WHERE Id = '<SO_ID>'

-- Contact should ALSO have the new address
SELECT MailingStreet, MailingCity, MailingState, MailingPostalCode
FROM Contact WHERE Id = '<CONTACT_ID>'
```

**Pass Criteria:**
- [ ] Sales Order shipping address is updated to the new address
- [ ] Contact mailing address is **ALSO** updated to the new address
- [ ] Tax recalculates using the new address (Illinois rate)
- [ ] Next time this user checks out, the new address appears by default

---

### TC-03: Checkout with Non-Nexus Address ($0 Tax)

**Objective:** Confirm that orders shipped outside nexus states get $0 tax.

**Steps:**

1. Reach the Tax Review screen (steps 1-5 from TC-01)

2. **Click "Edit Address"** and enter an address in a **non-nexus state:**
   - Street: `1 Infinite Loop`
   - City: `Cupertino`
   - State: `California`
   - Postal Code: `95014`
   - Country: `United States`

3. **Click "Save & Continue"**

4. **Verify tax = $0.00.** The checkout should show:
   - Tax: $0.00
   - This is correct: TCH has no nexus in California

**Pass Criteria:**
- [ ] Tax shows as $0.00
- [ ] Checkout proceeds normally (no error)
- [ ] No error messages about the address

---

### TC-04: Post-Payment Tax Commit and Avalara Portal Verification

**Objective:** Verify that after payment, the transaction is committed in Avalara and can be viewed in the Avalara portal.

**Steps:**

1. **Complete a checkout with tax** (complete TC-01 through payment)

2. **Enter payment information and confirm the payment** (see Navigation Basics → **N10**)

3. **The Payment Confirmation page appears** showing:
   - "Payment Successful" message
   - The amount paid
   - A "View Receipt" button
   - Behind the scenes, the system automatically commits the tax transaction to Avalara

4. **Wait about 10 seconds** for the background job to complete

5. **Verify in Salesforce** that the transaction was committed. Open the Developer Console (see Navigation Basics → **N5**) and run:
   ```sql
   SELECT Name, Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
   FROM OrderApi__Sales_Order__c
   WHERE OrderApi__Contact__r.Name LIKE '%Tanya Test%'
   ORDER BY CreatedDate DESC
   LIMIT 1
   ```
   - `Avalara_Transaction_Code__c` should be filled in (this is the Avalara transaction reference)
   - `Avalara_Transaction_Id__c` should be a number (this is the Avalara internal ID)

6. **Verify the transaction in the Avalara portal** (see Navigation Basics → **N9**):

   a. Open the Avalara Sandbox portal:
      `https://sandbox.admin.avalara.com`

   b. Log in with the TCH Avalara sandbox credentials

   c. In the left-hand menu, click **"Transactions"**

   d. On the Transactions page, you should see a list of recent transactions. Use the filters:
      - **Date range:** today's date
      - **Company:** TCHPC (if multiple companies are listed)

   e. Look for the transaction whose **"Doc Code"** matches the `Avalara_Transaction_Code__c` value from step 5

   f. Click on the transaction to open its details. You should see:
      - **Status:** "Committed"
      - **Type:** "SalesInvoice"
      - **Ship From:** 1114 Avenue of The Americas, 17th Floor, New York, NY 10036
      - **Ship To:** the customer's shipping address
      - **Line items:** the product(s) purchased with their tax codes
      - **Tax calculated:** the same amount shown during checkout

**Pass Criteria:**
- [ ] Payment Confirmation page renders without errors
- [ ] `Avalara_Transaction_Code__c` is populated on the Sales Order
- [ ] `Avalara_Transaction_Id__c` is populated on the Sales Order
- [ ] Transaction is visible in the Avalara Sandbox portal
- [ ] Transaction status is "Committed" in Avalara
- [ ] Tax amount in Avalara matches what was shown during checkout

---

### TC-05: Address Validation Errors (Two Levels)

**Objective:** Verify that the system validates the address in two stages and shows clear errors in each case.

The address is validated at **two levels:**

1. **Apex validation (local):** checks that the following fields on `OrderApi__Sales_Order__c` are all filled in (not blank):
   - `OrderApi__Shipping_Street__c`
   - `OrderApi__Shipping_City__c`
   - `OrderApi__Shipping_State__c`
   - `OrderApi__Shipping_Postal_Code__c`
   - `OrderApi__Shipping_Country__c`

   If **any** of these fields is blank, the error is raised **immediately** without calling Avalara. This is a quick client-side guard.

2. **Avalara API validation (remote):** if all 5 fields above are filled, the system calls Avalara's `ResolveAddress` API (`POST /api/v2/addresses/resolve`) sending those field values. Avalara attempts to geocode and normalize the address. If Avalara returns validation messages (e.g., "Address not geocoded", "Invalid postal code"), an error is returned to the user.

#### Scenario A: Missing address fields (Apex validation)

**Steps:**

1. Reach the Tax Review screen (steps 1-5 from TC-01)

2. **Click "Edit Address"**

3. **Clear the Street field** (leave it empty)

4. **Click "Save & Continue"**

5. **You should see a red error box** with the message:
   "Address validation failed: shipping address is incomplete. Please update your address."

6. **Fill in the Street field** and click "Save & Continue" again
   - The error should disappear and tax calculation should proceed normally

#### Scenario B: Invalid address (Avalara API validation)

**Steps:**

1. Reach the Tax Review screen (steps 1-5 from TC-01)

2. **Click "Edit Address"**

3. **Enter a fictitious address** (all fields filled but the address does not exist):
   - Street: `999 Nonexistent Boulevard`
   - City: `Faketown`
   - State: `New York`
   - Postal Code: `00000`
   - Country: `United States`

4. **Click "Save & Continue"**

5. **You should see a red error box** with a message like:
   "Address validation failed: the shipping address could not be verified. Please update your address."
   (The exact message may include Avalara's response detail, e.g., "Address not geocoded.")

6. **Correct the address** to a real one and click "Save & Continue" again
   - The error should disappear and tax calculation should proceed normally

**Pass Criteria:**
- [ ] Scenario A: error message appears immediately when a required field is blank
- [ ] Scenario B: error message appears after Avalara API returns a validation failure
- [ ] In both scenarios, the error message is displayed in a red box and is user-friendly
- [ ] In both scenarios, the user can correct the address and retry successfully
- [ ] No technical details (stack traces, API JSON) are shown to the user

---

### TC-06: Tax Exemption Disclaimer at Checkout

**Objective:** Verify that, when proceeding to checkout, an Account that is **not** flagged Tax Exempt sees a disclaimer directing them to contact customer service, while an Account that **is** flagged Tax Exempt sees **no disclaimer** and has **no Avalara tax** calculated. The storefront shows no exemption certificates, certificate page, or self-service registration.

**Background:** Certificate viewing, the Tax Exemption page, and all self-service exemption have been removed — members have no way to view or request certificates in the portal. Tax exemption is granted only by TCH staff via the Account **Tax Exempt** (`Tax_Exempt__c`) flag. For organizations that are not exempt, the checkout shows a short disclaimer pointing them to customer service.

#### Scenario A: Account NOT flagged Tax Exempt → disclaimer shown, tax calculated

**Steps:**

1. Log in as a member whose Account is **not** flagged Tax Exempt (`Tax_Exempt__c` = false).

2. Add a taxable product to the cart and **proceed to checkout**.

3. **Confirm a disclaimer appears** asking the member to reach out to customer service regarding tax exemption.

4. **Confirm there is no certificate view, no Tax Exemption page/link, and no "Request New Exemption" / registration form** anywhere in the flow.

5. Continue checkout and confirm **Avalara tax is still calculated** (the account is not exempt).

**Pass Criteria:**
- [ ] Disclaimer to contact customer service appears when proceeding to checkout
- [ ] No certificate table, no Tax Exemption page, no self-service registration anywhere in the storefront
- [ ] Avalara tax is still calculated for the non-exempt account

#### Scenario B: Account flagged Tax Exempt → no disclaimer, no tax

**Steps:**

1. Check **Tax Exempt** on the Account (`Tax_Exempt__c` = true) and Save — open the Account as in **N6** and edit the field as in **N7**.

2. As that member, add a taxable product and **proceed to checkout**.

3. **Confirm no disclaimer appears** and **Tax = $0.00** (no Avalara tax is calculated; see TC-07 for the full bypass behavior).

**Pass Criteria:**
- [ ] No disclaimer appears for a Tax-Exempt account
- [ ] No Avalara tax is calculated (Tax = $0.00); nothing committed to Avalara (see TC-07)

---

### TC-07: Account "Tax Exempt" Flag - Bypass All Tax

**Objective:** Verify that when the **Tax Exempt** checkbox is checked on an Account, all Avalara tax calculation is bypassed for that organization's orders — no tax at checkout and no transaction committed to Avalara. The bypass also applies to a Contact's orders when the Contact's parent Account is flagged.

**Background: How it works**

A checkbox field, **Tax Exempt** (`Tax_Exempt__c`), has been added to the Account (in the **Account Settings** section of the layout). When it is checked, the integration treats the organization as fully tax-exempt:

- **At checkout** (`calculateTax`): the Avalara estimate is skipped, tax is **$0.00**, and any previously calculated tax lines on the Sales Order are removed.
- **After payment** (`commitTax`): no `SalesInvoice` transaction is committed to Avalara (`Avalara_Transaction_Code__c` stays blank).

The flag is evaluated for the order's Account **or**, when the order is tied to a Contact, the **Contact's parent Account**. This is why the exemption follows the contacts of a tax-exempt organization.

> Editing this field requires the `Avalara_API_Access` permission set (or a profile granted Field-Level Security on `Account.Tax_Exempt__c`).

#### Scenario A: Account flagged Tax Exempt

**Steps:**

1. **In Salesforce, open the Account** for your test user (see Navigation Basics → **N6**) and **check the "Tax Exempt" checkbox** in the **Account Settings** section — edit the field as in **N7** — then **Save**.
   ```sql
   SELECT Id, Name, Tax_Exempt__c FROM Account WHERE Id = '<ACCOUNT_ID>'
   -- Tax_Exempt__c should be true
   ```

2. As that user, **add a taxable product to the cart** (e.g., "NCP Power Bank") and proceed to checkout with a **nexus-state** shipping address (e.g., New York) — an order that would normally be taxed (compare with TC-01).

3. **Proceed to checkout.** Because the Account is Tax Exempt, the order has no taxable items, so the **Tax Review tax step is skipped** (no exemption disclaimer appears — see TC-06) and checkout goes straight to payment.

4. **Verify the order's Tax is $0.00**, even though the address is in a nexus state and the product is normally taxable.

5. **Complete payment** (see Navigation Basics → **N10**), then verify **no transaction is committed** to Avalara:
   ```sql
   SELECT Name, Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
   FROM OrderApi__Sales_Order__c WHERE Id = '<SO_ID>'
   -- Avalara_Transaction_Code__c and Avalara_Transaction_Id__c should be blank
   ```
   In the Avalara portal, **no SalesInvoice** should appear for this order.

#### Scenario B: Bypass applied via the Contact's parent Account

**Objective:** Confirm the exemption follows the contacts of a tax-exempt organization (order tied to a Contact, Account flagged).

**Steps:**

1. Ensure the **test Contact's parent Account** has **Tax Exempt** checked (Scenario A, step 1).

2. Place a standard community checkout **as that Contact** (the Sales Order is tied to the Contact).

3. **Verify Tax: $0.00** at checkout and, after payment, **no committed transaction** (same queries as Scenario A).

#### Scenario C: Removing the flag restores tax (optional)

**Steps:**

1. **Uncheck "Tax Exempt"** on the Account and Save.

2. Start a new checkout for a taxable product to a nexus-state address.

3. **Verify tax is now calculated** (> $0.00), confirming the bypass only applies while the flag is set.

**Verification (no tax lines while exempt):**
```sql
-- While exempt, the Sales Order has no Avalara tax line items
SELECT Id, OrderApi__Item__r.Name, OrderApi__Sale_Price__c,
       OrderApi__Item__r.Avalara_Tax_Code__c, OrderApi__Item__r.Avalara_Tax__c
FROM OrderApi__Sales_Order_Line__c
WHERE OrderApi__Sales_Order__c = '<SO_ID>'
```

**Pass Criteria:**
- [ ] With **Tax Exempt** checked, checkout shows **$0.00** tax for a nexus-state taxable order
- [ ] No Avalara tax line items are created on the Sales Order
- [ ] After payment, `Avalara_Transaction_Code__c` remains blank (nothing committed to Avalara)
- [ ] No `SalesInvoice` appears in the Avalara portal for the order
- [ ] Bypass also applies when the order is tied to a **Contact whose parent Account** is flagged
- [ ] Unchecking the flag restores normal tax calculation

---

### TC-08: Void Transaction (Sales Order Voided)

**Objective:** Verify that when a Sales Order is voided via the Fonteva standard Quick Action, the corresponding Avalara transaction is automatically cancelled in Avalara.

**Background: How it works**

When a Sales Order is voided in Fonteva (standard Quick Action on the Sales Order record), the managed package sets the field `OrderApi__Sales_Order__c.OrderApi__Is_Voided__c` to `true`. A custom Apex trigger (`SalesOrderCustomTrigger`) detects this change and checks:

1. Was `OrderApi__Is_Voided__c` changed from `false` to `true`? (i.e., the Sales Order was just voided)
2. Does the Sales Order have a value in `Avalara_Transaction_Code__c`? (i.e., an Avalara transaction was previously committed)

If **both** conditions are met, the trigger enqueues an async job (`AvalaraVoidTransactionQueueable`) that calls Avalara's VoidTransaction API (`POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/void`) to cancel the transaction.

After voiding, the transaction status in the Avalara portal changes from **"Committed"** to **"Cancelled"**.

**Precondition:**
- A Sales Order that has completed payment and has `Avalara_Transaction_Code__c` populated (i.e., TC-04 was completed successfully)
- You need Salesforce admin access to execute the Quick Action on the Sales Order record

**Steps:**

1. **Identify a Sales Order with a committed Avalara transaction.** In the Developer Console (see Navigation Basics → **N5**), run:
   ```sql
   SELECT Id, Name, Avalara_Transaction_Code__c, Avalara_Transaction_Id__c,
          OrderApi__Is_Voided__c
   FROM OrderApi__Sales_Order__c
   WHERE Avalara_Transaction_Code__c != NULL
     AND OrderApi__Is_Voided__c = false
   ORDER BY CreatedDate DESC
   LIMIT 5
   ```
   Copy the `Avalara_Transaction_Code__c` value (you'll need it to verify in Avalara later).

2. **Open the Sales Order record** in Salesforce (Lightning) using the Id from step 1 (see Navigation Basics → **N6**)

3. **Execute the Void Quick Action** (see Navigation Basics → **N8**):
   - On the Sales Order record page, look for the Quick Action button (typically in the highlights panel; if hidden, use the dropdown arrow "▾" / "Show more actions")
   - Click the **"Void"** action (this is Fonteva's standard Sales Order void action)
   - Confirm the action when prompted

4. **Verify the Sales Order was voided.** The field `OrderApi__Is_Voided__c` should now be `true`:
   ```sql
   SELECT OrderApi__Is_Voided__c, Avalara_Transaction_Code__c
   FROM OrderApi__Sales_Order__c
   WHERE Id = '<SO_ID>'
   ```

5. **Wait about 10 seconds** for the async Queueable to execute

6. **Verify the async job completed:**
   ```sql
   SELECT Id, ApexClass.Name, Status, CompletedDate, ExtendedStatus
   FROM AsyncApexJob
   WHERE ApexClass.Name = 'AvalaraVoidTransactionQueueable'
   ORDER BY CreatedDate DESC
   LIMIT 1
   ```
   - `Status` should be `Completed`
   - `ExtendedStatus` should be null (no errors)

7. **Verify in the Avalara portal that the transaction is now cancelled** (see Navigation Basics → **N9**): find the transaction by the Doc Code you copied in step 1 and open its details. **Status should now be "Cancelled"** (previously it was "Committed").

**Pass Criteria:**
- [ ] Quick Action voids the Sales Order (`OrderApi__Is_Voided__c` = true)
- [ ] `AvalaraVoidTransactionQueueable` async job runs and completes without errors
- [ ] Transaction in Avalara portal changes status from "Committed" to "Cancelled"
- [ ] If the Sales Order does NOT have `Avalara_Transaction_Code__c` (no Avalara transaction), voiding does NOT trigger any Avalara API call (no error, no async job)

---

## Test Data Quick Reference

### TCH ShipFrom Address (configured in Avalara_Config__mdt)

This is TCH's headquarters address, used as the origin for all tax calculations:

| Field | Value |
|-------|-------|
| Street | 1114 Avenue of The Americas, 17th Floor |
| City | New York |
| State | NY |
| Postal Code | 10036 |
| Country | US |

### Tested ShipTo Address (confirmed working)

| Field | Value |
|-------|-------|
| Street | 351 Fifth Avenue |
| City | New York |
| State | New York (NY) |
| Postal Code | 10118 |
| Country | United States |

> This address was used with test user "Tanya Test" during development for both P0000000 and ST087640 products.

### Test Addresses by State

| State | Street | City | Postal Code | Tax? |
|-------|--------|------|-------------|------|
| NY | 351 Fifth Avenue | New York | 10118 | Yes (tested and confirmed) |
| NY | 20 W 34th St | New York | 10001 | Yes |
| TX | 100 Congress Ave | Austin | 78701 | Yes (state + local) |
| DC | 1600 Pennsylvania Ave NW | Washington | 20500 | Yes |
| IL | 233 S Wacker Dr | Chicago | 60606 | Yes |
| OH | 1 Nationwide Blvd | Columbus | 43215 | Yes |
| MI | 1 Campus Martius | Detroit | 48226 | Yes |
| NC | 550 S Tryon St | Charlotte | 28202 | Yes |
| CA | 1 Infinite Loop | Cupertino | 95014 | No ($0) |
| FL | 1000 Brickell Ave | Miami | 33131 | No ($0) |

### How to Find the Transaction in Avalara

After a successful payment, the transaction code is stored in the Salesforce field `OrderApi__Sales_Order__c.Avalara_Transaction_Code__c`. This value corresponds directly to the **"Doc Code"** (Document Code) field in the Avalara portal. A committed transaction will show status **"Committed"** in Avalara (unless it has been voided, in which case it shows "Cancelled").

**Step-by-step:**

1. **Get the transaction code from Salesforce.** Open the Sales Order record or run the query below in Developer Console. Copy the value of `Avalara_Transaction_Code__c`.
2. **Find it in the Avalara portal** (see Navigation Basics → **N9**): search the **"Doc Code"** for the `Avalara_Transaction_Code__c` value and open the transaction.
3. **Verify:**
   - **Status:** "Committed" (normal) or "Cancelled" (if voided)
   - **Type:** "SalesInvoice"
   - **Doc Code:** matches the `Avalara_Transaction_Code__c` on the Sales Order in Salesforce
   - **Ship From:** 1114 Avenue of The Americas, 17th Floor, New York, NY 10036
   - **Ship To:** the customer's shipping address
   - **Lines:** the product(s) purchased with their tax codes and calculated tax
   - **Total Tax:** should match what was displayed during checkout

### Key Salesforce Verification Queries

Open the **Developer Console** (Setup > Developer Console) and run these in the **Query Editor** tab:

```sql
-- Find recent Sales Orders for the test user
SELECT Id, Name, OrderApi__Contact__r.Name,
       Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
FROM OrderApi__Sales_Order__c
WHERE OrderApi__Contact__r.Name LIKE '%Tanya Test%'
ORDER BY CreatedDate DESC
LIMIT 5

-- Check all lines on a Sales Order (products + tax lines)
SELECT Id, OrderApi__Item__r.Name, OrderApi__Quantity__c,
       OrderApi__Sale_Price__c, OrderApi__Total__c,
       OrderApi__Price_Override__c,
       OrderApi__Item__r.Avalara_Tax_Code__c,
       OrderApi__Item__r.Avalara_Tax__c
FROM OrderApi__Sales_Order_Line__c
WHERE OrderApi__Sales_Order__c = '<PASTE_SO_ID_HERE>'
ORDER BY OrderApi__Item__r.Avalara_Tax__c NULLS LAST

-- Verify the async commit job ran successfully
SELECT Id, ApexClass.Name, Status, CompletedDate, ExtendedStatus
FROM AsyncApexJob
WHERE ApexClass.Name = 'AvalaraPaymentConfirmationQueueable'
ORDER BY CreatedDate DESC
LIMIT 1

-- Account's Avalara Customer ID (back-office Avalara link, set by TCH staff).
-- Not used by any storefront UI; certificate viewing was removed from the portal.
SELECT Id, Name, Avalara_Customer_Id__c
FROM Account
WHERE Id = '<PASTE_ACCOUNT_ID_HERE>'

-- Check if an Account is flagged Tax Exempt (bypasses ALL Avalara tax)
SELECT Id, Name, Tax_Exempt__c
FROM Account
WHERE Id = '<PASTE_ACCOUNT_ID_HERE>'
```
