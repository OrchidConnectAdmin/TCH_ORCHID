/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/AssignmentService/*')
global virtual class AssignmentService extends FDService.ServiceBase implements FDService.IAssignmentService {
    global AssignmentService() {

    }
    @HttpGet
    global static void getApiResponse() {

    }
    @Deprecated
    global List<FDService.Assignment> getAssignmentsWithTerm(Set<Id> termIds) {
        return null;
    }
    global static FDService.AssignmentService getInstance() {
        return null;
    }
    global static FDService.AssignmentService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.Assignment> get(FDService.SearchRequest sr) {
        return null;
    }
}
