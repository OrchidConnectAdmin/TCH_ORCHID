/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FeedController extends PagesApi.BaseController {
    @RemoteAction
    global static ConnectApi.CommentPage getCommentsForFeedElement(String feedElementId, String pageToken) {
        return null;
    }
    @RemoteAction
    global static ConnectApi.FeedElementPage getFeedData(String groupId, String pageToken) {
        return null;
    }
    @RemoteAction
    global static List<User> getUsers(String searchString) {
        return null;
    }
    @RemoteAction
    global static ConnectApi.ChatterLike likeElement(String subjectId, String subjectType) {
        return null;
    }
    @RemoteAction
    global static ConnectApi.Comment postCommentData(String groupId, String feedElementId, String textInput) {
        return null;
    }
    @RemoteAction
    global static ConnectApi.FeedElement postFeedData(String groupId, String textInput) {
        return null;
    }
    @RemoteAction
    global static ConnectApi.FeedElement postFeedDataWithFile(String groupId, String textInput, Blob fileInput, String fileType, String fileName) {
        return null;
    }
    @RemoteAction
    global static void unlikeFeedItem(String likeId) {

    }
global class FeedConfig extends PagesApi.Base {
    global FeedConfig() {

    }
}
}
