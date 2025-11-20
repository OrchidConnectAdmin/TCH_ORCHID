/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/BusinessGroupService/*')
global virtual class BusinessGroupService extends FDService.ServiceBase implements FDService.IBusinessGroupService {
    global BusinessGroupService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.BusinessGroupService getInstance() {
        return null;
    }
    global static FDService.BusinessGroupService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.BusinessGroup> get(FDService.SearchRequest sr) {
        return null;
    }
    @Deprecated
    global virtual void uncheckShippingOrderByTotal() {

    }
}
