/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/OrderStatusService/*')
global virtual class OrderStatusService extends FDService.ServiceBase implements FDService.IOrderStatusService {
    global OrderStatusService() {

    }
    global static FDService.OrderStatusService getInstance() {
        return null;
    }
    global static FDService.OrderStatusService getInstance(String version) {
        return null;
    }
    @HttpPost
    global static void postApiResponse() {

    }
    global virtual List<FDService.SalesOrder> readyOrderForPayment(List<FDService.SalesOrder> salesOrders) {
        return null;
    }
}
