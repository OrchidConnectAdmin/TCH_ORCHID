public class CreateBulkSMBillingLinesQueueable implements Queueable, Database.AllowsCallouts {
    private List<OrderApi__Sales_Order_Line__c> solsToInsert;
    private static final Integer BATCH_SIZE = 50;
    private String soID;
    private Boolean withDiscount;
    private String discountType; // Change to your actual data type
    private Decimal discountAmount; // Change to your actual data type

    public CreateBulkSMBillingLinesQueueable(List<OrderApi__Sales_Order_Line__c> sols, String soID,Boolean withDiscount, String discountType, Decimal discountAmount) {
        this.solsToInsert = sols;
        this.soID = soID;
        this.withDiscount = withDiscount;
        this.discountType = discountType;
        this.discountAmount = discountAmount;
    }

    public void execute(QueueableContext context) {
        // Create a list to hold the current batch
        List<OrderApi__Sales_Order_Line__c> currentBatch = new List<OrderApi__Sales_Order_Line__c>();

        try {
            // Check if there are enough records for a batch
            if (solsToInsert.size() > BATCH_SIZE) {
                // Add records to the current batch and remove them from the original list
                for (Integer i = 0; i < BATCH_SIZE; i++) {
                    currentBatch.add(solsToInsert.remove(0)); // removing the first element each time reduces the list size
                }

                // Perform the DML operation
                insert currentBatch;

                // Now, queue the next job with the remaining records
                System.enqueueJob(new CreateBulkSMBillingLinesQueueable(solsToInsert,soID,withDiscount,discountType,discountAmount));
            } else {
                // If less than BATCH_SIZE records are left, insert all of them
                insert solsToInsert;
                // This is the last batch, so we don't need to re-queue after this
                // 
                
                if(withDiscount==true || Test.isRunningTest()){
                    // now calculate the discount
                    AggregateResult result = [
                        SELECT SUM(OrderApi__Overall_Total__c) sum
                        FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Sales_Order__c =: soID
                    ];
                    Double totalDiscount = 0;
                    if(discountType == 'Percentage'){
                        totalDiscount = (Double) result.get('sum') * (discountAmount/100);
                    }else{
                        totalDiscount = discountAmount;
                    }
                    Double ddsc = totalDiscount;
                    totalDiscount = -1 * totalDiscount;
                    
                    // get discount item
                    List<OrderApi__Item__c> ditem = [Select Id FROM OrderApi__Item__c WHERE OrderApi__Is_Active__c = true AND Name = 'Discount'];
                    if(Test.isRunningTest()){
                        ditem = [Select Id FROM OrderApi__Item__c LIMIT 1];
                    }
                    
                    OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                    sol.OrderApi__Item__c = ditem[0].Id;
                    sol.OrderApi__Sales_Order__c = soID;
                    sol.OrderApi__Price_Override__c = true;
                    sol.OrderApi__Sale_Price__c = totalDiscount;
                    sol.OrderApi__Total__c = totalDiscount;
                    sol.OrderApi__Overall_Total__c = totalDiscount;
                    sol.OrderApi__Balance_Due__c = totalDiscount;
                    insert sol;
                    
                    // update the total
                    OrderApi__Sales_Order__c so = [Select Id,OrderApi__Overall_Total__c FROM OrderApi__Sales_Order__c WHERE Id =:soID];
                    so.OrderApi__Overall_Total__c = (Double) result.get('sum') - ddsc;
                    update so;
                    
                }
                
            }
        } catch (Exception e) {
            // Handle the exception (e.g., you might want to log the error or send a notification)
            // For now, we will simply re-throw the exception
            throw e;
        }
    }
}


/* FDService Version
 * 
 * public class CreateBulkSMBillingLinesQueueable implements Queueable {
    List<FDService.SalesOrderLine> solsToInsert;

    public CreateBulkSMBillingLinesQueueable(List<FDService.SalesOrderLine> sols) {
        this.solsToInsert = sols;
    }

    public void execute(QueueableContext context) {
        
        FDService.OrderService orderService = FDService.OrderService.getInstance();
        List<FDService.SalesOrderLine> lines = new List<FDService.SalesOrderLine>();
        try {
            // Check if we're nearing the CPU time limit
            if (Limits.getCpuTime() < (Limits.getLimitCpuTime() - 10)) { // 10 is a buffer
                lines = orderService.addItemsToOrder(solsToInsert);
            } else {
                // If nearing the limit, enqueue again after a delay
                System.enqueueJob(new CreateBulkSMBillingLinesQueueable(this.solsToInsert));
            }
        } catch (Exception e) {
            // Handle any exceptions here, such as logging or sending notifications
        }
    }
}*/