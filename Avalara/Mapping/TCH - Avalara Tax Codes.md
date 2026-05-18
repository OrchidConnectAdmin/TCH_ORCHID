# Avalara Tax Code Mapping Summary

## Data Sources

| Source | Count |
|--------|-------|
| Total Avalara tax codes in catalog | 5701 |
| Active Avalara tax codes (isActive = true) | 3162 |
| Salesforce Items (OrderApi__Item__c) total in org | 748 |
| Active items with sales history (query result) | 121 |
| Items mapped | 121 |

The source dataset was filtered with the following criteria:
- `OrderApi__Is_Active__c = TRUE` (only active items)
- `NOT Name LIKE '%FON%'` (excludes Fonteva demo/sample data)
- `ID IN (SELECT OrderApi__Item__c FROM OrderApi__Sales_Order_Line__c)` (only items with at least one sales order)

This ensures the mapping covers only products that are actively sold by TCH.

## Avalara Nexus Configuration

TCH's Avalara account has nexus configured for 7 US states plus the federal level. Only transactions shipped to or occurring in these jurisdictions will have tax calculated. The nexus configuration was retrieved from the Avalara API (`GET /api/v2/companies/{companyId}/nexus`).

| Jurisdiction | Type | Nexus Type | Effective Since | Local Nexus | SST Member |
|-------------|------|------------|-----------------|-------------|------------|
| United States | Country | Sales or Sellers Use Tax | 2014-11-10 | No | No |
| District of Columbia (DC) | State | Sales or Sellers Use Tax | 2014-11-20 | No | No |
| Illinois (IL) | State | Sales or Sellers Use Tax | 2014-11-20 | No | No |
| Michigan (MI) | State | Sales or Sellers Use Tax | 2016-01-01 | No | Yes |
| North Carolina (NC) | State | Sales or Sellers Use Tax | 2014-11-10 | No | Yes |
| New York (NY) | State | Sales or Sellers Use Tax | 2014-11-10 | No | No |
| Ohio (OH) | State | Sales or Sellers Use Tax | 2014-11-20 | No | Yes |
| Texas (TX) | State | Sales or Sellers Use Tax | 2014-11-10 | All | No |

Key observations:
- **Texas** is the only state with `localNexusTypeId: "All"`, meaning local jurisdiction taxes (city, county, special district) are also calculated
- **Michigan, North Carolina, and Ohio** are Streamlined Sales Tax (SST) member states, which simplifies tax administration
- All nexus entries have `hasPermanentEstablishment: true`, indicating physical presence in each jurisdiction
- No local nexus is enabled for the other states (only state-level tax is calculated)

## Mapping Methodology

### How the product-to-tax-code mapping (SalesforceItemsTaxCodes.csv) was built

The mapping from Salesforce products to Avalara tax codes was built through a structured process that combines Salesforce metadata with Avalara's tax code taxonomy.

**Step 1: Extract active products from Salesforce**

A SOQL query was used to pull only items that are active, not demo data, and have real sales history:

```sql
SELECT Id, Name, Is_Education_Member__c, Is_Complimentary_Education__c,
       Is_NCP_Filing_Fee__c, OrderApi__Is_Contribution__c, OrderApi__Is_Membership__c,
       OrderApi__Is_Publication__c, OrderApi__Is_Default_Shipping_Rate__c,
       OrderApi__Is_Subscription__c, OrderApi__Is_Tax__c, OrderApi__Is_Tax_Deductible__c,
       OrderApi__Is_Taxable__c, OrderApi__Is_Unapplied_Payment__c,
       ProgramApi__Is_Program_Fee__c, ProgramApi__Is_Program_Maintenance_Fee__c
FROM OrderApi__Item__c
WHERE OrderApi__Is_Active__c = TRUE
  AND (NOT Name LIKE '%FON%')
  AND ID IN (SELECT OrderApi__Item__c FROM OrderApi__Sales_Order_Line__c)
```

This returned 121 items. The boolean fields serve as the primary classification signal.

**Step 2: Classify each item into a product category**

Each item was assigned a product category using a combination of Salesforce boolean flags and item name patterns, applied in priority order:

| Priority | Rule | Product Category | Example Match |
|----------|------|-----------------|---------------|
| 1 | Name = "Discount" | Discount | "Discount" |
| 2 | Name contains "Rules Book" | Book/Manual | "ECCHO Rules Book - Printed Advertisement" |
| 3 | Name contains "Dues" or "Membership" or "Member Join Fee" | Membership Dues | "ECCHO - Full Member Dues", "ECCHO - Associate Membership" |
| 4 | `Is_Subscription__c = true` AND name contains "Education" or "Subscription" | Education Subscription | "Individual Education Subscription", "Corporate Education Subscription" |
| 5 | Name contains "Partnership" or "Sponsorship" | Sponsorship | "NCP Partnership - Gold Level", "ECCHO Operations Meeting Sponsorship" |
| 6 | Name starts with "Recording:" | Webinar/Webcast (Pre-recorded) | "Recording: Check Pain Points", "Recording: UCC Basics" |
| 7 | Name starts with "All About Check:" or "What do I do when:" or contains "Check Adjustments Insights", "Principles and Concepts of Image Cash Letters", "Overview of Check Returns", "RDC Risk Management" | Online Training | "All About Check: Check Basics", "What do I do when: HIDC Claims" |
| 8 | Name contains "NCP Exam" or "Exam Bundle" or "Practice Test" | Exam/Certification Fee | "NCP Exam 2025", "NCP Exam Bundle - 3 for 2" |
| 9 | Name contains "Paper Weight", "Umbrella", "Leather Cord", "Sports Bag", "Power Bank", or "Mouse Pad" | Merchandise/Tangible Goods | "NCP 10th Anniversary Paper Weight", "NCP Power Bank" |
| 10 | Name contains "Golf Hat" | Merchandise - Clothing | "NCP Golf Hat" |
| 11 | Name contains "Reception", "Dinner", "Luncheon", "Breakfast", or "Lunch" | Meal/Food Event | "(A) ECCHO Reception", "Day 1 Group Dinner" |
| 12 | Name contains "Workshop" or "NCP Session" | Training/Workshop | "5 for 4 NCP Workshop Bundle", "NCP Session Application Fee" |
| 13 | Everything else (committee meetings, roundtables, participation, etc.) | Conference/Event Registration | "ECCHO Business Committee Meeting", "Day 1 Participation" |

Rules are applied in order: the first match wins. For example, "ECCHO Associate Member Quarterly Dues" matches rule 3 (contains "Dues") before it could reach rule 13 (default).

**Step 3: Assign an Avalara tax code to each category**

Each product category was mapped to the most specific active Avalara tax code that correctly describes the product's nature and delivery format:

| Product Category | Avalara Tax Code | Selection Logic |
|-----------------|------------------|-----------------|
| Discount | OD010000 | Avalara's standard discount code; generic discount, no specific subcode applies |
| Book/Manual | PB100000 | Printed books/manuals; subcodes are for religious, puzzle, coupon books:not applicable |
| Membership Dues | OD020500 | Professional association dues without entertainment; no TPP transfer included |
| Education Subscription | ST087650 | Subscription-based access to training platform; `Is_Subscription__c` flag confirms model |
| Sponsorship | SA030000 | Advertising/visibility services without transfer of tangible property |
| Webinar/Webcast (Pre-recorded) | ST087640 | Pre-recorded content, sold individually (not subscription); "Recording:" prefix confirms format |
| Online Training | ST087634 | Self-paced online courses; more specific than generic Training (ST080000) |
| Exam/Certification Fee | ST080010 | Online skill assessments/exams; distinct from training in tax treatment |
| Merchandise/Tangible Goods | P0000000 | Mixed promotional merchandise; no single subcode fits the variety |
| Merchandise - Clothing | PC040100 | Clothing (B2C general); enables clothing exemptions in states like PA, NJ |
| Meal/Food Event | SF096370 | Catering services at events; distinct from food-to-go (PF codes) |
| Training/Workshop | ST080000 | In-person training; subcodes for simulations/tutoring don't apply |
| Conference/Event Registration | OA020500 | Professional event admissions; not entertainment; leaf code (most specific) |


## Category Distribution

13 unique Avalara tax codes across 13 product categories.

| Product Category | Item Count | Avalara Tax Code | Tax Code Description |
|-----------------|------------|------------------|---------------------|
| Conference/Event Registration | 33 | OA020500 | Admissions / Events Other Than Entertainment or Amusement |
| Webinar/Webcast (Pre-recorded) | 18 | ST087640 | Training / Webinar Only / SaaS Platform / Pre-recorded, Non-Subscription |
| Online Training | 16 | ST087634 | Online Training |
| Membership Dues | 16 | OD020500 | Dues (Social, Fraternal, non-entertainment) |
| Meal/Food Event | 10 | SF096370 | Catering Services |
| Exam/Certification Fee | 9 | ST080010 | Online Skill Assessments |
| Merchandise/Tangible Goods | 6 | P0000000 | Tangible Personal Property (TPP) |
| Sponsorship | 5 | SA030000 | Advertising Services - No Transfer of TPP |
| Education Subscription | 2 | ST087650 | Training / Webinar / SaaS Platform / Subscription / No download |
| Training/Workshop | 2 | ST080000 | Training and Seminar |
| Book/Manual | 2 | PB100000 | Books / Manuals |
| Merchandise - Clothing | 1 | PC040100 | Clothing And Related Products (Business-To-Customer)-general |
| Discount | 1 | OD010000 | Discounts |

## Tax Code Selection Rationale

This section documents the selection criteria for each of the 13 Avalara Tax Codes used in the mapping. For each code: what it represents, which products were mapped to it, why this code was chosen over alternatives, and the fiscal impact of the choice.

### OA020500: Admissions / Events Other Than Entertainment or Amusement (33 of 121 items)

**Products:** committee meetings, roundtables, conference sessions, and event participation (e.g., "ECCHO Operations Committee Meeting", "ECCHO Business Committee Meeting", "ECCHO Roundtable Discussion", "2025 NCP Cut Score Meeting", "Day 1 Participation").

**Why this code:** professional and industry meetings in the banking sector do not qualify as entertainment. OA020500 covers admissions to events that are not entertainment or amusement, which is the correct classification for business committee meetings, roundtables, and conference participation. Alternative codes such as OA020100 (entertainment) or OA020700 (golf) do not apply because TCH events are professional/educational. OA020500 is a leaf code (no more specific children available), making it the most granular level in the Avalara taxonomy.

**Tax impact:** prevents professional events from being taxed as entertainment, which would generate incorrect rates in states that differentiate entertainment admissions from professional event admissions.

### ST087640: Training / Webinar / Pre-recorded, Non-Subscription (18 of 121 items)

**Products:** pre-recorded webinars and educational content sold as individual access without subscription (e.g., "Recording: All You Wanted To Know About Check Adjustments", "Recording: Check Pain Points", "Recording: UCC Warranties from A to U", "Recording: Combating Cashiers Check Fraud", "Recording: Exploring the ECCHO Rules").

**Why this code:** all of these items are explicitly pre-recorded content (identified by the "Recording:" prefix in the item name) sold individually without a subscription model. ST087640 specifies this exact combination: pre-recorded, non-subscription training content. This distinction matters because some jurisdictions classify pre-recorded content as a "digital product" (potentially taxed as digital TPP) while live training is classified as a "service." Using the generic ST080000 (Training and Seminar) would not capture this distinction.

**Tax impact:** jurisdictions that differentiate live from pre-recorded content apply the correct rate. States that exempt live services but tax digital products will correctly tax pre-recorded content.

### ST087634: Online Training (16 of 121 items)

**Products:** structured online courses and digital educational modules (e.g., "All About Check: Check Basics: What Every Banker Should Know", "What do I do when: HIDC Claims", "Principles and Concepts of Image Cash Letters and Electronic Check Adjustments", "Check Adjustments Insights into Investigation Types (ITYPs)", "RDC Risk Management").

**Why this code:** these items are self-guided online learning modules, distinct from pre-recorded webinars (ST087640) because they are structured courses rather than recorded presentations. ST087634 (Online Training) is more specific than ST080000 (generic Training) and captures the digital, self-paced nature of the delivery. Several US states treat online training differently from in-person training: some exempt digital education services while taxing in-person seminars.

**Tax impact:** enables Avalara to apply digital education service exemptions in jurisdictions where they exist.

### OD020500: Dues (Social, Fraternal, non-entertainment) (16 of 121 items)

**Products:** membership fees, annual dues, and join fees (e.g., "ECCHO - Full Member Dues", "ECCHO Associate Member Quarterly Dues ($20B up to $60B deposit tier)", "ECCHO - Associate Membership", "ECCHO Participating Member Join Fee (Reduced)", "2022 Prorated PM Dues (Central Bank MO)").

**Why this code:** professional/trade association dues without an entertainment component fall under OD020500. This includes recurring annual/quarterly dues, prorated dues for new members, join fees, and placeholder membership items. Alternative codes such as OD020100 (dues with entertainment) or OD020400 (dues with guaranteed TPP transfer) do not apply because ECCHO memberships are professional and do not include entertainment or tangible product delivery as a benefit. This is a leaf code:the most specific level available.

**Tax impact:** many states exempt professional association dues without an entertainment component. Using the correct code ensures these exemptions are applied.

### SF096370: Catering Services (10 of 121 items)

**Products:** receptions, dinners, and food events at conferences (e.g., "(A) ECCHO Reception", "ECCHO/SVPCO Reception and Dinner", "Welcome Reception", "Day 1 Group Dinner", "ECCHO Operations Committee Networking Reception").

**Why this code:** when food is sold as part of a catering service for events, the correct code is SF096370 (Catering Services) rather than the prepared food codes (PF - Food/Beverages). The distinction matters: catering is a service that includes preparation, delivery, and serving, while PF codes are for direct food sales. Many states tax catering differently from food-to-go. This is a leaf code.

**Tax impact:** correctly applies catering (service) rules instead of food sale (product) rules.

### ST080010: Online Skill Assessments (9 of 121 items)

**Products:** exam and professional certification fees (e.g., "NCP Exam 2025", "NCP Exam Rollover Fee (early)", "NCP Exam Retest Fee (current year)", "NCP Exam Practice Test", "NCP Exam Bundle - 3 for 2 (ECCHO Member Rate)").

**Why this code:** exams and competency assessments are distinct from training. ST080010 specifically covers online skill assessments, which is exactly what NCP certification exams represent. This includes the exam itself, retests, rollovers, practice tests, and exam bundles. Some states exempt professional exam fees or apply different rules than those for training services. This is a leaf code:no more specific children exist.

**Tax impact:** correctly separates exams from training, enabling professional assessment exemptions to be applied where they exist.

### P0000000: Tangible Personal Property (6 of 121 items)

**Products:** NCP-branded promotional merchandise (e.g., "NCP 10th Anniversary Paper Weight", "NCP 10th Anniversary Umbrella", "NCP Leather Cord Keeper", "NCP Sports Bag", "NCP Power Bank", "NCP Mouse Pad").

**Why this code:** these items are physical promotional products that do not fit any specific Avalara subcategory. Child codes of P0000000 cover categories such as PB (books), PC (clothing), PO (office supplies), PE (equipment), none of which accurately describes this mix of promotional merchandise (paper weights, power banks, cord keepers, sports bags). P0000000 is the catch-all code for tangible goods and ensures standard TPP treatment.

**Tax impact:** TPP is taxed in most states. The general code ensures tangible items are not inadvertently exempt from taxation.

### SA030000: Advertising Services - No Transfer of TPP (5 of 121 items)

**Products:** NCP partnership/sponsorship packages and event sponsorships (e.g., "NCP Partnership - Silver Level", "NCP Partnership - Gold Level", "NCP Partnership - Diamond Level", "2024 NCP Partnership - Platinum Level", "ECCHO Operations Meeting Sponsorship").

**Why this code:** partnership and sponsorship packages provide brand visibility and organizational benefits without transferring tangible property. SA030000 covers advertising services without TPP transfer, which is the nature of a sponsorship/partnership. Child codes such as SA030200 (public relations), SA030300 (market research), or SA038000 (advertising agency) do not apply because partnership/sponsorship packages are none of those specific services.

**Tax impact:** correctly classifies sponsorship as an advertising service, not as a product purchase or media space.

### ST087650: Training / Subscription / No download (2 of 121 items)

**Products:** education subscriptions providing ongoing access to content (e.g., "Individual Education Subscription", "Corporate Education Subscription").

**Why this code:** these items represent recurring subscriptions granting access to an educational content platform, without download of materials. Both items have the `Is_Subscription__c = true` flag in Salesforce, confirming their subscription nature. The sales model (subscription vs. one-time purchase) affects the tax treatment: several states classify training platform subscriptions as SaaS, which has different treatment from a one-time course purchase. ST087650 correctly reflects this subscription model.

**Tax impact:** jurisdictions that tax SaaS/subscriptions differently from one-time services apply the correct rule.

### ST080000: Training and Seminar (2 of 121 items)

**Products:** in-person workshops and session bundles (e.g., "5 for 4 NCP Workshop Bundle", "NCP Session Application Fee").

**Why this code:** these items represent in-person training events where the attendee is physically present. ST080000 is the root code for the Training category and applies to general in-person seminars and workshops. More specific child codes exist (ST080020 for simulations, ST080032 for in-person tutoring), but they do not apply because NCP workshops are general educational sessions, not simulations or one-on-one tutoring.

**Tax impact:** states that differentiate in-person training from online training correctly apply the rules for in-person services.

### PB100000: Books / Manuals (2 of 121 items)

**Products:** printed books and manuals (e.g., "ECCHO Rules Book - Printed Advertisement", "2024 ECCHO Rules Book - Printed Advertisement").

**Why this code:** PB100000 is the base code for books and manuals. Child codes cover subcategories such as religious books (PB100300), bibles (PB100400), puzzle books (PB100818), and coupon books (PB100819). None of these subcategories apply to ECCHO rules books, which are technical professional publications. PB100000 is the correct level of specificity.

**Tax impact:** several states exempt educational books or apply reduced rates. The PB100000 code ensures these rules are applied.

### PC040100: Clothing (Business-To-Customer) - general (1 of 121 items)

**Products:** branded apparel (e.g., "NCP Golf Hat").

**Why this code:** PC040100 covers general B2C clothing. A hat/cap is clothing under Avalara's taxonomy. This classification matters because several states (PA, NJ, MN, among others) exempt clothing from sales tax. Using the generic TPP code (P0000000) would prevent the clothing exemption from being applied.

**Tax impact:** states with clothing exemptions correctly apply the exemption.

### OD010000: Discounts (1 of 121 items)

**Products:** generic discount item used to apply price reductions on orders (e.g., "Discount").

**Why this code:** OD010000 is Avalara's standard code for discounts. Child codes exist for specific types (OD010010 - Loyalty Rewards, OD010101 - Early Payment Discount), but when the discount is generic and applied broadly, the parent code is the most appropriate because it does not restrict to any specific discount mechanism.

**Tax impact:** discount treatment depends on how it relates to the order items. The generic code ensures Avalara applies the jurisdiction's standard discount rule.

## All Avalara Tax Codes Used in Mapping

13 unique tax codes used. Each code below has been verified to exist in the AvalaraTaxCodes.csv file with isActive = true.

Avalara tax codes are organized in a hierarchy (parent → child). A code that has **no subcodes below it** is the most specific level available:the most granular classification Avalara offers. A code that **has subcodes below it** is a broader category; it was chosen when none of its subcodes is a better match for the products in question.

| Tax Code | Description | isPhysical | Items Mapped | Most Specific Available? |
|----------|-------------|------------|-------------|------------------------|
| OA020500 | Admissions / Events Other Than Entertainment or Amusement | false | 33 | Yes:no subcodes exist |
| OD010000 | Discounts | false | 1 | No:subcodes exist (Loyalty Rewards, Early Payment, etc.) but the discount is generic, so the broader code is appropriate |
| OD020500 | Dues (Social, Fraternal, non-entertainment) | false | 16 | Yes:no subcodes exist |
| P0000000 | Tangible Personal Property (TPP) | true | 6 | No:subcodes exist (Books, Clothing, Office Supplies, etc.) but none matches promotional merchandise like paper weights or power banks |
| PB100000 | Books / Manuals | true | 2 | No:subcodes exist (Religious, Puzzle, Coupon books) but none applies to professional/technical publications |
| PC040100 | Clothing And Related Products (B2C)-general | true | 1 | No:subcodes exist (Boots, Hosiery, etc.) but the general clothing code is appropriate for a hat |
| SA030000 | Advertising Services - No Transfer of TPP | false | 5 | No:subcodes exist (PR, Market Research, Media Placement) but none matches sponsorship/partnership packages |
| SF096370 | Catering Services | false | 10 | Yes:no subcodes exist |
| ST080000 | Training and Seminar | false | 2 | No:subcodes exist (Online Training, Webinar, etc.) but this code is used only for in-person workshops where no subcode is a better fit |
| ST080010 | Online Skill Assessments | false | 9 | Yes:no subcodes exist |
| ST087634 | Online Training | false | 16 | Yes:no subcodes exist |
| ST087640 | Training / Webinar Only / SaaS Platform / Pre-recorded, Non-Subscription | false | 18 | Yes:no subcodes exist |
| ST087650 | Training / Webinar / SaaS Platform / Subscription / No download | false | 2 | Yes:no subcodes exist |

## Notes

- All 5,701 Avalara tax codes were read from the CSV file
- Only codes with isActive = true (3,162 codes) were considered for mapping
- Every tax code used in this mapping has been verified to exist in the CSV with isActive = true
- Avalara recommends using the most specific (leaf) tax code available for accurate tax calculation
- Parent codes were retained only when no child code is a better fit for the product type
- Items were filtered to active-only with real sales history, excluding Fonteva demo data
- "ECCHO" (Electronic Check Clearing House Organization) items represent the core of TCH's product catalog
- "NCP" (National Check Professional) items cover certification, exams, workshops, and branded merchandise
- Training content was split across 4 tax codes based on delivery format: in-person (ST080000), online courses (ST087634), pre-recorded webinars (ST087640), and subscription access (ST087650):this ensures jurisdiction-specific rules for each format are applied correctly
- Receptions and dinners at conferences are mapped to Catering (SF096370), distinct from the meeting/session admission items (OA020500), because the tax treatment of food services differs from event admissions in many states

## Appendix: Available Subcodes for Broader Tax Codes

The 6 tax codes marked as "No" in "Most Specific Available?" have more granular subcodes in Avalara's catalog. These subcodes were not selected because none is a better fit for the mapped products. They are listed below for reference, should the client wish to evaluate alternatives.

### OD010000: Discounts:5 active subcodes

| Subcode | Description |
|---------|-------------|
| OD010010 | Loyalty Rewards Points / Earned Through Purchases |
| OD010101 | Cash Discount / Retailer Discounts For Early Payment / Discount Taken After Point of Sale |
| OD010102 | Cash Discount / Retailer Discounts For Early Payment / Discount Taken at Point of Sale |
| OD010103 | Retailer Discounts For Paying With Cash Rather Than Credit |
| OD010300 | Discounts on TPP |

**Why the broader code was chosen:** TCH's discount item is a generic line-item discount not tied to any specific mechanism (loyalty, early payment, or cash). None of the subcodes applies.

### P0000000: Tangible Personal Property:353 active subcodes (relevant subset shown)

P0000000 is the root of Avalara's entire physical product taxonomy. Its subcodes span hundreds of product categories (food, health care, vehicles, agricultural products, etc.). The subcodes most relevant to TCH's promotional merchandise are:

| Subcode | Description | Why not selected |
|---------|-------------|-----------------|
| PO100000 | Office Supplies | Could apply to NCP Mouse Pad; does not apply to paper weights, power banks, or sports bags |
| PE200706 | Exercise Supplies | Could apply to NCP Sports Bag if considered exercise gear; promotional bag is a better fit for generic TPP |
| PT030000 | Telecommunication Machinery & Equipment | Does not apply to a promotional power bank (it's a battery accessory, not telecom equipment) |
| PC080000 | Computer Hardware (Business-to-Customer) | Does not apply:a mouse pad is a desk accessory, not computer hardware |
| PG068810 | Glassware | Does not apply:none of the items are glass products |

**Why the broader code was chosen:** these 6 items are a diverse mix of promotional merchandise (paper weight, umbrella, cord keeper, sports bag, power bank, mouse pad). No single subcode covers the full set, and splitting them across multiple subcodes would not improve tax accuracy since all are taxed as standard TPP in every jurisdiction.

### PB100000: Books / Manuals:7 active subcodes

| Subcode | Description |
|---------|-------------|
| PB100200 | Books / Manuals - other |
| PB100210 | Code books and textbooks for the construction industry |
| PB100300 | Books / Manuals - religious |
| PB100400 | Bibles, hymnals, prayer books, and textbooks to church or religious organization |
| PB100817 | Comic Books |
| PB100818 | Puzzle Books |
| PB100819 | Coupon or Discount Book |

**Why the broader code was chosen:** ECCHO Rules Books are professional/technical publications. PB100200 ("other") could be considered, but it has no tax treatment advantage over PB100000:both are treated identically by Avalara's tax engine. The remaining subcodes (religious, comic, puzzle, coupon, construction) clearly do not apply.

### PC040100: Clothing (B2C) - general:15 active subcodes

| Subcode | Description |
|---------|-------------|
| PC040101 | Aprons - household |
| PC040103 | Athletic supporters |
| PC040105 | Bandanas |
| PC040106 | Bathing suits and caps |
| PC040108 | Belts and suspenders |
| PC040109 | Bibs |
| PC040110 | Boots |
| PC040120 | Garters and garter belts |
| PC040130 | Hosiery |
| PC040140 | Rainwear |
| PC040150 | Suspenders |
| PC040168 | Aqua Shoes |
| PC041098 | Nursing Bras |
| PC041114 | Receiving Blankets |
| PC041210 | Gloves: Work / Chore / Garden / Jersey |

**Why the broader code was chosen:** the mapped item is "NCP Golf Hat." None of the subcodes covers hats or caps (the B2B taxonomy has PC030129 for "Hats and caps" but the B2C equivalent does not exist as a separate subcode). PC040100 (general B2C clothing) is the correct match.

### SA030000: Advertising Services - No Transfer of TPP:14 active subcodes

| Subcode | Description |
|---------|-------------|
| SA030200 | Public relations |
| SA030300 | Market research and polling |
| SA030400 | Media Placement |
| SA035898 | Advertising Media / Inserts Distributed via Newspaper Insert |
| SA035906 | Advertising Media / Inserts Distributed via Shared Mail Package |
| SA035914 | Advertising Media Inserts Distributed via Solo Mail |
| SA035922 | Advertising Media Inserts Sent Directly to Business Purchaser for Distribution |
| SA035930 | Delivery Charges for Advertising Media Inserts via Newspaper Insert |
| SA035938 | Delivery Charges for Advertising Media Inserts via Shared Mail Package |
| SA035946 | Delivery Charges for Advertising Media Inserts via Solo Mail |
| SA035954 | Delivery Charges for Advertising Media Inserts Sent Directly to Business Purchaser |
| SA036298 | Online Advertising |
| SA037000 | Outdoor Advertising |
| SA038000 | Advertising Agency Services |

**Why the broader code was chosen:** NCP Partnership packages and ECCHO sponsorships provide brand visibility and organizational access:they are not PR (SA030200), market research (SA030300), media placement (SA030400), advertising inserts (SA035xxx), online ads (SA036298), outdoor ads (SA037000), or agency services (SA038000). None of the subcodes describes event/conference sponsorship, so the broader SA030000 is the best match.

### ST080000: Training and Seminar:15 active subcodes

| Subcode | Description |
|---------|-------------|
| ST080010 | Online Skill Assessments |
| ST080020 | Simulation Trainings / In-person / Use of basic equipment |
| ST080021 | Simulation Trainings / Online / Use of computer software |
| ST080030 | Exam Preparation & Tutoring / Online / Interactive |
| ST080031 | Exam Preparation & Tutoring / Online / Non-interactive, on-demand |
| ST080032 | Exam Preparation & Tutoring / In-person |
| ST087630 | Training / Webinar Only / SaaS Platform / Live, Non-Subscription |
| ST087631 | Training / Webinar / SaaS Platform / Live, Non-Subscription and Materials (Electronic) / Lump Sum |
| ST087632 | Training / Webinar / SaaS Platform / Live, Non-Subscription and Materials (Tangible) / Lump Sum |
| ST087634 | Online Training |
| ST087640 | Training / Webinar Only / SaaS Platform / Pre-recorded, Non-Subscription |
| ST087641 | Training / Webinar / SaaS Platform / Pre-recorded, Non-Subscription and Materials (Electronic) / Lump Sum |
| ST087642 | Training / Webinar / SaaS Platform / Pre-recorded, Non-Subscription and Materials (Tangible) / Lump Sum |
| ST087650 | Training / Webinar / SaaS Platform / Subscription / No download |
| ST087651 | Training / Webinar / SaaS Platform / Subscription / Download of course or course materials |

**Why the broader code was chosen:** ST080000 is used only for 2 items: "5 for 4 NCP Workshop Bundle" and "NCP Session Application Fee." These are in-person workshop items that are not simulations (ST080020), not tutoring (ST080032), not online (ST087634), and not webinars (ST087630/ST087640). The general in-person training code is the correct fit. Note that 4 of ST080000's subcodes (ST080010, ST087634, ST087640, ST087650) are already used in this mapping for other product categories where they are a better match.
