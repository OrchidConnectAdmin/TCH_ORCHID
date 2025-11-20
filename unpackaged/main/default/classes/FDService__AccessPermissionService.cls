/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class AccessPermissionService extends FDService.ServiceBase implements FDService.IAccessPermissionService {
    global AccessPermissionService() {

    }
    global static FDService.AccessPermissionService getInstance() {
        return null;
    }
    global static FDService.AccessPermissionService getInstance(String version) {
        return null;
    }
    global virtual Boolean hasAccess(SObject sObj) {
        return null;
    }
    global virtual Map<Id,Set<Id>> hasAccessByContacts(List<SObject> sObjs) {
        return null;
    }
    global virtual List<SObject> hasAccess(List<SObject> sObjs) {
        return null;
    }
    global virtual void setCustomerId(Id customerId) {

    }
    global virtual void setCustomerIds(Set<Id> customerIds) {

    }
}
