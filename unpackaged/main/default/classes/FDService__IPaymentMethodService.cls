/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IPaymentMethodService {
    List<FDService.PaymentMethod> get(FDService.SearchRequest param0);
    FDService.PaymentMethod mapPaymentMethod(FDService.EPayTransaction.PaymentMethod param0);
    List<FDService.PaymentMethod> mutate(List<FDService.PaymentMethod> param0);
}
