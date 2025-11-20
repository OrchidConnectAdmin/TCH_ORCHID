/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/ItemService/*')
global virtual class ItemService extends FDService.ServiceBase implements FDService.IItemService {
    global ItemService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.ItemService getInstance() {
        return null;
    }
    global static FDService.ItemService getInstance(String version) {
        return null;
    }
    global virtual FDService.Item getItem(Id itemId, Id contactId) {
        return null;
    }
    global virtual FDService.Item getItem(Id itemId, Id contactId, Boolean getPackageItems) {
        return null;
    }
    global virtual FDService.Item getItem(Id itemId, Id contactId, Boolean getPackageItems, Boolean translate) {
        return null;
    }
    global virtual List<FDService.Item> getItems(Set<Id> itemIds, Id contactId) {
        return null;
    }
    global virtual List<FDService.Item> getItems(Set<Id> itemIds, Id contactId, Boolean getPriceRules, Boolean getSubscriptionPlans, Boolean getPackageItems) {
        return null;
    }
    global virtual List<FDService.Item> getItems(Set<Id> itemIds, Id contactId, Boolean getPriceRules, Boolean getSubscriptionPlans, Boolean getPackageItems, Boolean translate) {
        return null;
    }
    global virtual List<FDService.Item> getItems(Set<Id> itemIds, Id contactId, Boolean getPriceRules, Boolean getSubscriptionPlans, Boolean getPackageItems, Boolean translate, Boolean getItemAttributes) {
        return null;
    }
    global virtual List<FDService.Item> get(FDService.SearchRequest sr) {
        return null;
    }
}
