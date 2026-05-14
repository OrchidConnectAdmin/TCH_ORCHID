/**
 * Trigger for custom logic on Sales Order updates.
 * Delegates to SalesOrderCustomTriggerHandler for processing.
 */
trigger SalesOrderCustomTrigger on OrderApi__Sales_Order__c (after update) {
    SalesOrderCustomTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
}
