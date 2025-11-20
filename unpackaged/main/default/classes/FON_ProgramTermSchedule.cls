global class FON_ProgramTermSchedule implements Schedulable {

    global void execute(SchedulableContext sc) {
        
        FON_ProgramTermBatchInactivate batch = new FON_ProgramTermBatchInactivate();
        Database.executeBatch(batch,30);
    }
}