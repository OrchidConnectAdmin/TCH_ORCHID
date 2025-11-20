/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/BadgeService/*')
global virtual class BadgeService extends FDService.ServiceBase implements FDService.IBadgeService {
    global BadgeService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.BadgeService getInstance() {
        return null;
    }
    global static FDService.BadgeService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.Badge> get(FDService.SearchRequest sr) {
        return null;
    }
}
