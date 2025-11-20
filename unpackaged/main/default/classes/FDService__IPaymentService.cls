/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IPaymentService {
    FDService.EPayResponse authorize(FDService.EPayRequest param0);
    FDService.EPayResponse capture(FDService.EPayRequest param0);
    FDService.EPayResponse credit(FDService.EPayRequest param0);
    FDService.EPayResponse deletePaymentMethod(FDService.EPayRequest param0);
    FDService.EPayResponse generalCredit(FDService.EPayRequest param0);
    FDService.EPayResponse purchase(FDService.EPayRequest param0);
    FDService.EPayResponse savePaymentMethod(FDService.EPayRequest param0);
    FDService.EPayResponse verify(FDService.EPayRequest param0);
}
