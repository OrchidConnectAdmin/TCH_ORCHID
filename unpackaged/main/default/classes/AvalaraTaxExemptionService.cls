/**
 * AuraEnabled controller for the avalaraTaxExemption LWC.
 * Resolves the logged-in user's Contact/Account, provides address options,
 * and orchestrates CreateCustomers + CreateCertExpressInvitation callouts.
 */
public without sharing class AvalaraTaxExemptionService {

    public class AddressOption {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        @AuraEnabled public String street;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String postalCode;
        @AuraEnabled public String country;
    }

    public class CertificateInfo {
        @AuraEnabled public Integer id;
        @AuraEnabled public String status;
        @AuraEnabled public String signedDate;
        @AuraEnabled public String expirationDate;
        @AuraEnabled public String exposureZone;
        @AuraEnabled public String exemptionReason;
    }

    public class ExemptionInfo {
        @AuraEnabled public String contactId;
        @AuraEnabled public String accountId;
        @AuraEnabled public Boolean isRegistered;
        @AuraEnabled public String customerEmail;
        @AuraEnabled public List<AddressOption> addressOptions;
        @AuraEnabled public List<CertificateInfo> certificates;
    }

    public class RegistrationResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String certExpressUrl;
        @AuraEnabled public String errorMessage;
    }

    @AuraEnabled
    public static ExemptionInfo getExemptionInfo() {
        User currentUser = queryCurrentUser();
        Contact ct = queryContact(currentUser.ContactId);
        Account acc = (ct.AccountId != null) ? queryAccountFull(ct.AccountId) : null;

        ExemptionInfo info = new ExemptionInfo();
        info.contactId = ct.Id;
        info.accountId = ct.AccountId;
        info.isRegistered = (acc != null && String.isNotBlank(acc.Avalara_Customer_Id__c));
        info.customerEmail = ct.Email;
        info.addressOptions = buildAddressOptions(ct, acc);
        info.certificates = new List<CertificateInfo>();

        if (info.isRegistered) {
            info.certificates = loadCertificates(ct);
        }

        return info;
    }

    @AuraEnabled
    public static RegistrationResult registerAndInvite(String name, String street, String city, String state, String postalCode, String country, String email) {
        RegistrationResult result = new RegistrationResult();

        try {
            Avalara_Config__mdt config = queryActiveConfig();
            String companyId = config.Company_Id__c;

            User currentUser = queryCurrentUser();
            Contact ct = queryContact(currentUser.ContactId);
            Account acc = (ct.AccountId != null) ? queryAccountWithAvalaraId(ct.AccountId) : null;
            String customerCode = (ct.AccountId != null) ? ct.AccountId : ct.Id;

            String avalaraCustomerId = null;
            if (acc == null || String.isBlank(acc.Avalara_Customer_Id__c)) {
                AvalaraCreateCustomer.Response customerResponse = createCustomer(
                    companyId, customerCode, name, street, city, state, postalCode, country, email
                );
                avalaraCustomerId = String.valueOf(customerResponse.id);
            }

            String certExpressUrl = createInvitation(companyId, customerCode, email);

            if (avalaraCustomerId != null && acc != null) {
                update new Account(Id = acc.Id, Avalara_Customer_Id__c = avalaraCustomerId);
            }

            result.success = true;
            result.certExpressUrl = certExpressUrl;
        } catch (Exception e) {
            result.success = false;
            result.errorMessage = e.getMessage();
        }

        return result;
    }

    @AuraEnabled
    public static RegistrationResult requestNewExemption(String email) {
        RegistrationResult result = new RegistrationResult();

        try {
            Avalara_Config__mdt config = queryActiveConfig();
            String companyId = config.Company_Id__c;

            User currentUser = queryCurrentUser();
            Contact ct = queryContact(currentUser.ContactId);
            String customerCode = (ct.AccountId != null) ? ct.AccountId : ct.Id;

            String certExpressUrl = createInvitation(companyId, customerCode, email);

            result.success = true;
            result.certExpressUrl = certExpressUrl;
        } catch (Exception e) {
            result.success = false;
            result.errorMessage = e.getMessage();
        }

        return result;
    }

    // ─── Private Helpers ───

    private static List<CertificateInfo> loadCertificates(Contact ct) {
        List<CertificateInfo> certificates = new List<CertificateInfo>();

        try {
            Avalara_Config__mdt config = queryActiveConfig();
            String companyId = config.Company_Id__c;
            String customerCode = (ct.AccountId != null) ? ct.AccountId : ct.Id;

            AvalaraListCertificates.Response certResponse = AvalaraListCertificatesService.execute(companyId, customerCode);

            for (AvalaraListCertificates.Certificate cert : certResponse.certificates) {
                CertificateInfo info = new CertificateInfo();
                info.id = cert.id;
                info.status = cert.status;
                info.signedDate = cert.signedDate;
                info.expirationDate = cert.expirationDate;
                info.exposureZone = cert.exposureZoneName;
                info.exemptionReason = cert.exemptionReasonName;
                certificates.add(info);
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Failed to load certificates: ' + e.getMessage());
        }

        return certificates;
    }

    private static AvalaraCreateCustomer.Response createCustomer(String companyId, String customerCode, String name, String street, String city, String state, String postalCode, String country, String email) {
        AvalaraCreateCustomer.Request customerRequest = new AvalaraCreateCustomer.Request();
        customerRequest.customerCode = customerCode;
        customerRequest.name = name;
        customerRequest.line1 = street;
        customerRequest.city = city;
        customerRequest.region = state;
        customerRequest.postalCode = postalCode;
        customerRequest.country = country;
        customerRequest.emailAddress = email;

        return AvalaraCreateCustomerService.execute(customerRequest, companyId);
    }

    private static String createInvitation(String companyId, String customerCode, String email) {
        AvalaraCertExpressInvitation.Request invitationRequest = new AvalaraCertExpressInvitation.Request();
        invitationRequest.recipient = email;
        invitationRequest.coverLetterTitle = 'STANDARD_REQUEST';
        invitationRequest.deliveryMethod = 'Download';

        AvalaraCertExpressInvitation.Response response = AvalaraCertExpressInvitationService.execute(
            invitationRequest, companyId, customerCode
        );

        return response.requestLink;
    }

    private static List<AddressOption> buildAddressOptions(Contact ct, Account acc) {
        List<AddressOption> options = new List<AddressOption>();

        if (acc != null && hasAddress(acc.ShippingStreet, acc.ShippingCity, acc.ShippingStateCode)) {
            AddressOption accountOption = new AddressOption();
            accountOption.label = 'Organization Address (Account)';
            accountOption.value = 'account';
            accountOption.name = acc.Name;
            accountOption.email = ct.Email;
            accountOption.street = acc.ShippingStreet;
            accountOption.city = acc.ShippingCity;
            accountOption.state = acc.ShippingStateCode;
            accountOption.postalCode = acc.ShippingPostalCode;
            accountOption.country = acc.ShippingCountryCode;
            options.add(accountOption);
        }

        if (hasAddress(ct.MailingStreet, ct.MailingCity, ct.MailingStateCode)) {
            AddressOption contactOption = new AddressOption();
            contactOption.label = 'My Address (Contact)';
            contactOption.value = 'contact';
            contactOption.name = ct.FirstName + ' ' + ct.LastName;
            contactOption.email = ct.Email;
            contactOption.street = ct.MailingStreet;
            contactOption.city = ct.MailingCity;
            contactOption.state = ct.MailingStateCode;
            contactOption.postalCode = ct.MailingPostalCode;
            contactOption.country = ct.MailingCountryCode;
            options.add(contactOption);
        }

        return options;
    }

    private static Boolean hasAddress(String street, String city, String state) {
        return String.isNotBlank(street) && String.isNotBlank(city) && String.isNotBlank(state);
    }

    private static User queryCurrentUser() {
        return [
            SELECT ContactId
            FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH SYSTEM_MODE
            LIMIT 1
        ];
    }

    private static Contact queryContact(Id contactId) {
        if (contactId == null) {
            throw new AvalaraAuthProviderService.AvalaraException('No Contact linked to the current user.');
        }

        return [
            SELECT Id, FirstName, LastName, Email, AccountId,
                   MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, MailingCountryCode
            FROM Contact
            WHERE Id = :contactId
            WITH SYSTEM_MODE
        ];
    }

    private static Account queryAccountFull(Id accountId) {
        return [
            SELECT Id, Name, Avalara_Customer_Id__c,
                   ShippingStreet, ShippingCity, ShippingStateCode, ShippingPostalCode, ShippingCountryCode
            FROM Account
            WHERE Id = :accountId
            WITH SYSTEM_MODE
        ];
    }

    private static Account queryAccountWithAvalaraId(Id accountId) {
        return [
            SELECT Id, Avalara_Customer_Id__c
            FROM Account
            WHERE Id = :accountId
            WITH SYSTEM_MODE
        ];
    }

    private static Avalara_Config__mdt queryActiveConfig() {
        List<Avalara_Config__mdt> configs = [
            SELECT Company_Id__c
            FROM Avalara_Config__mdt
            WHERE Is_Active__c = true
            WITH SYSTEM_MODE
            LIMIT 1
        ];

        if (configs.isEmpty()) {
            throw new AvalaraAuthProviderService.AvalaraException('No active Avalara_Config__mdt record found.');
        }

        if (String.isBlank(configs[0].Company_Id__c)) {
            throw new AvalaraAuthProviderService.AvalaraException('Company_Id__c is not configured in Avalara_Config__mdt.');
        }

        return configs[0];
    }
}
