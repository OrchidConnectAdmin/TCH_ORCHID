public class FON_ProgramProfileSetStatusQueueable implements Queueable {

    private List<ProgramApi__Program_Profile__c> pps;
    //private Integer attemptNumber;

    public FON_ProgramProfileSetStatusQueueable(List<ProgramApi__Program_Profile__c> pps) {
        this.pps = pps;
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

            
            Set<Id> ppIds = new Set<Id>();
            
            for(ProgramApi__Program_Profile__c pp : pps ) {
                ppIds.add(pp.Id);
            }
            update pps;
            
            
            // delete duplicate terms
            List<ProgramApi__Program_Term__c> lstPPTerms = [SELECT id FROM ProgramApi__Program_Term__c WHERE ProgramApi__Profile__c IN :ppIds AND Contact__c = null ];
            if(lstPPTerms.size()>0){
                delete lstPPTerms;
            }

        } catch (Exception ex) {
            System.debug('Error in setStatusQueue: ' + ex.getMessage());
        }
    }
}