@RestResource(urlMapping='/ecchoContacts/*')
global with sharing class EcchoContactExportService {

    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        System.debug('Received afterDate param: ' + req.params.get('afterDate'));
        System.debug('Received afterId param: ' + req.params.get('afterId'));

        if (req.requestURI.toLowerCase().endsWith('/count')) {
            Integer count = [
                SELECT COUNT() FROM Contact
                WHERE Contact_is_Inactive__c = FALSE AND Email <> null AND (
                    Corp_SF_Tag_Sponsoring_Organization__c = TRUE OR
                    Corp_SF_Tag_Full_Member__c = TRUE OR
                    Corp_SF_Tag_Sponsored_Member__c = TRUE OR
                    Corp_SF_Tag_Corporate_EduSub__c = TRUE OR
                    Corp_SF_Tag_Rules_User__c = TRUE OR
                    Corp_SF_Tag_Associate_Member__c = TRUE OR
                    Corp_SF_Tag_Participating_Member__c = TRUE OR
                    Corp_SF_Tag_Affiliate_Member__c = TRUE OR
                    Corp_SF_Tag_Licensing_Organization__c = TRUE OR
                    Corp_SF_Tag_Active_NCP__c = TRUE OR
                    Corp_SF_Tag_Individual_EduSub__c = TRUE
                )
            ];
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, Integer>{ 'total' => count }));
            res.statusCode = 200;
            return;
        }

        Integer pageSize = req.params.containsKey('pagesize') ? Integer.valueOf(req.params.get('pagesize')) : 500;
        Datetime afterDate;
        String afterId = req.params.containsKey('afterId') ? req.params.get('afterId') : null;

        try {
            if (req.params.containsKey('afterDate')) {
                afterDate = Datetime.valueOf(req.params.get('afterDate'));
            }
        } catch (Exception e) {
            System.debug('ERROR parsing afterDate: ' + e.getMessage());
        }

        String baseFilter = 'Contact_is_Inactive__c = FALSE AND Email <> null AND (' +
            'Corp_SF_Tag_Sponsoring_Organization__c = TRUE OR ' +
            'Corp_SF_Tag_Full_Member__c = TRUE OR ' +
            'Corp_SF_Tag_Sponsored_Member__c = TRUE OR ' +
            'Corp_SF_Tag_Corporate_EduSub__c = TRUE OR ' +
            'Corp_SF_Tag_Rules_User__c = TRUE OR ' +
            'Corp_SF_Tag_Associate_Member__c = TRUE OR ' +
            'Corp_SF_Tag_Participating_Member__c = TRUE OR ' +
            'Corp_SF_Tag_Affiliate_Member__c = TRUE OR ' +
            'Corp_SF_Tag_Licensing_Organization__c = TRUE OR ' +
            'Corp_SF_Tag_Active_NCP__c = TRUE OR ' +
            'Corp_SF_Tag_Individual_EduSub__c = TRUE)';

        String whereClause = baseFilter;
        if (afterDate != null && afterId != null) {
            String dateStr = afterDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
            String idStr = '\'' + afterId + '\'';
            whereClause += ' AND (LastModifiedDate > ' + dateStr + ' OR (LastModifiedDate = ' + dateStr + ' AND Id > ' + idStr + '))';
        }

        String soql = 'SELECT Id, FirstName, LastName, Email, AccountId, Account.Name, ' +
            'Contact_is_Inactive__c, Corp_SF_Tag_Sponsoring_Organization__c, ' +
            'Corp_SF_Tag_Full_Member__c, Corp_SF_Tag_Sponsored_Member__c, ' +
            'Corp_SF_Tag_Corporate_EduSub__c, Corp_SF_Tag_Rules_User__c, ' +
            'Corp_SF_Tag_Associate_Member__c, Corp_SF_Tag_Participating_Member__c, ' +
            'Corp_SF_Tag_Affiliate_Member__c, Corp_SF_Tag_Licensing_Organization__c, ' +
            'Corp_SF_Tag_Active_NCP__c, Corp_SF_Tag_Individual_EduSub__c, LastModifiedDate ' +
            'FROM Contact WHERE ' + whereClause +
            ' ORDER BY LastModifiedDate ASC, Id ASC LIMIT ' + pageSize;

        List<Contact> contacts = Database.query(soql);

        List<Map<String, Object>> results = new List<Map<String, Object>>();
        for (Contact c : contacts) {
            results.add(new Map<String, Object>{
                'Id' => c.Id,
                'FirstName' => c.FirstName,
                'LastName' => c.LastName,
                'Email' => c.Email,
                'AccountId' => c.AccountId,
                'AccountName' => (c.Account != null) ? c.Account.Name : null,
                'ContactIsInactive' => c.Contact_is_Inactive__c,
                'Corp_SF_Tag_Sponsoring_Organization' => c.Corp_SF_Tag_Sponsoring_Organization__c,
                'Corp_SF_Tag_Full_Member' => c.Corp_SF_Tag_Full_Member__c,
                'Corp_SF_Tag_Sponsored_Member' => c.Corp_SF_Tag_Sponsored_Member__c,
                'Corp_SF_Tag_Corporate_EduSub' => c.Corp_SF_Tag_Corporate_EduSub__c,
                'Corp_SF_Tag_Rules_User' => c.Corp_SF_Tag_Rules_User__c,
                'Corp_SF_Tag_Associate_Member' => c.Corp_SF_Tag_Associate_Member__c,
                'Corp_SF_Tag_Participating_Member' => c.Corp_SF_Tag_Participating_Member__c,
                'Corp_SF_Tag_Affiliate_Member' => c.Corp_SF_Tag_Affiliate_Member__c,
                'Corp_SF_Tag_Licensing_Organization' => c.Corp_SF_Tag_Licensing_Organization__c,
                'Corp_SF_Tag_Active_NCP' => c.Corp_SF_Tag_Active_NCP__c,
                'Corp_SF_Tag_Individual_EduSub' => c.Corp_SF_Tag_Individual_EduSub__c,
                'LastModifiedDate' => c.LastModifiedDate
            });
        }

        res.responseBody = Blob.valueOf(JSON.serialize(results));
        res.statusCode = 200;
    }
}