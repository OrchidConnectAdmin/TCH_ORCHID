/**
 * Handler for SalesOrderCustomTrigger.
 * Detects Sales Orders voided after an Avalara transaction was committed
 * and enqueues async void calls to cancel the transaction in Avalara.
*/
public without sharing class SalesOrderCustomTriggerHandler {

    /**
     * Filters Sales Orders where Is_Voided changed to true and an Avalara
     * transaction exists (Transaction_Code filled), then enqueues a single
     * Queueable to void them in Avalara.
     * @param newList updated Sales Orders from Trigger.new
     * @param oldMap previous values from Trigger.oldMap
    */
    public static void afterUpdate(List<OrderApi__Sales_Order__c> newList, Map<Id, OrderApi__Sales_Order__c> oldMap) {
        List<OrderApi__Sales_Order__c> voidedOrders = new List<OrderApi__Sales_Order__c>();

        for (OrderApi__Sales_Order__c so : newList) {
            OrderApi__Sales_Order__c oldSo = oldMap.get(so.Id);

            if (so.OrderApi__Is_Voided__c == true
                && oldSo.OrderApi__Is_Voided__c == false
                && String.isNotBlank(so.Avalara_Transaction_Code__c)
            ) {
                voidedOrders.add(so);
            }
        }

        if (!voidedOrders.isEmpty()) {
            enqueueVoidTransactions(voidedOrders);
        }
    }

    /**
     * Collects transaction codes and enqueues a single Queueable.
     * The Queueable handles batching internally if the volume exceeds BATCH_SIZE.
     * @param voidedOrders Sales Orders with Avalara transactions to void
    */
    private static void enqueueVoidTransactions(List<OrderApi__Sales_Order__c> voidedOrders) {

        List<String> transactionCodes = new List<String>();

        for (OrderApi__Sales_Order__c so : voidedOrders) {
            transactionCodes.add(so.Avalara_Transaction_Code__c);
        }
        System.enqueueJob(new AvalaraVoidTransactionQueueable(transactionCodes));
    }
}
