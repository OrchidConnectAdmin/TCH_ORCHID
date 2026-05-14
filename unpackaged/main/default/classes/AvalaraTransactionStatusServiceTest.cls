/**
 * Test class for AvalaraTransactionStatusService.
 * Covers: commitTransaction (Committed status), voidTransaction (Cancelled status),
 * and verifies both operations reuse the shared core method correctly.
*/
@isTest
private class AvalaraTransactionStatusServiceTest {

    private static final String COMPANY_CODE = 'DEFAULT';
    private static final String TRANSACTION_CODE = 'TX-20260513-001';

    // ─── Mock Implementations ───

    private class CommitSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            System.assert(request.getBody().contains('"commit"'), 'Commit request should contain commit field');
            System.assert(request.getEndpoint().contains('/commit'), 'Endpoint should end with /commit');

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(buildTransactionResponseJson('Committed'));
            return response;
        }
    }

    private class VoidSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            System.assert(request.getBody().contains('"DocVoided"'), 'Void request should contain DocVoided code');
            System.assert(request.getEndpoint().contains('/void'), 'Endpoint should end with /void');

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(buildTransactionResponseJson('Cancelled'));
            return response;
        }
    }

    // ─── commitTransaction Tests ───

    @isTest
    static void commitTransactionReturnsCommittedStatusTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new CommitSuccessMock());

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraTransactionStatusService.commitTransaction(COMPANY_CODE, TRANSACTION_CODE);
        Test.stopTest();

        System.assertEquals('Committed', response.status, 'Status should be Committed');
        System.assertEquals(TRANSACTION_CODE, response.code, 'Transaction code should match');
        System.assertEquals(6.00, response.totalTax, 'totalTax should be preserved');
    }

    // ─── voidTransaction Tests ───

    @isTest
    static void voidTransactionReturnsCancelledStatusTest() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new VoidSuccessMock());

        Test.startTest();
        AvalaraCreateTransaction.Response response = AvalaraTransactionStatusService.voidTransaction(COMPANY_CODE, TRANSACTION_CODE);
        Test.stopTest();

        System.assertEquals('Cancelled', response.status, 'Status should be Cancelled');
        System.assertEquals(TRANSACTION_CODE, response.code, 'Transaction code should match');
        System.assertEquals(6.00, response.totalTax, 'totalTax should be preserved');
    }

    // ─── Test Data Helpers ───

    private static String buildTransactionResponseJson(String status) {
        return '{'
            + '"id":123456789,'
            + '"code":"' + TRANSACTION_CODE + '",'
            + '"companyCode":"' + COMPANY_CODE + '",'
            + '"date":"2026-05-13",'
            + '"status":"' + status + '",'
            + '"type":"SalesInvoice",'
            + '"customerVendorCode":"CUST-001",'
            + '"totalTax":6.00,'
            + '"totalTaxable":100.00,'
            + '"totalAmount":100.00,'
            + '"totalExempt":0,'
            + '"totalDiscount":0,'
            + '"lines":[{"lineNumber":"1","tax":6.00,"taxableAmount":100.00,"taxCalculated":6.00,"lineAmount":100.00,"rate":0.06,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
            + '}';
    }
}
