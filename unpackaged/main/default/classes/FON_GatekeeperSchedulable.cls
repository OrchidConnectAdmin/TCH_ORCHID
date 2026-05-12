global class FON_GatekeeperSchedulable implements Schedulable {
    private Queueable[] jobsToEnqueue;
    private Integer attemptNumber;
    private Integer delayInMinutes;

    public FON_GatekeeperSchedulable(Queueable[] jobsToEnqueue, Integer attemptNumber, Integer delayInMinutes) {
        this.jobsToEnqueue = jobsToEnqueue;
        this.attemptNumber = attemptNumber;
        this.delayInMinutes = delayInMinutes;
    }

    global void execute(SchedulableContext sc) {
        // Call the Gatekeeper service class instead of instantiating it
        FON_QueueableGatekeeper.enqueueIfFree(jobsToEnqueue, attemptNumber, delayInMinutes);
    }
}