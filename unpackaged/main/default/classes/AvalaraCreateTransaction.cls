/**
 * Data transfer objects for the Avalara CreateTransaction API operation.
 * Contains the Request and Response inner classes that represent
 * the API payload structures for tax calculation.
 */
public with sharing class AvalaraCreateTransaction {

    /**
     * Request payload for the CreateTransaction API.
     * Represents the CreateTransactionModel sent to Avalara for tax calculation.
     */
    public class Request {
        /** Company identifier in Avalara (from Avalara_Config__mdt) */
        public String companyCode;
        /** Document type: 'SalesOrder' (temporary estimate) or 'SalesInvoice' (permanent) */
        public String type;
        /** Transaction date in yyyy-MM-dd format */
        public String transactionDate;
        /** Unique customer identifier (Account.Id or Contact.Id) */
        public String customerCode;
        /** ISO currency code (e.g., 'USD') */
        public String currencyCode;
        /** If true, commits the transaction automatically (for SalesInvoice) */
        public Boolean commitTransaction;
        /** Exemption certificate number (if applicable) */
        public String exemptionNo;
        /** Entity/Use Code for exemptions (e.g., 'A' = Federal Gov) */
        public String customerUsageType;
        /** Ship-from address (tax origin) */
        public Address shipFromAddress;
        /** Ship-to address (tax destination / jurisdiction) */
        public Address shipToAddress;
        /** Transaction line items */
        public List<LineItem> lineItems;
    }

    /**
     * Address used in the addresses object (shipFrom / shipTo).
     */
    public class Address {
        /** Street address line 1 */
        public String line1;
        /** Street address line 2 */
        public String line2;
        /** City name */
        public String city;
        /** State or region code (e.g., 'CA', 'NY') */
        public String region;
        /** Postal/ZIP code */
        public String postalCode;
        /** Country ISO 2-character code (e.g., 'US') */
        public String country;
    }

    /**
     * Line item in the transaction request (maps to a Fonteva Sales Order Line).
     */
    public class LineItem {
        /** Line number identifier (index or Sales_Order_Line__c.Id) */
        public String number_x;
        /** Quantity of the item */
        public Decimal quantity;
        /** Total amount for the line (Sale_Price * Quantity or Total) */
        public Decimal amount;
        /** Product code (Item Name or ProductCode) */
        public String itemCode;
        /** Avalara tax code (e.g., 'P0000000', 'SW054000', 'NT') */
        public String taxCode;
        /** Product description */
        public String description;
    }

    /**
     * Response payload from the CreateTransaction API.
     * Represents the TransactionModel returned by Avalara after tax calculation.
     */
    public class Response {
        /** Avalara numeric transaction ID */
        public Long id;
        /** Unique transaction code (used for commit/void) */
        public String code;
        /** Company code echoed back */
        public String companyCode;
        /** Transaction date echoed back */
        public String date_x;
        /** Transaction status: 'Temporary', 'Saved', 'Committed', 'Cancelled' */
        public String status;
        /** Document type echoed back */
        public String type;
        /** Customer code echoed back */
        public String customerCode;
        /** Total tax amount for the transaction */
        public Decimal totalTax;
        /** Total taxable amount */
        public Decimal totalTaxable;
        /** Total amount including tax */
        public Decimal totalAmount;
        /** Total exempt amount */
        public Decimal totalExempt;
        /** Total discount applied */
        public Decimal totalDiscount;
        /** Response line items with tax details */
        public List<ResponseLine> lines;
    }

    /**
     * Line item in the transaction response with calculated tax details.
     */
    public class ResponseLine {
        /** Line number echoed back */
        public String number_x;
        /** Total tax for this line */
        public Decimal tax;
        /** Taxable amount for this line */
        public Decimal taxableAmount;
        /** Calculated tax for this line (same as tax in most cases) */
        public Decimal taxCalculated;
        /** Line amount echoed back */
        public Decimal lineAmount;
        /** Tax rate applied (decimal, e.g., 0.0825 for 8.25%) */
        public Decimal rate;
        /** Item code echoed back */
        public String itemCode;
        /** Tax code used for calculation */
        public String taxCode;
        /** Whether this line is exempt */
        public Boolean isItemTaxable;
        /** Tax detail breakdown by jurisdiction */
        public List<TaxDetail> details;
    }

    /**
     * Tax detail breakdown by jurisdiction for a single line.
     */
    public class TaxDetail {
        /** Jurisdiction name (e.g., 'NEW YORK', 'NEW YORK CITY') */
        public String jurisName;
        /** Jurisdiction type: 'Country', 'State', 'County', 'City', 'Special' */
        public String jurisType;
        /** Tax rate for this jurisdiction */
        public Decimal rate;
        /** Tax amount for this jurisdiction */
        public Decimal tax;
        /** Taxable amount for this jurisdiction */
        public Decimal taxableAmount;
        /** Tax code applied in this jurisdiction */
        public String taxName;
    }
}
