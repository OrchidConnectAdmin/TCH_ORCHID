/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/PackageItemService/*')
global virtual class PackageItemService extends FDService.ServiceBase implements FDService.IPackageItemService {
    global PackageItemService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.PackageItemService getInstance() {
        return null;
    }
    global static FDService.PackageItemService getInstance(String version) {
        return null;
    }
    @Deprecated
    global List<FDService.PackageItem> getPackageItems(Set<Id> itemIds) {
        return null;
    }
    global virtual List<FDService.PackageItem> get(FDService.SearchRequest sr) {
        return null;
    }
}
