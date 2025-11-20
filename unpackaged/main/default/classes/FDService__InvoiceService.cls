/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/InvoiceService/*')
global virtual class InvoiceService extends FDService.ServiceBase implements FDService.IInvoiceService {
    global InvoiceService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.InvoiceService getInstance() {
        return null;
    }
    global static FDService.InvoiceService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.Invoice> get(FDService.SearchRequest sr) {
        return null;
    }
}
