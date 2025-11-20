/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IAdjustmentService {
    List<FDService.SalesOrderLine> createAdjustments(List<FDService.WrapperBase> param0);
    List<FDService.CreditNote> createCreditNote(List<FDService.WrapperBase> param0);
    List<FDService.CreditMemo> creditMemo(List<FDService.SalesOrder> param0);
    List<FDService.SalesOrderLine> postAdjustments(List<FDService.WrapperBase> param0);
    List<FDService.CreditMemo> postCreditMemos(List<FDService.CreditMemo> param0);
    List<FDService.CreditNote> postCreditNotes(List<FDService.CreditNote> param0);
    List<FDService.SalesOrder> void(List<FDService.WrapperBase> param0);
    List<FDService.SalesOrder> writeOff(List<FDService.WrapperBase> param0);
}
