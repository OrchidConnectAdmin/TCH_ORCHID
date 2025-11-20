/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/OrderService/*')
global virtual class OrderService extends FDService.ServiceBase implements FDService.IOrderService {
    global OrderService() {

    }
    global virtual FDService.SalesOrderLine addItemToOrder(FDService.SalesOrderLine sol) {
        return null;
    }
    global virtual List<FDService.SalesOrderLine> addItemsToOrder(List<FDService.SalesOrderLine> sols) {
        return null;
    }
    global virtual FDService.SalesOrder createOrder(FDService.SalesOrder so) {
        return null;
    }
    @HttpPost
    global static void createOrder() {

    }
    global virtual void deleteItemFromOrder(Id idToDelete) {

    }
    global virtual void deleteItemsFromOrder(Set<Id> ids) {

    }
    @HttpDelete
    global static void deleteOrder() {

    }
    global virtual void deleteSalesOrder(Set<Id> ids) {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.OrderService getInstance() {
        return null;
    }
    global static FDService.OrderService getInstance(String version) {
        return null;
    }
    global virtual FDService.SalesOrder getSalesOrder(Id salesOrderId) {
        return null;
    }
    global virtual FDService.OrderService getSuper() {
        return null;
    }
    global virtual List<FDService.SalesOrder> get(FDService.SearchRequest sr) {
        return null;
    }
    global virtual FDService.SalesOrderLine updateItemInOrder(FDService.SalesOrderLine line) {
        return null;
    }
    global virtual List<FDService.SalesOrderLine> updateItemsInOrder(List<FDService.SalesOrderLine> solLines) {
        return null;
    }
    @HttpPut
    global static void updateOrder() {

    }
}
