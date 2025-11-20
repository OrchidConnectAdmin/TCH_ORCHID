/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/VenueService/*')
global virtual class VenueService extends FDService.ServiceBase implements FDService.IVenueService {
    global VenueService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.VenueService getInstance() {
        return null;
    }
    global static FDService.VenueService getInstance(String version) {
        return null;
    }
    @Deprecated
    global Map<Id,List<FDService.Venue>> getVenuesForEvents(Set<Id> eventIds) {
        return null;
    }
    global virtual List<FDService.Venue> get(FDService.SearchRequest sr) {
        return null;
    }
}
