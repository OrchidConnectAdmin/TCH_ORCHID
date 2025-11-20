/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_ProgramApi_Program_TermTrigger on ProgramApi__Program_Term__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(ProgramApi__Program_Term__c.SObjectType);
}