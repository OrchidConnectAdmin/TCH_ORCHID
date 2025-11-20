@isTest(SeeAllData=False)
public class CHACreateAttendeesBatchableTest {
	
    @isTest
    public static void testBatch() {
        
        Account account = new Account(Name = 'Account 1');
        insert account;
        
        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.Email = 'test2432324@email.com';
        contact.FirstName = 'Test First Name';
        contact.LastName = 'T2est Last Name';
        insert contact;
        
        // Create Event
        EventApi__Event__c testEvent = new EventApi__Event__c(
            Name = 'Test Event',
            EventApi__Display_Name__c = 'Test Event Display',
            EventApi__Logo_Image__c = 'https://example.com/logo.png',
            EventApi__Status__c = 'Active',
            EventApi__Ticket_Sales_Start_Date__c = Date.today().addDays(-1),
            EventApi__End_Date__c = Date.today().addDays(5),
            EventApi__Event_Key__c = '4bf97723-5c80-4'
        );
        insert testEvent;
        
        
                // Create Sales Order
        ORDERAPI__Sales_Order__c so = new ORDERAPI__Sales_Order__c(
            OrderApi__Account__c = account.Id,
            OrderApi__Entity__c = 'Contact',
            OrderApi__Contact__c = contact.Id);
        insert so;
        
        // Create test Sales Order Lines
        List<OrderApi__Sales_Order_Line__c> testSalesOrderLines = new List<OrderApi__Sales_Order_Line__c>();
        for (Integer i = 0; i < 5; i++) {
            OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c(
                OrderApi__Entity__c = 'Contact',
                OrderApi__Overall_Total__c = 10.0 + (i * 2),
                OrderApi__Sales_Order__c = so.Id,
            	EventApi__Event__c = testEvent.Id
            );
            testSalesOrderLines.add(sol);
        }
        insert testSalesOrderLines;

        
        //Test.startTest();
        	List<String> fids = new List<String>();
        	CHACreateAttendeesBatchable batch = new CHACreateAttendeesBatchable();
        	Id job1 = Database.executeBatch(batch);
       // Test.stopTest();
        
  
    }

    @IsTest
    static void testGetBatchsAndConfigBatchAndGetApexJob() {
        // Create a custom metadata record for CYRIL_Batchables__mdt so that configBatchTest can find it
        CYRIL_Batchables__mdt mdt = [Select Id,Batchable_Name__c FROM CYRIL_Batchables__mdt WHERE Batchable_Name__c = 'CHACreateAttendeesBatchable'];
        
        // ------ Test getBatchs() ------
        Test.startTest();
        List<CYRIL_Batchables__mdt> fetchedBatchables = CYRIL_Report_Generated_Batch.getBatchs();
        Test.stopTest();
        System.assertNotEquals(null, fetchedBatchables, 'getBatchs should not return null');
        System.assertEquals(1, fetchedBatchables.size(), 'There should be exactly one custom metadata record');
        System.assertEquals(
            mdt.Batchable_Name__c,
            fetchedBatchables[0].Batchable_Name__c,
            'Batchable_Name__c should match the inserted custom metadata'
        );
        
        // ------ Test configBatchTest(...) ------
        // Since Test.isRunningTest() == true inside configBatchTest, no batch is actually executed.
        //Test.startTest();
        AsyncApexJob returnedJob = CYRIL_Report_Generated_Batch.configBatchTest(
            /*reportId=*/          null,
            /*column=*/            null,
            /*fields=*/            'SomeField',
            /*filters=*/           'SomeFilter',
            /*batchId=*/           mdt.Id,
            /*batchSize=*/         '2',
            /*rId=*/               '000000000000000'
        );
        //Test.stopTest();
        
        // Because no batch was executed, batchprocessid was never set, and the query returns nothing.
        // The method returns a default AsyncApexJob instance (all fields null).
        System.assertNotEquals(null, returnedJob, 'configBatchTest should return a non-null AsyncApexJob object');
        System.assertEquals(null, returnedJob.Id, 'No actual AsyncApexJob record should have been enqueued in test context');
        System.assertEquals(0, returnedJob.JobItemsProcessed == null ? 0 : returnedJob.JobItemsProcessed, 'JobItemsProcessed should be null or 0');
        
        // ------ Test getApexJob(...) with a non-existent Id ------
        // Passing an arbitrary Id that does not exist means the SOQL returns an empty list,
        // so getApexJob returns a default AsyncApexJob instance.
        AsyncApexJob fetchedAj = CYRIL_Report_Generated_Batch.getApexJob('a000000000000000AAA');
        System.assertNotEquals(null, fetchedAj, 'getApexJob should return a non-null AsyncApexJob even if Id does not exist');
        System.assertEquals(null, fetchedAj.Id, 'No AsyncApexJob record should match a random Id');
    }
    
    @IsTest
    static void testGetReportsWithSeeAllDataFalse() {
        // getReports() queries Report. In a test with SeeAllData=false,
        // there are no Report rows, but it should return an empty list rather than throwing.
        //Test.startTest();
        List<Report> allReports = CYRIL_Report_Generated_Batch.getReports();
        //Test.stopTest();
        System.assertNotEquals(null, allReports, 'getReports should not return null (empty list expected)');
        System.assertEquals(0, allReports.size(), 'With SeeAllData=false, there should be no Report records available');
    }

}