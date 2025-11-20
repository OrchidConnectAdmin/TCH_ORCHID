/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IAccessPermissionService {
    Boolean hasAccess(SObject param0);
    Map<Id,Set<Id>> hasAccessByContacts(List<SObject> param0);
    List<SObject> hasAccess(List<SObject> param0);
    void setCustomerId(Id param0);
    void setCustomerIds(Set<Id> param0);
}
