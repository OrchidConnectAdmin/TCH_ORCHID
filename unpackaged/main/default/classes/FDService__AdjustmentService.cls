/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/AdjustmentService/*')
global virtual class AdjustmentService extends FDService.ServiceBase implements FDService.IAdjustmentService {
    global AdjustmentService() {

    }
    global virtual List<FDService.SalesOrderLine> createAdjustments(List<FDService.WrapperBase> wrappers) {
        return null;
    }
    global virtual List<FDService.CreditNote> createCreditNote(List<FDService.WrapperBase> wrappers) {
        return null;
    }
    global virtual List<FDService.CreditMemo> creditMemo(List<FDService.SalesOrder> wrappers) {
        return null;
    }
    @Deprecated
    global virtual List<FDService.SalesOrder> creditMemo(List<FDService.WrapperBase> wrappers) {
        return null;
    }
    global static FDService.AdjustmentService getInstance() {
        return null;
    }
    global static FDService.AdjustmentService getInstance(String version) {
        return null;
    }
    global virtual List<FDService.SalesOrderLine> postAdjustments(List<FDService.WrapperBase> wrappers) {
        return null;
    }
    @HttpPost
    global static void postApiResponse() {

    }
    global virtual List<FDService.CreditMemo> postCreditMemos(List<FDService.CreditMemo> wrappers) {
        return null;
    }
    global virtual List<FDService.CreditNote> postCreditNotes(List<FDService.CreditNote> notes) {
        return null;
    }
    global virtual List<FDService.SalesOrder> void(List<FDService.WrapperBase> wrappers) {
        return null;
    }
    global virtual List<FDService.SalesOrder> writeOff(List<FDService.WrapperBase> wrappers) {
        return null;
    }
}
