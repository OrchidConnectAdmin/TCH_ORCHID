global class RenewPPsNewYearBatchSchedule implements Schedulable {

    global void execute(SchedulableContext sc) {
        RenewPPsNewYearsBatch batch = new RenewPPsNewYearsBatch();
        Database.executeBatch(batch, 50);
    }
}