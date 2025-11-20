global without sharing class FONCalculateSOTotalRule extends Framework.Domain{

    public FONCalculateSOTotalRule(List<OrderApi__Sales_Order_Line__c> sObjectList) {
        super(sObjectList);
    }

    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new FONCalculateSOTotalRule(sObjectList);
        }
    }
    public override void afterInsert(){
        Framework.Log.push(FONCalculateSOTotalRule.class.getName(),'afterInsert');
        FON_SalesOrderLineService.recalculateTotal((OrderApi__Sales_Order_Line__c []) records);
        Framework.Log.pop();
    }
    
    public override void afterUpdate(Map<Id,SObject> oldMap){
        Map<Id,OrderApi__Sales_Order_Line__c> old = (Map<Id,OrderApi__Sales_Order_Line__c>) oldMap;
        Framework.Log.push(FONCalculateSOTotalRule.class.getName(),'afterUpdate');
        FON_SalesOrderLineService.recalculateTotal((OrderApi__Sales_Order_Line__c []) records);

        Framework.Log.pop();
    }
}