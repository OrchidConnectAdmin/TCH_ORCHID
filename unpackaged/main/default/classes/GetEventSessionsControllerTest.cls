@isTest
public class GetEventSessionsControllerTest {
    @testSetup
    static void setupTestData() {
        // Create test data for EventApi__Schedule_Item__c
        EventApi__Schedule_Item__c scheduleItem = new EventApi__Schedule_Item__c(Name = 'Test Schedule Item');
        insert scheduleItem;

        // Create test data for EventApi__Attendee__c
        EventApi__Attendee__c attendee = new EventApi__Attendee__c();
        insert attendee;

        // Create test data for EventApi__Registration_Item__c
        EventApi__Registration_Item__c regItem = new EventApi__Registration_Item__c(
            EventApi__Attendee__c = attendee.Id,
            EventApi__Schedule_Item__c = scheduleItem.Id
        );
        insert regItem;
    }

    @isTest
    static void testGetEventSessionsController() {
        // Retrieve the test data
        EventApi__Attendee__c testAttendee = [SELECT Id FROM EventApi__Attendee__c LIMIT 1];
        String attendeeId = testAttendee.Id;

        // Instantiate the controller with the test data
        Test.startTest();
        GetEventSessionsController controller = new GetEventSessionsController();
        controller.attendeeId = attendeeId;
        controller.getdisplaydata();
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, controller.wrapObj, 'The wrapObj should not be null.');
        System.assertNotEquals(null, controller.wrapObj.sessions, 'The sessions list should not be null.');
        System.assertEquals(1, controller.wrapObj.sessions.size(), 'The sessions list should contain one item.');

        // Verify the data of the session
        EventApi__Registration_Item__c regItem = controller.wrapObj.sessions[0];
        System.assertEquals('Test Schedule Item', regItem.EventApi__Schedule_Item__r.Name, 'The schedule item name should match.');
    }

    @isTest
    static void testGetEventSessionsController_NoSessions() {
        // Create a new attendee without any sessions
        EventApi__Attendee__c newAttendee = new EventApi__Attendee__c();
        insert newAttendee;

        // Instantiate the controller with the new attendee
        Test.startTest();
        GetEventSessionsController controller = new GetEventSessionsController();
        controller.attendeeId = newAttendee.Id;
        controller.getdisplaydata();
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, controller.wrapObj, 'The wrapObj should not be null.');
        System.assertEquals(0, controller.wrapObj.sessions.size(), 'The sessions list should be empty.');
    }
}