/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IOrderService {
    FDService.SalesOrderLine addItemToOrder(FDService.SalesOrderLine param0);
    List<FDService.SalesOrderLine> addItemsToOrder(List<FDService.SalesOrderLine> param0);
    FDService.SalesOrder createOrder(FDService.SalesOrder param0);
    void deleteItemFromOrder(Id param0);
    void deleteItemsFromOrder(Set<Id> param0);
    void deleteSalesOrder(Set<Id> param0);
    FDService.SalesOrder getSalesOrder(Id param0);
    List<FDService.SalesOrder> get(FDService.SearchRequest param0);
    FDService.SalesOrderLine updateItemInOrder(FDService.SalesOrderLine param0);
    List<FDService.SalesOrderLine> updateItemsInOrder(List<FDService.SalesOrderLine> param0);
}
