global class UpdateAccountTotalDepositScheduler implements Schedulable {
    global void execute(SchedulableContext sc)
    {
        UpdateAccountTotalDepositBatchable ba =new UpdateAccountTotalDepositBatchable();
        Database.executeBatch(ba);
    }

}