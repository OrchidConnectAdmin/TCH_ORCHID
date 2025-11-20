trigger FON_NCPTrigger on NCP_Credits__c (before insert, before update, before delete, after insert, after update, after delete) {
    Framework.Dispatcher.dispatchTrigger();
}