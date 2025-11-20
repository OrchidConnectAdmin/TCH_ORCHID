/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MemberDirectoryController {
    global static Integer FIRST_MAX_RECORDS;
    global MemberDirectoryController() {

    }
    @Deprecated
    @RemoteAction
    global static Boolean checkEmailMeOption(String emailOptionJSONData) {
        return null;
    }
    @RemoteAction
    global static DirectoryApi.MemberDirectoryController.ProfileOptions checkProfileOptions(String emailOptionJSONData) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static DirectoryApi.MemberDirectoryController.DirectoryPage directoryListing(String jsonDataMap) {
        return null;
    }
    @Deprecated
    @ReadOnly
    @RemoteAction
    global static String doSearchDirectory(String jsonDataMap) {
        return null;
    }
    @Deprecated
    @ReadOnly
    @RemoteAction
    global static List<DirectoryApi.MemberDirectoryController.sObjectWrapper> doSearch(String jsonDataMap) {
        return null;
    }
    @Deprecated
    @RemoteAction
    global static String getPageRecords(String paginationJSON) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static DirectoryApi.MemberDirectoryController.PageRecords getRecords(String paginationJSON) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static Set<Id> getRemainingRecordIds(String query) {
        return null;
    }
    @RemoteAction
    global static void sendEmail(String emailJSONData) {

    }
global class BaseQuery {
    global String baseQuery;
    global String orderByField;
    global BaseQuery() {

    }
}
global class DirectoryPage {
    global String iQueryString {
        get;
        set;
    }
    global Integer listSize {
        get;
        set;
    }
    global Integer modifiedPageNum {
        get;
        set;
    }
    global Integer pageSize {
        get;
        set;
    }
    global String queryOrder {
        get;
        set;
    }
    global String queryString {
        get;
        set;
    }
    global Set<Id> sObjIds {
        get;
        set;
    }
    global List<DirectoryApi.MemberDirectoryController.sObjectWrapper> sObjs;
    global Integer totalRecords {
        get;
        set;
    }
    global DirectoryPage() {

    }
}
global class PageRecords {
    global List<SObject> records;
    global PageRecords(List<SObject> recs) {

    }
}
global class ProfileOptions {
    global SObject currentRecord;
    global Boolean EmailMe;
    global Boolean ProfileLink;
    global User usr;
    global ProfileOptions() {

    }
}
global class SObjectFieldLabelMap {
    global String badgeTypeandCriteriaFilter;
    global String baseQuery;
    global Map<String,String> fieldLabelMap;
    global Map<String,String> fieldMap;
    global Map<String,String> fieldTypeMap;
    global String iQuery;
    global String orderByField;
    global SObjectFieldLabelMap() {

    }
}
global class sObjectWrapper {
    global SObject ct;
    global sObjectWrapper() {

    }
}
}
