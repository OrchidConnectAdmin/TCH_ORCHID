/**
 * Service for Avalara post-payment tax commit.
 * Checks eligibility and enqueues async commit via Queueable.
 */
public without sharing class AvalaraPaymentConfirmationService {

    @AuraEnabled
    public static void enqueueCommitTax(String receiptNumber) {
        Id salesOrderId = resolveSalesOrderId(receiptNumber);

        Integer taxableCount = [
            SELECT COUNT()
            FROM OrderApi__Sales_Order_Line__c
            WHERE OrderApi__Sales_Order__c = :salesOrderId
              AND OrderApi__Item__r.Avalara_Tax__c != null
              AND OrderApi__Is_Shipping_Rate__c = false
            WITH SYSTEM_MODE
        ];

        if (taxableCount > 0) {
            System.enqueueJob(new AvalaraPaymentConfirmationQueueable(salesOrderId));
        }
    }

    private static Id resolveSalesOrderId(String receiptNumber) {
        List<OrderApi__Receipt__c> receipts = [
            SELECT OrderApi__Sales_Order__c
            FROM OrderApi__Receipt__c
            WHERE Name = :receiptNumber
            WITH SYSTEM_MODE
            LIMIT 1
        ];

        if (receipts.isEmpty()) {
            throw new AvalaraAuthProviderService.AvalaraException('Receipt not found: ' + receiptNumber);
        }

        return receipts[0].OrderApi__Sales_Order__c;
    }
}
