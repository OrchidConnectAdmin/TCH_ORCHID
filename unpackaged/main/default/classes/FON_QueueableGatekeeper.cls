public class FON_QueueableGatekeeper {

    public static final Integer MAX_RETRIES = Integer.valueOf(Label.Queue_Max_Retries);

    public static void enqueueIfFree(Queueable[] jobsToEnqueue, Integer attemptNumber, Integer delayInMinutes) {
        List<AsyncApexJob> runningQueueables = [
            SELECT Id, Status, ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType IN ('Queueable','Future')
              AND Status IN ('Processing','Holding','Queued')
        ];

        if (runningQueueables.isEmpty()) {
            for (Queueable job : jobsToEnqueue) {
                System.enqueueJob(job);
            }
            System.debug('Queueables enqueued successfully.');
        } else {
            if (attemptNumber < MAX_RETRIES) {
                System.debug('Queueables running. Scheduling Gatekeeper retry attempt ' + (attemptNumber + 1));
                String sch = System.now().addMinutes(delayInMinutes).format('s m H d M ? yyyy');
                System.schedule('GatekeeperRetry_' + System.currentTimeMillis(),
                                sch,
                                new FON_GatekeeperSchedulable(jobsToEnqueue, attemptNumber + 1, delayInMinutes));
            } else {
                System.debug('Max retries reached for Gatekeeper. Jobs not enqueued.');
            }
        }
    }
}