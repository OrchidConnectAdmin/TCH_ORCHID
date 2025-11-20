/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/ShippingService/*')
global virtual class ShippingService extends FDService.ServiceBase implements FDService.IShippingService {
    global ShippingService() {

    }
    global static FDService.ShippingService getInstance() {
        return null;
    }
    global static FDService.ShippingService getInstance(String version) {
        return null;
    }
    global virtual Map<Id,List<FDService.Item>> getRatesForLines(FDService.SalesOrder so) {
        return null;
    }
    global FDService.ShippingService getSuper() {
        return null;
    }
}
