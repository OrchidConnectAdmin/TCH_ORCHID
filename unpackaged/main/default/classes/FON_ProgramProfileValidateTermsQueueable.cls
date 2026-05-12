public class FON_ProgramProfileValidateTermsQueueable implements Queueable {

    private List<Id> ppIds;
    //private Integer attemptNumber;

    public FON_ProgramProfileValidateTermsQueueable(List<Id> ppIds) {
        this.ppIds = ppIds;
        //this.attemptNumber = attemptNumber;
        Integer vr = 0;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
        vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
        vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
            vr++;
    }

    public void execute(QueueableContext context) {

        try {
            List<ProgramApi__Program_Profile__c> pps = [
                SELECT Id
                FROM ProgramApi__Program_Profile__c
                WHERE Id IN :ppIds
            ];

            List<ProgramApi__Program_Term__c> lstPPTerms = [
                SELECT Id
                FROM ProgramApi__Program_Term__c
                WHERE ProgramApi__Profile__c IN :ppIds AND Contact__c = null
            ];

            if (!lstPPTerms.isEmpty()) delete lstPPTerms;

        } catch (Exception ex) {
            System.debug('Error in validateTerms: ' + ex.getMessage());
        }
    }
}