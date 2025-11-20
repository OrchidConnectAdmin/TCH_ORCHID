public with sharing class FON_DynamicSearchController {
    @AuraEnabled
    public static List<SObject> getSearchResults(String objectName, String searchValue, String searchField,
        String additionalWhereClause, String fieldsToQuery
    ) {
        System.debug('fieldsToQuery ' + fieldsToQuery);
        searchValue = '%' + searchValue + '%';

        String query = 'SELECT ' + fieldsToQuery + ' FROM ' + objectName + ' WHERE ' + searchField;
        query += ' LIKE :searchValue ' + additionalWhereClause + ' ORDER BY ' + searchField + ' ASC LIMIT 10';

        System.debug('query ' + query);
        
        List<SObject> sObjects = Database.query(query);

        return sObjects;
    }
}