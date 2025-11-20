/**
 * Created by nkopparthi on 11/16/20.
 */

global without sharing class FON_NCPCreditTrigger extends Framework.Domain{

    public FON_NCPCreditTrigger(List<NCP_Credits__c> sObjectList) {
        super(sObjectList);
    }

    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new FON_NCPCreditTrigger(sObjectList);
        }
    }

    /*public override void afterInsert(){
        Framework.Log.push(FON_NCPCreditTrigger.class.getName(),'afterInsert');
        FON_NCPCreditService.createSO((NCP_Credits__c []) records);
        Framework.Log.pop();
    }

    public override void beforeInsert(){
        Framework.Log.push(FON_NCPCreditTrigger.class.getName(),'beforeInsert');
        FON_NCPCreditService.setDefaults((NCP_Credits__c []) records);
        Framework.Log.pop();
    }
       
    public override void beforeUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(FON_NCPCreditTrigger.class.getName(),'beforeInsert');
        FON_NCPCreditService.setDefaults((NCP_Credits__c []) records);
        Framework.Log.pop();
    }*/


}