/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/ContactService/*')
global virtual class ContactService extends FDService.ServiceBase implements FDService.IContactService {
    global ContactService() {

    }
    global virtual Contact create(Contact con) {
        return null;
    }
    @HttpGet
    global static void get() {

    }
    global static FDService.ContactService getInstance() {
        return null;
    }
    global static FDService.ContactService getInstance(String version) {
        return null;
    }
    global virtual List<Contact> get(FDService.SearchRequest sr) {
        return null;
    }
}
