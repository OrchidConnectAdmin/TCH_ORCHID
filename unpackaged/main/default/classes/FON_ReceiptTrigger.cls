/**
 * Created by nkopparthi on 9/21/20.
 */

global without sharing class FON_ReceiptTrigger extends Framework.Domain{

    public FON_ReceiptTrigger(List<OrderApi__Receipt__c> sObjectList) {
        super(sObjectList);
    }

    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new FON_ReceiptTrigger(sObjectList);
        }
    }

    public override void afterUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(FON_ReceiptTrigger.class.getName(),'afterUpdate');
        //FON_ReceiptService.generateCandidateID((OrderApi__Receipt__c []) records, (Map<Id,OrderApi__Receipt__c>) oldMap);
        FON_ReceiptService.createCEWrkshp((OrderApi__Receipt__c []) records, (Map<Id,OrderApi__Receipt__c>) oldMap);
        Framework.Log.pop();
    }


}