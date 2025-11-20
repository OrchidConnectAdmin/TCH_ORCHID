/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IEPaymentMapService {
    FDService.EPayment createEPayment(FDService.WrapperBase param0);
    FDService.EPayment createEPaymentForPreAuthorizePayments(FDService.WrapperBase param0);
    List<FDService.EPayment> createEPayments(List<FDService.WrapperBase> param0);
    FDService.EPayment mapApiResponse(FDService.EPayment param0, FDService.EPayTransaction param1);
}
