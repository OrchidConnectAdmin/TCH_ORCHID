/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ItemCheckoutComponentController {
    @RemoteAction
    global static CPBase.ItemCheckoutComponentController.PackageItemWrapper addAdditionalLine(String itemId, String piId, Integer quant, String salesOrderId, String dataJson) {
        return null;
    }
    @RemoteAction
    global static Boolean checkIfRenewal(String dataJson) {
        return null;
    }
    @RemoteAction
    global static CPBase.ItemCheckoutComponentController.AssignmentWrapper createAssignment(String conId, String assignId, String selectedRoleId, String dataJson) {
        return null;
    }
    @RemoteAction
    global static CPBase.ItemCheckoutComponentController.AssignmentWrapper createContact(String firstName, String lastName, String email, String accountId) {
        return null;
    }
    @RemoteAction
    global static List<CPBase.ItemCheckoutComponentController.PackageItemWrapper> getAdditionalItems(String solId, String itemId) {
        return null;
    }
    @RemoteAction
    global static List<OrderApi__Sales_Order_Line__c> getAdditionalLines(String solId) {
        return null;
    }
    @RemoteAction
    global static OrderApi__Item__c getItem(String itemId) {
        return null;
    }
    @RemoteAction
    global static OrderApi__Item__c getItemDetails(String dataJson) {
        return null;
    }
    @RemoteAction
    global static CPBase.ItemCheckoutComponentController.ItemDetailWrapper getItemDetailsWrapper(String dataJson) {
        return null;
    }
    @RemoteAction
    global static List<Id> getItemSubscriptionPlans(String itemId) {
        return null;
    }
    @RemoteAction
    global static OrderApi__Sales_Order_Line__c getSalesOrderLine(String itemId, String dataJson) {
        return null;
    }
    @RemoteAction
    global static List<CPBase.ItemCheckoutComponentController.SubPlanWrapper> getSubPlans(String dataJson) {
        return null;
    }
    @RemoteAction
    global static OrderApi__Subscription__c getSubscription(String dataJson) {
        return null;
    }
    @RemoteAction
    global static List<CPBase.ItemCheckoutComponentController.SubPlanWrapper> getSubscriptionPlans(List<Id> planIds, OrderApi__Item__c item) {
        return null;
    }
    @RemoteAction
    global static List<OrderApi__Item__c> getUpgradableItems(String dataJson) {
        return null;
    }
    @RemoteAction
    global static List<OrderApi__Assignment_Role__c> loadAssignmentRoles(OrderApi__Item__c item) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> loadPaymentMethodOptions(String dataJson) {
        return null;
    }
    @RemoteAction
    global static List<OrderApi__Payment_Method__c> loadPaymentMethods(String dataJson) {
        return null;
    }
    @RemoteAction
    global static CPBase.ItemCheckoutComponentController.PackageItemWrapper removeAdditionalLine(String itemId, String piId, String solId) {
        return null;
    }
    @RemoteAction
    global static List<CPBase.ItemCheckoutComponentController.AssignmentWrapper> searchAssignments(String searchString, String accountId, String salesOrderLineId, String dataJson) {
        return null;
    }
    @RemoteAction
    global static void unAssign(String assignId) {

    }
    @RemoteAction
    global static OrderApi__Sales_Order_Line__c updateItemSubscriptionPlan(OrderApi__Sales_Order_Line__c sol, Id subplanId) {
        return null;
    }
    @RemoteAction
    global static OrderApi__Sales_Order_Line__c updatePaymentMethod(String dataJson) {
        return null;
    }
global class AssignmentWrapper {
}
global class ItemDetailWrapper {
}
global class ItemWrapper {
}
global class PackageItemWrapper {
}
global class SubPlanWrapper {
}
}
