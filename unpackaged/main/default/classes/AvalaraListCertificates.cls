/**
 * Data transfer objects for the Avalara ListCertificatesForCustomer API operation.
 * Contains the Response inner classes that represent the API response payload.
 */
public with sharing class AvalaraListCertificates {

    public class Response {
        public Integer recordsetCount;
        public List<Certificate> certificates;
    }

    public class Certificate {
        public Integer id;
        public String status;
        public String signedDate;
        public String expirationDate;
        public String exposureZoneName;
        public String exemptionReasonName;
    }
}
