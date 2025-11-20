/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/TermService/*')
global virtual class TermService extends FDService.ServiceBase implements FDService.ITermService {
    global TermService() {

    }
    @Deprecated
    global FDService.Term get(Id termId) {
        return null;
    }
    @HttpGet
    global static void getApiResponse() {

    }
    global static FDService.TermService getInstance() {
        return null;
    }
    global static FDService.TermService getInstance(String version) {
        return null;
    }
    @Deprecated
    global List<FDService.Term> getSubscriptionTerms(Set<Id> subIds) {
        return null;
    }
    global virtual List<FDService.Term> get(FDService.SearchRequest sr) {
        return null;
    }
    @Deprecated
    global List<FDService.Term> get(Set<Id> termIds) {
        return null;
    }
    global virtual FDService.Term mutate(FDService.Term objterm) {
        return null;
    }
    global virtual List<FDService.Term> mutate(List<FDService.Term> objTerms) {
        return null;
    }
    @HttpPut
    global static void updateTerm() {

    }
}
