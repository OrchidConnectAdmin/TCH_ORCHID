/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/SubscriptionRenewalService/*')
global virtual class SubscriptionRenewalService extends FDService.ServiceBase implements FDService.ISubscriptionRenewalService {
    global SubscriptionRenewalService() {

    }
    @HttpPost
    global static void getApiResponse() {

    }
    global static FDService.SubscriptionRenewalService getInstance() {
        return null;
    }
    global static FDService.SubscriptionRenewalService getInstance(String version) {
        return null;
    }
    global virtual FDService.SalesOrder renew(String subscriptionId) {
        return null;
    }
}
