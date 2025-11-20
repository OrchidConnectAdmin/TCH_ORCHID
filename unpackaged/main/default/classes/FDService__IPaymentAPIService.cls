/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IPaymentAPIService {
    FDService.EPayResponse authorize(FDService.EPayRequest param0);
    FDService.EPayResponse cancel(FDService.EPayRequest param0);
    FDService.EPayResponse capture(FDService.EPayRequest param0);
    FDService.EPayResponse connect();
    FDService.EPayResponse connect(FDService.EPayRequest param0);
    FDService.EPayResponse credit(FDService.EPayRequest param0);
    FDService.EPayResponse disconnect(FDService.EPayRequest param0);
    FDService.EPayResponse generalCredit(FDService.EPayRequest param0);
    FDService.EPayResponse getAccountTransactions();
    FDService.EPayResponse getGatewayOptions();
    FDService.EPayResponse getGatewayTransactions(FDService.EPayRequest param0);
    FDService.EPayResponse getPaymentMethodTransactions(FDService.EPayRequest param0);
    FDService.EPayResponse purchase(FDService.EPayRequest param0);
    FDService.EPayResponse read(FDService.EPayRequest param0);
    FDService.EPayResponse remove(FDService.EPayRequest param0);
    FDService.EPayResponse savePayMethod(FDService.EPayRequest param0);
    FDService.EPayResponse updateGateway(FDService.EPayRequest param0);
    FDService.EPayResponse updatePayMethod(FDService.EPayRequest param0);
    FDService.EPayResponse verify(FDService.EPayRequest param0);
}
