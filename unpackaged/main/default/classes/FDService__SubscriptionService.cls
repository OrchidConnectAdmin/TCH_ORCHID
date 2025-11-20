/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/SubscriptionService/*')
global virtual class SubscriptionService extends FDService.ServiceBase implements FDService.ISubscriptionService {
    global SubscriptionService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    @Deprecated
    global List<FDService.Subscription> getContactSubscriptions(Id contactId) {
        return null;
    }
    @Deprecated
    global List<FDService.Subscription> getContactSubscriptions(Id contactId, Boolean getSubscriptionTerms) {
        return null;
    }
    global static FDService.SubscriptionService getInstance() {
        return null;
    }
    global static FDService.SubscriptionService getInstance(String version) {
        return null;
    }
    @Deprecated
    global FDService.SubscriptionPlan getSubscriptionPlan(Id subscriptionPlanId) {
        return null;
    }
    @Deprecated
    global List<FDService.SubscriptionPlan> getSubscriptionPlans(Set<Id> Ids) {
        return null;
    }
    @Deprecated
    global List<FDService.Subscription> getSubscriptions(Set<Id> Ids) {
        return null;
    }
    global virtual List<FDService.Subscription> get(FDService.SearchRequest sr) {
        return null;
    }
}
