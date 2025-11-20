public without sharing class MembershipsTriggerHelper {
    public MembershipsTriggerHelper(){
        System.debug('Inside MembershipsTriggerHelper Constructor');
    }
    
    public void inactivateSubs(List<OrderApi__Subscription__c> newSubs){
        List<OrderApi__Renewal__c> termsToUpdate = new List<OrderApi__Renewal__c>();
        List<OrderApi__Renewal__c> terms = [SELECT Id, OrderApi__Subscription__c, OrderApi__Is_Active__c 
                                            FROM OrderApi__Renewal__c 
                                            WHERE OrderApi__Subscription__c IN: newSubs ORDER BY CreatedDate DESC];
        Map<String, List<OrderApi__Renewal__c>> mapMembToTerms = new Map<String, List<OrderApi__Renewal__c>>();
        for(OrderApi__Renewal__c term : terms){
            if(mapMembToTerms.containsKey(term.OrderApi__Subscription__c)){
                mapMembToTerms.get(term.OrderApi__Subscription__c).add(term);
            }else{
                mapMembToTerms.put(term.OrderApi__Subscription__c, new List<OrderApi__Renewal__c>{term});
            }
        }
        
        for(OrderApi__Subscription__c sub : newSubs){
            //for(OrderApi__Renewal__c memb : mapMembToTerms.get(sub.Id)){
            if(mapMembToTerms.get(sub.Id)[0].OrderApi__Is_Active__c && mapMembToTerms.get(sub.Id)[1].OrderApi__Is_Active__c){
                mapMembToTerms.get(sub.Id)[1].OrderApi__Is_Active__c = false;
                sub.OrderApi__Paid_Through_Date__c = system.today();
                termsToUpdate.add(mapMembToTerms.get(sub.Id)[1]);
            }  
            //}
        }
        
        if(termsToUpdate.size() > 0){
            update termsToUpdate;
        }
    }
    
}