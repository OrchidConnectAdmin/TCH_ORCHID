public without sharing class AvalaraPaymentConfirmationQueueable implements Queueable, Database.AllowsCallouts {

    private Id salesOrderId;

    public AvalaraPaymentConfirmationQueueable(Id salesOrderId) {
        this.salesOrderId = salesOrderId;
    }

    public void execute(QueueableContext context) {
        try {
            AvalaraTaxCalculationService.commitTax(salesOrderId);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, '[Avalara] CommitTax failed for SO ' + salesOrderId + ': ' + e.getMessage());
        }
    }
}
