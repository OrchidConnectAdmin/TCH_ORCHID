/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Item implements System.Comparable {
    @AuraEnabled
    global Id itemId;
    global Item(Id itemId) {

    }
    global List<OrderApi.ItemSubscriptionPlan> getItemSubPlans(Id customerId, Double quantity, List<Id> subPlans) {
        return null;
    }
    global OrderApi.PriceRule getListPrice() {
        return null;
    }
    global OrderApi.PriceRule getPrice(Double quantity, Id customerId) {
        return null;
    }
    global OrderApi.PriceRule getPrice(Double quantity, Id customerId, Map<String,Integer> customerPRUsed) {
        return null;
    }
}
