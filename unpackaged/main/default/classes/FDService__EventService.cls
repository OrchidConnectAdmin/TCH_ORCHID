/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/EventService/*')
global virtual class EventService extends FDService.ServiceBase implements FDService.IEventService {
    global EventService() {

    }
    @Deprecated
    global List<FDService.Event> getAllEvents(Id contactId) {
        return null;
    }
    @HttpGet
    global static void getApiResponse() {

    }
    @Deprecated
    global FDService.Event getEvent(Id eventId) {
        return null;
    }
    @Deprecated
    global List<FDService.Event> getEventsWithChatterGroup(String groupId, Id contactId) {
        return null;
    }
    global static FDService.EventService getInstance() {
        return null;
    }
    global static FDService.EventService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.Event> get(FDService.SearchRequest sr) {
        return null;
    }
}
