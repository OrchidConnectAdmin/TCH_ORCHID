global class FON_SubscriptionBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {

        Integer nextYear = Date.today().year() + 1;
        Integer lastTwoYears = Date.today().year() - 2;

        String query = 'SELECT Id FROM OrderApi__Subscription__c WHERE OrderApi__Is_Active__c = true';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<OrderApi__Subscription__c> subscriptions) {
		
        List<OrderApi__Renewal__c> renewalToUpdate = new List<OrderApi__Renewal__c>();
        
        Map<Id, OrderApi__Subscription__c> subscriptionById = new Map<Id, OrderApi__Subscription__c>(subscriptions);
        Map<Id, List<OrderApi__Renewal__c>> renewalsBySubscriptionId= new Map<Id, List<OrderApi__Renewal__c>>();

        for(OrderApi__Renewal__c renewal : [SELECT Id, OrderApi__Subscription__c FROM OrderApi__Renewal__c WHERE OrderApi__Subscription__c IN :subscriptionById.keyset()]){
            
            Id key = renewal.OrderApi__Subscription__c;
            List<OrderApi__Renewal__c> renewals = new List<OrderApi__Renewal__c>();
            
            if(renewalsBySubscriptionId.containsKey(key)) {
                
                renewals = renewalsBySubscriptionId.get(key);
            }
            
            renewals.add(renewal);
            renewalsBySubscriptionId.put(key, renewals);
        }
        
        for(Id subscriptionId : renewalsBySubscriptionId.keyset()){
            
            for(OrderApi__Renewal__c renewal : renewalsBySubscriptionId.get(subscriptionId)) {
                //compare by date and the newest gets to be active and the others inactive.
                
            }
        }
        
        
        

    }

    global void finish(Database.BatchableContext BC) {
    }
}