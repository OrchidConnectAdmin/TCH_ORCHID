# Avalara AvaTax Integration: Test Script

## Prerequisites

### Test User

The test user used during development is **Tanya Test**:
- Contact: [003Vy00000D8gXGIAZ](https://cha--tchfull.sandbox.lightning.force.com/lightning/r/Contact/003Vy00000D8gXGIAZ/view)
- Community login: use this Contact's community credentials
- Login URL: `https://cha--tchfull.sandbox.my.site.com/LightningMemberPortal/s/login`

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

Only products that have the `Avalara_Tax__c` field populated (linked to a Tax Item with an Avalara Tax Code) will trigger tax calculation. You can verify which products are configured with this query in the Developer Console:

```sql
SELECT Id, Name, Avalara_Tax__c, Avalara_Tax__r.Name, Avalara_Tax__r.Avalara_Tax_Code__c
FROM OrderApi__Item__c
WHERE Avalara_Tax__c != NULL
ORDER BY Avalara_Tax__r.Avalara_Tax_Code__c, Name
```

#### Tested and Confirmed Working

The following tax codes have been tested end-to-end and confirmed to generate tax:

**P0000000 (Tangible Personal Property):**

| Product | Tax Code | Tested? |
|---------|----------|---------|
| NCP 10th Anniversary Paper Weight | P0000000 | Yes |
| NCP 10th Anniversary Umbrella | P0000000 | Yes |
| NCP Leather Cord Keeper | P0000000 | Yes |
| NCP Mouse Pad | P0000000 | Yes |
| NCP Power Bank | P0000000 | Yes |
| NCP Sports Bag | P0000000 | Yes |

**ST087640 (Pre-recorded Training / Webinar / Non-Subscription):**

| Product | Tax Code | Tested? |
|---------|----------|---------|
| Recording: Check Pain Points | ST087640 | Yes |
| Recording: UCC Basics | ST087640 | Yes |
| Recording: Exploring the ECCHO Rules | ST087640 | Yes |
| (and other "Recording:" products) | ST087640 | Yes |

> These were tested with ShipFrom = TCH headquarters (1114 Avenue of The Americas, 17th Floor, New York, NY 10036) and ShipTo = `351 Fifth Avenue, New York, Washington, 10118, United States` using the test user "Tanya Test".

**Other tax codes (configured but not yet tested end-to-end):**

| Tax Code | Description | Example Products |
|----------|-------------|-----------------|
| OA020500 | Admissions / Events | ECCHO Business Committee Meeting, Day 1 Participation |
| OD020500 | Membership Dues | ECCHO - Full Member Dues, ECCHO - Associate Membership |
| SF096370 | Catering Services | (A) ECCHO Reception, Day 1 Group Dinner |
| ST080010 | Online Skill Assessments | NCP Exam 2025, NCP Exam Practice Test |
| PC040100 | Clothing | NCP Golf Hat |
| PB100000 | Books / Manuals | ECCHO Rules Book - Printed Advertisement |
| SA030000 | Advertising Services | NCP Partnership - Gold Level |
| ST080000 | Training and Seminar | 5 for 4 NCP Workshop Bundle |
| ST087650 | Training Subscription | Individual Education Subscription |

---

## Test Cases

### TC-01: Checkout with Tax Calculation (Happy Path)

**Objective:** Verify that Avalara calculates and displays tax during checkout.

**What you will see:** A "Tax Review" card appears during checkout showing your items and shipping address. After you click "Continue", the system validates your address with Avalara and calculates tax. The checkout page then shows Subtotal + Tax + Total.

**Steps:**

1. **Log in** to the community portal:
   `https://cha--tchfull.sandbox.my.site.com/LightningMemberPortal/s/login`
   (Use the test user "Tanya Test" or any community user)

2. **Go to the ECCHO Store** by clicking "ECCHO Store" in the top navigation bar, or go directly to:
   `https://cha--tchfull.sandbox.my.site.com/LightningMemberPortal/s/store`

3. **Find a taxable product.** Look for one of the confirmed products:
   - "NCP Power Bank" or "NCP Mouse Pad" (tax code P0000000), OR
   - Any "Recording:" product (tax code ST087640)

4. **Add the product to your cart** and proceed to checkout

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

2. **Enter payment information** and confirm the payment

3. **The Payment Confirmation page appears** showing:
   - "Payment Successful" message
   - The amount paid
   - A "View Receipt" button
   - Behind the scenes, the system automatically commits the tax transaction to Avalara

4. **Wait about 10 seconds** for the background job to complete

5. **Verify in Salesforce** that the transaction was committed. Open the Developer Console and run:
   ```sql
   SELECT Name, Avalara_Transaction_Code__c, Avalara_Transaction_Id__c
   FROM OrderApi__Sales_Order__c
   WHERE OrderApi__Contact__r.Name LIKE '%Tanya Test%'
   ORDER BY CreatedDate DESC
   LIMIT 1
   ```
   - `Avalara_Transaction_Code__c` should be filled in (this is the Avalara transaction reference)
   - `Avalara_Transaction_Id__c` should be a number (this is the Avalara internal ID)

6. **Verify the transaction in the Avalara portal:**

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

### TC-06: Tax Exemption Banner on Checkout

**Objective:** Verify that registered Avalara customers see a tax exemption link during checkout.

**Precondition:** The user's Account must already have `Avalara_Customer_Id__c` populated (i.e., the user was previously registered in Avalara ECM via TC-07).

**Steps:**

1. Reach the Tax Review screen (steps 1-5 from TC-01)

2. **Look for the green exemption banner** between the subtitle and the items table. It should say:
   - Text: "You may be eligible for tax exemptions. Submit or manage your exemption certificates."
   - A button: **"View Tax Exemptions"**

3. **Click "View Tax Exemptions"**
   - You should be redirected to the Tax Exemption page

4. **If the banner does NOT appear:** this is expected when the Account does not have an Avalara Customer ID. You must first register via the Tax Exemption page (see TC-07).

**Pass Criteria:**
- [ ] Green banner is visible when Account has Avalara Customer ID
- [ ] Banner is NOT visible when Account does not have Avalara Customer ID
- [ ] "View Tax Exemptions" button redirects to the Tax Exemption page

---

### TC-07: Tax Exemption Page - New Customer Registration

**Objective:** Verify that a user who has never registered can submit their information to Avalara and receive a CertExpress portal link.

**Precondition:** The user's Account must NOT have `Avalara_Customer_Id__c` populated.

**How to access the Tax Exemption page:**
- **From checkout:** click the "View Tax Exemptions" button in the green banner (TC-06)
- **From the profile menu:** when logged in, click on your profile icon/name in the top-right corner of the community page. In the dropdown menu, click **"Tax Exemption"**
- **Direct URL:** `https://cha--tchfull.sandbox.my.site.com/LightningMemberPortal/s/tax-exemption`

**What you will see:** A registration form where you provide your name, address, and email so Avalara can create your customer profile and generate a link to their CertExpress portal (where you upload exemption certificates).

**Steps:**

1. **Navigate to the Tax Exemption page** using one of the methods above

2. **The registration form appears** with:
   - An **address source dropdown** at the top. Options include:
     - Your Contact address (pre-filled from your Salesforce Contact record)
     - Your Account address (pre-filled from the Account's shipping address)
     - "Enter address manually" (all fields editable)
   - Fields: **Name**, **Email**, **Street**, **City**, **State**, **Postal Code**, **Country**
   - A **"Submit"** button

3. **Select an address source.** The form fields automatically fill in based on your selection. You can also choose "Enter address manually" to type a custom address.

4. **Verify all fields are filled in** and click **"Submit"**

5. **What happens next:**
   - A spinner appears while the system registers you in Avalara
   - A **new browser tab opens** with the Avalara CertExpress portal
   - On the original page, you see a **success message** with a button "Open CertExpress Portal" (in case the new tab was blocked by your browser)

6. **In the CertExpress portal** (the new tab), you can upload your tax exemption certificate. This is Avalara's hosted portal, not part of TCH's system.

**Verification (Salesforce):**
```sql
SELECT Avalara_Customer_Id__c
FROM Account
WHERE Id = '<ACCOUNT_ID>'
```
- `Avalara_Customer_Id__c` should now be populated with a number (the Avalara customer ID)

**Pass Criteria:**
- [ ] Registration form displays with address source dropdown and pre-filled fields
- [ ] After clicking Submit, CertExpress portal opens in a new tab
- [ ] Success message appears on the original page
- [ ] `Avalara_Customer_Id__c` is saved on the Account in Salesforce

---

### TC-08: Tax Exemption Page - Returning Customer (Already Registered)

**Objective:** Verify that a user who was previously registered sees their existing certificates and can request new exemptions without re-registering.

**Precondition:** The user's Account has `Avalara_Customer_Id__c` populated (completed TC-07 previously).

**How to access:** Same as TC-07 (profile menu > "Tax Exemption", or direct URL).

**What you will see:** Instead of the registration form, you see a **certificates table** showing your existing exemption certificates from Avalara, and a button to request a new one.

**Steps:**

1. **Navigate to the Tax Exemption page**

2. **The registered customer view appears** with:
   - A **certificates table** showing your existing certificates (if any). Each row displays:
     - **ID:** the Avalara certificate ID
     - **Status:** "Complete" (green badge), "Expired" (red badge), or "Pending" (yellow badge)
     - **Signed Date:** when the certificate was signed
     - **Expiration Date:** when the certificate expires
     - **Exposure Zone:** the state/jurisdiction the certificate covers (e.g., "New York")
     - **Exemption Reason:** why the exemption applies (e.g., "Federal Government", "Religious Organization")
   - If you have no certificates yet, the table will be empty
   - A **"Request New Exemption"** button

3. **Click "Request New Exemption"**
   - A **new browser tab opens** with the Avalara CertExpress portal (same as TC-07)
   - The system does NOT re-register you in Avalara. It only generates a new invitation link.

**Pass Criteria:**
- [ ] Certificates table is displayed (with data if certificates exist, empty if none)
- [ ] Status badges show correct colors: green (Complete/Approved), red (Expired/Revoked), yellow (Pending)
- [ ] "Request New Exemption" opens CertExpress in a new tab
- [ ] No error about duplicate customer registration

---

### TC-09: Void Transaction (Sales Order Voided)

**Objective:** Verify that when a Sales Order is voided via the Fonteva standard Quick Action, the corresponding Avalara transaction is automatically cancelled in Avalara.

**Background: How it works**

When a Sales Order is voided in Fonteva (standard Quick Action on the Sales Order record), the managed package sets the field `OrderApi__Sales_Order__c.OrderApi__Is_Voided__c` to `true`. A custom Apex trigger (`SalesOrderCustomTrigger`) detects this change and checks:

1. Was `OrderApi__Is_Voided__c` changed from `false` to `true`? (i.e., the Sales Order was just voided)
2. Does the Sales Order have a value in `Avalara_Transaction_Code__c`? (i.e., an Avalara transaction was previously committed)

If **both** conditions are met, the trigger enqueues an async job (`AvalaraVoidTransactionQueueable`) that calls Avalara's VoidTransaction API (`POST /api/v2/companies/{companyCode}/transactions/{transactionCode}/void`) to cancel the transaction.

After voiding, the transaction status in the Avalara portal changes from **"Committed"** to **"Voided"**.

**Precondition:**
- A Sales Order that has completed payment and has `Avalara_Transaction_Code__c` populated (i.e., TC-04 was completed successfully)
- You need Salesforce admin access to execute the Quick Action on the Sales Order record

**Steps:**

1. **Identify a Sales Order with a committed Avalara transaction.** In the Developer Console, run:
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

2. **Open the Sales Order record** in Salesforce (Lightning) by navigating to the Sales Order ID from step 1

3. **Execute the Void Quick Action:**
   - On the Sales Order record page, look for the Quick Action button (typically in the highlights panel or the action menu "...")
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

7. **Verify in the Avalara portal that the transaction is now cancelled:**
   a. Go to `https://sandbox.admin.avalara.com`
   b. Click **"Transactions"** in the left menu
   c. Search for the Doc Code you copied in step 1
   d. Open the transaction details
   e. **Status should now be "Voided"** (previously it was "Committed")

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
| State | Washington |
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
2. Log in to the Avalara Sandbox portal at `https://sandbox.admin.avalara.com`
3. Click **"Transactions"** in the left-hand menu
4. Set the date filter to today (or the date of the purchase)
5. In the **"Doc Code"** search field, paste the `Avalara_Transaction_Code__c` value from Salesforce
6. Click the transaction row to open its details
7. **Verify:**
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

-- Check if Account has Avalara Customer ID
SELECT Id, Name, Avalara_Customer_Id__c
FROM Account
WHERE Id = '<PASTE_ACCOUNT_ID_HERE>'
```
