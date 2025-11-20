/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GroupsController extends PagesApi.BaseController {
    @RemoteAction
    global static List<PagesApi.GroupsController.CommunityGroupWrapper> doSearch(PagesApi.GroupsController.GroupsConfig configs, List<PagesApi.GroupsController.SearchFilters> filters, String searchString) {
        return null;
    }
global class CommunityGroupWrapper {
    global PagesApi__Community_Group__c cgroup;
    global Integer groupCount;
    global Boolean isMyGroup;
    global Boolean isPrivate;
    global String type;
    global CommunityGroupWrapper() {

    }
}
global class GroupsConfig extends PagesApi.Base {
    global GroupsConfig() {

    }
}
global class SearchFilters {
    global SearchFilters() {

    }
}
}
