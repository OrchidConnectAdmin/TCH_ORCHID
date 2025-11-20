global class FON_NewYearSchedule implements Schedulable {

    global void execute(SchedulableContext sc) {
        
        FON_NewYearBatchJob batch = new FON_NewYearBatchJob();
        Database.executeBatch(batch, 30);
    }
}