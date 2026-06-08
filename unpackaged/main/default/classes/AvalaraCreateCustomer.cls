/**
 * Data transfer objects for the Avalara CreateCustomers API operation.
 * Contains the Request and Response inner classes that represent
 * the API payload structures for customer registration in ECM.
*/
public with sharing class AvalaraCreateCustomer {

    /**
     * Request payload for the CreateCustomers API.
     * Registers a customer in Avalara's ECM so certificates can be linked to them.
    */
    public class Request {
        /** Unique customer identifier (must match customerCode used in CreateTransaction) */
        public String customerCode;
        /** Customer display name */
        public String name;
        /** Street address line 1 */
        public String line1;
        /** City name */
        public String city;
        /** State or region code (e.g., 'NY') */
        public String region;
        /** Postal/ZIP code */
        public String postalCode;
        /** Country ISO 2-character code (e.g., 'US') */
        public String country;
        /** Email address (used for CertExpress invitations) */
        public String emailAddress;
    }

    /**
     * Response payload from the CreateCustomers API.
     * Echoes back the created customer data with the Avalara-assigned ID.
    */
    public class Response {
        /** Avalara internal customer ID (int64 — can exceed Integer range) */
        public Long id;
        /** Customer code echoed back */
        public String customerCode;
        /** Customer name echoed back */
        public String name;
        /** Email address echoed back */
        public String emailAddress;
        /** Street address line 1 */
        public String line1;
        /** City name */
        public String city;
        /** State or region code */
        public String region;
        /** Postal/ZIP code */
        public String postalCode;
        /** Country code */
        public String country;
    }
}
