/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GroupDetailController {
    global PagesApi__Community_Group_Member__c commGroupMemberObj {
        get;
        set;
    }
    @RemoteAction
    global static PagesApi__Community_Group_Member__c addGroupMember(String groupId, String groupMemberId) {
        return null;
    }
    @RemoteAction
    global static PagesApi__Community_Group_Member__c addMember(String groupId) {
        return null;
    }
    @RemoteAction
    global static PagesApi__Community_Group__c getDetail(String groupId) {
        return null;
    }
    @RemoteAction
    global static PagesApi__Community_Group_Member__c getMemberDetail(String groupMemberId) {
        return null;
    }
    @RemoteAction
    global static void removeMember(String groupMemberId) {

    }
    @RemoteAction
    global static List<PagesApi__Community_Group_Member__c> searchMembers(String dataJson) {
        return null;
    }
    @RemoteAction
    global static PagesApi__Community_Group_Member__c updateMember(String dataJson) {
        return null;
    }
    @RemoteAction
    global static String uploadBannerFile(String communityId, String groupId, String commGroupId, Blob file, String fileType, String fileName) {
        return null;
    }
    @RemoteAction
    global static String uploadFile(String communityId, String groupId, String commGroupId, Blob file, String fileType, String fileName) {
        return null;
    }
    @RemoteAction
    global static String uploadProfilePic(String communityId, String groupMemberId, String commGroupMemberId, Blob file, String fileType, String fileName) {
        return null;
    }
}
