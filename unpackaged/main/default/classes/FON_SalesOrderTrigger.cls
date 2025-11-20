/**
 * Created by nkopparthi on 11/16/20.
 */

global without sharing class FON_SalesOrderTrigger extends Framework.Domain{

    public FON_SalesOrderTrigger(List<OrderApi__Sales_Order__c> sObjectList) {
        super(sObjectList);
    }

    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new FON_SalesOrderTrigger(sObjectList);
        }
    }
    public override void afterInsert(){
        Framework.Log.push(FON_SalesOrderTrigger.class.getName(),'afterInsert');
        FON_SalesOrderService.generateCandidateId((OrderApi__Sales_Order__c []) records);
        Framework.Log.pop();
    }
    
    public override void afterUpdate(Map<Id,SObject> oldMap){
        Map<Id,OrderApi__Sales_Order__c> old = (Map<Id,OrderApi__Sales_Order__c>) oldMap;
        List<OrderApi__Sales_Order__c> recordsSO = (List<OrderApi__Sales_Order__c>) records;
        List<OrderApi__Sales_Order__c> checkCandidateId = new List<OrderApi__Sales_Order__c>();
        Framework.Log.push(FON_SalesOrderTrigger.class.getName(),'afterUpdate');
        FON_SalesOrderService.approveOldCredits((OrderApi__Sales_Order__c []) records, (Map<Id,OrderApi__Sales_Order__c>) oldMap);
        FON_SalesOrderService.ApproveApplications((OrderApi__Sales_Order__c []) records, (Map<Id,OrderApi__Sales_Order__c>) oldMap);
        for(OrderApi__Sales_Order__c so : recordsSO){
            if(so.Total_Count_of_Lines__c != old.get(so.Id).Total_Count_of_Lines__c){
                checkCandidateId.add(so);
            }
        }
        if(checkCandidateId.size() > 0){
            FON_SalesOrderService.generateCandidateId(checkCandidateId);
        }
        Framework.Log.pop();
    }
}