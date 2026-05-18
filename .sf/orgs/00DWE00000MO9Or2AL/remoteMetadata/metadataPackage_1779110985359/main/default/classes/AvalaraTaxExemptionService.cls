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

    public class ExemptionInfo {
        @AuraEnabled public String contactId;
        @AuraEnabled public String accountId;
        @AuraEnabled public List<AddressOption> addressOptions;
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

        ExemptionInfo info = new ExemptionInfo();
        info.contactId = ct.Id;
        info.accountId = ct.AccountId;
        info.addressOptions = buildAddressOptions(ct);

        return info;
    }

    @AuraEnabled
    public static RegistrationResult registerAndInvite(String name, String street, String city, String state, String postalCode, String country, String email) {
        RegistrationResult result = new RegistrationResult();

        try {
            Avalara_Config__mdt config = queryActiveConfig();
            String companyId = config.Company_Id__c;
            String customerCode = resolveCustomerCode();

            createCustomer(companyId, customerCode, name, street, city, state, postalCode, country, email);
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

    private static void createCustomer(String companyId, String customerCode, String name, String street, String city, String state, String postalCode, String country, String email) {
        AvalaraCreateCustomer.Request customerRequest = new AvalaraCreateCustomer.Request();
        customerRequest.customerCode = customerCode;
        customerRequest.name = name;
        customerRequest.line1 = street;
        customerRequest.city = city;
        customerRequest.region = state;
        customerRequest.postalCode = postalCode;
        customerRequest.country = country;
        customerRequest.emailAddress = email;

        AvalaraCreateCustomerService.execute(customerRequest, companyId);
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

    private static String resolveCustomerCode() {
        User currentUser = queryCurrentUser();
        Contact ct = queryContact(currentUser.ContactId);

        if (ct.AccountId != null) {
            return ct.AccountId;
        }
        return ct.Id;
    }

    private static List<AddressOption> buildAddressOptions(Contact ct) {
        List<AddressOption> options = new List<AddressOption>();

        if (ct.AccountId != null) {
            Account acc = queryAccount(ct.AccountId);
            if (hasAddress(acc.ShippingStreet, acc.ShippingCity, acc.ShippingStateCode)) {
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

    private static Account queryAccount(Id accountId) {
        return [
            SELECT Name, ShippingStreet, ShippingCity, ShippingStateCode, ShippingPostalCode, ShippingCountryCode
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