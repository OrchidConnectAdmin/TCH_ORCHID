@isTest
public class CHA_ProgramTermsScheduleTest {
    static testMethod void testPTSched(){
        Test.startTest();
        	CHA_ProgramTermsScheduler sch =  new CHA_ProgramTermsScheduler();
            String cron = '0 0 23 * * ?';
            system.schedule('Term Schedule', cron, sch);
        Test.stopTest();
    }
}