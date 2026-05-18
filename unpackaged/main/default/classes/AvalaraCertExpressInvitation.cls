/**
 * Data transfer objects for the Avalara CreateCertExpressInvitation API operation.
 * Contains the Request and Response inner classes that represent
 * the API payload structures for generating CertExpress portal links.
*/
public with sharing class AvalaraCertExpressInvitation {

    /**
     * Request payload for the CreateCertExpressInvitation API.
     * Generates a CertExpress portal URL where the customer can upload exemption certificates.
    */
    public class Request {
        /** Recipient email address for the invitation*/
        public String recipient;
        /** Cover letter template name (e.g., 'STANDARD_REQUEST')*/
        public String coverLetterTitle;
        /** Delivery method: 'Email' (Avalara sends) or 'Download' (returns URL only)*/
        public String deliveryMethod;
    }

    /**
     * Response payload from the CreateCertExpressInvitation API.
     * Contains the generated CertExpress portal URL for the customer.
    */
    public class Response {
        /** Avalara internal invitation ID*/
        public Integer id;
        /** Company ID echoed back*/
        public Integer companyId;
        /** Customer code echoed back*/
        public String customerCode;
        /** CertExpress portal URL to redirect the customer to*/
        public String requestLink;
        /** Invitation status*/
        public String status;
    }
}
