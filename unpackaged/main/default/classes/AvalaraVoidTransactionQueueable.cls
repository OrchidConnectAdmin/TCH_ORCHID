/**
 * Async Queueable that voids Avalara transactions in batches.
 * Processes up to BATCH_SIZE callouts per execution. If there are more
 * transaction codes than BATCH_SIZE, it self-chains by enqueuing a new
 * instance with the remaining codes. Each callout is wrapped in try/catch
 * so a single failure does not block the rest.
 *
 * Example with 60 codes and BATCH_SIZE=25:
 *   Queueable #1: processes 0-24, enqueues remaining 35
 *   Queueable #2: processes 25-49, enqueues remaining 10
 *   Queueable #3: processes 50-59, no remaining, done
*/
public without sharing class AvalaraVoidTransactionQueueable implements Queueable, Database.AllowsCallouts {

    // Max callouts per execution to avoid long-running transactions if Avalara is slow
    private static final Integer BATCH_SIZE = 25;

    private List<String> transactionCodes;

    /**
     * @param transactionCodes Avalara transaction codes to void (from Sales_Order__c.Avalara_Transaction_Code__c)
    */
    public AvalaraVoidTransactionQueueable(List<String> transactionCodes) {
        this.transactionCodes = transactionCodes;
    }

    /**
     * Processes the current batch and self-chains if there are remaining codes.
     * Company code is queried once from Avalara_Config__mdt and reused for all callouts.
     * @param context Queueable context (provided by platform)
    */
    public void execute(QueueableContext context) {
        
        String companyCode = [
            SELECT Company_Code__c
            FROM Avalara_Config__mdt
            WHERE Is_Active__c = true
            WITH SYSTEM_MODE
            LIMIT 1
        ].Company_Code__c;

        Integer processCount = Math.min(BATCH_SIZE, transactionCodes.size());

        for (Integer i = 0; i < processCount; i++) {

            try {
                AvalaraTransactionStatusService.voidTransaction(companyCode, transactionCodes[i]);
            } 
            catch (Exception e) {
                System.debug(LoggingLevel.ERROR, '[Avalara] VoidTransaction failed for ' + transactionCodes[i] + ': ' + e.getMessage());
            }
        }

        // Self-chain: enqueue a new instance with the remaining codes
        if (transactionCodes.size() > BATCH_SIZE) {
            List<String> remaining = new List<String>();
            for (Integer i = BATCH_SIZE; i < transactionCodes.size(); i++) {
                remaining.add(transactionCodes[i]);
            }
            System.enqueueJob(new AvalaraVoidTransactionQueueable(remaining));
        }
    }
}
