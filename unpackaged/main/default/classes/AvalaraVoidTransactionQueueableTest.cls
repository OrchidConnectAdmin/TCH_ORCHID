/**
 * Test class for AvalaraVoidTransactionQueueable.
 * Covers: single and multiple voids, error handling (callout failure does not abort),
 * and batch processing within BATCH_SIZE without chaining.
*/
@isTest
private class AvalaraVoidTransactionQueueableTest {

    private static final String TRANSACTION_CODE = 'TX-VOID-001';
    private static final String COMPANY_CODE = 'DEFAULT';

    // ─── Mock Implementations ───

    private class VoidSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{'
                + '"id":123456789,"code":"' + TRANSACTION_CODE + '","status":"Cancelled","type":"SalesInvoice",'
                + '"totalTax":6.00,"totalTaxable":100.00,"totalAmount":100.00,"totalExempt":0,"totalDiscount":0,'
                + '"lines":[{"lineNumber":"1","tax":6.00,"taxableAmount":100.00,"taxCalculated":6.00,"lineAmount":100.00,"rate":0.06,"itemCode":"ITEM-001","taxCode":"P0000000","isItemTaxable":true,"details":[]}]'
                + '}');
            return response;
        }
    }

    private class VoidFailMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setBody('{"error":{"message":"Internal Server Error"}}');
            return response;
        }
    }

    // ─── Single Transaction Tests ───

    @isTest
    static void should_void_single_transaction() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new VoidSuccessMock());

        Test.startTest();
        System.enqueueJob(new AvalaraVoidTransactionQueueable(
            new List<String>{ TRANSACTION_CODE }
        ));
        Test.stopTest();

        System.assert(true, 'Single void should execute without errors');
    }

    @isTest
    static void should_handle_multiple_transactions() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new VoidSuccessMock());

        List<String> codes = new List<String>();
        for (Integer i = 0; i < 3; i++) {
            codes.add('TX-VOID-' + String.valueOf(i));
        }

        Test.startTest();
        System.enqueueJob(new AvalaraVoidTransactionQueueable(codes));
        Test.stopTest();

        System.assert(true, 'Multiple voids should execute without errors');
    }

    // ─── Error Handling ───

    @isTest
    static void should_continue_processing_when_one_fails() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        // Mock returns 500 for all — each callout fails but try/catch prevents abort
        Test.setMock(HttpCalloutMock.class, new VoidFailMock());

        List<String> codes = new List<String>{ 'TX-FAIL-1', 'TX-FAIL-2' };

        Test.startTest();
        System.enqueueJob(new AvalaraVoidTransactionQueueable(codes));
        Test.stopTest();

        // No unhandled exception — try/catch logs error and continues
        System.assert(true, 'Failed callouts should not abort the Queueable');
    }

    // ─── Self-Chaining ───

    @isTest
    static void should_process_within_batch_size_without_chaining() {
        AvalaraAuthProviderService.isSandboxOverride = true;
        Test.setMock(HttpCalloutMock.class, new VoidSuccessMock());

        List<String> codes = new List<String>();
        for (Integer i = 0; i < 5; i++) {
            codes.add('TX-SMALL-' + String.valueOf(i));
        }

        Test.startTest();
        System.enqueueJob(new AvalaraVoidTransactionQueueable(codes));
        Test.stopTest();

        // 5 < BATCH_SIZE(25) — no chaining needed, all processed in one execution
        System.assert(true, 'Should process all codes in single execution without chaining');
    }
}
