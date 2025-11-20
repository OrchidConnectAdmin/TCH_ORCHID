/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/CatalogService/*')
global virtual class CatalogService extends FDService.ServiceBase implements FDService.ICatalogService {
    global CatalogService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    @Deprecated
    global FDService.Catalog getCatalog(Id catalogId, Id contactId) {
        return null;
    }
    @Deprecated
    global List<FDService.Item> getCatalogItems(Set<Id> catalogIds, Id contactId) {
        return null;
    }
    @Deprecated
    global List<FDService.Catalog> getCatalogs(Id storeId, Id contactId) {
        return null;
    }
    global static FDService.CatalogService getInstance() {
        return null;
    }
    global static FDService.CatalogService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.Catalog> get(FDService.SearchRequest sr) {
        return null;
    }
}
