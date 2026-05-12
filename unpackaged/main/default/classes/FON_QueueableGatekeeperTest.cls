@IsTest
public class FON_QueueableGatekeeperTest {

    @IsTest
    static void testGatekeeperEnqueuesJobs() {

        // Prepare sample data
        ProgramApi__Program_Profile__c pp = new ProgramApi__Program_Profile__c(
            ProgramApi__Status__c = 'New'
        );
        insert pp;

        List<Id> ids = new List<Id>{ pp.Id };
        
        List<ProgramApi__Program_Profile__c> pps = new List<ProgramApi__Program_Profile__c>();
        pps.add(pp);

        // FIX: your queueables must be top-level classes
        Queueable job1 = new FON_ProgramProfileSetStatusQueueable(pps);
        Queueable job2 = new FON_ProgramProfileValidateTermsQueueable(ids);

        Queueable[] jobs = new Queueable[]{ job1, job2 };

        Test.startTest();
        System.enqueueJob(new FON_QueueableGatekeeper(jobs, 1, 1));
        Test.stopTest();


    }


    @IsTest
    static void testSchedulableCallsGatekeeper() {

        Queueable job = new FON_ProgramProfileSetStatusQueueable(null);

        Queueable[] jobs = new Queueable[]{ job };

        // Run once in test mode
        String cron = '0 0 0 1 1 ? 2050';

        Test.startTest();
        System.schedule(
            'Test_Gatekeeper_Sched',
            cron,
            new FON_GatekeeperSchedulable(jobs, 0, 1)
        );
        Test.stopTest();


    }



}