global class CHA_ProgramTermsScheduler implements Schedulable {
    global void execute(SchedulableContext ctx){
        CHA_ProgramTermsBatchable bt = new CHA_ProgramTermsBatchable();
        database.executeBatch(bt);
    }
}