/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_ProgramApi_Program_TermTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_ProgramApi_Program_TermTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new ProgramApi__Program_Term__c());
    }
}