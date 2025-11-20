global class UpdateSPVolumeScheduler implements Schedulable {
    global void execute(SchedulableContext sc)
    {
        UpdateSPVolumeBatchable ba =new UpdateSPVolumeBatchable();
        Database.executeBatch(ba);
    }

}