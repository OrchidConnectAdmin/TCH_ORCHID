@isTest
public class GetCYRILOrderLinesControllerTest {
    @isTest static void getTest() {
        
        Account a = new Account(Name = 'Test Account', ShippingCountry = 'United States');
        insert a;
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = a.Id, OrderApi__Personal_Email__c = 'fsemailupdatetest@example.com',
                                OrderApi__Preferred_Email_Type__c = 'Personal');
        insert c;
        OrderApi__Business_Group__c busGroup = new OrderApi__Business_Group__c(Name = 'Test');
        insert busGroup;
        
        OrderApi__Item_Class__c itemClass= new OrderApi__Item_Class__c(Name = 'Test',
                                                                       OrderApi__Business_Group__c = busGroup.Id, OrderApi__Is_Subscription__c = false);
        insert itemClass;
        OrderApi__Item__c  item1 = new OrderApi__Item__c(Name='Test Chapter1',
                                                         OrderApi__Business_Group__c = busGroup.Id,
                                                         OrderApi__Item_Class__c = itemClass.Id, OrderApi__Is_Subscription__c = false,
                                                        OrderApi__Is_Active__c = true, OrderApi__Price__c = 70);
        OrderApi__Sales_Order__c salesOrderOne = new OrderApi__Sales_Order__c(OrderApi__Contact__c = c.Id,OrderApi__Posting_Status__c='Pending',OrderApi__Status__c='Open');
        insert salesOrderOne;
        OrderApi__Sales_Order_Line__c soLine=new OrderApi__Sales_Order_Line__c(OrderApi__Sales_Order__c=salesOrderOne.Id,OrderApi__Item__c=item1.Id,OrderApi__Item_Class__c=itemClass.Id);
        insert soLine;
        
        CYRIL_Invoice_Line_Types__mdt ilines = [Select Id FROM CYRIL_Invoice_Line_Types__mdt WHERE Type__c='Order Lines' LIMIT 1];
        
        CYRIL_Order_Set_Group__mdt igroup = [SELECT Id, MasterLabel FROM CYRIL_Order_Set_Group__mdt ORDER BY MasterLabel LIMIT 1]; 
		CYRIL_Invoice_Line_Types__mdt ilines2 = [Select Id FROM CYRIL_Invoice_Line_Types__mdt WHERE Type__c='Order Lines' LIMIT 1];
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%Administrator%' LIMIT 1].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;

        //system.runAs(u)
        //{
        Test.startTest();
        	Map<String,List<String>> gitems = GetCYRILOrderLinesController.getItems('OrderApi__Sales_Order_Line__c', String.valueOf(soLine.Id), ilines.id, 'false');
        
        	List<String> gcols = GetCYRILOrderLinesController.getColumns('OrderApi__Sales_Order_Line__c', String.valueOf(soLine.Id), ilines.Id, 'false');
        
        	String gquery = GetCYRILOrderLinesController.getQuery('OrderApi__Sales_Order__c', 'Name,OrderApi__Posting_Status__c', 'OrderApi__Status__c=\'Open\'', 'Id', String.valueOf(salesOrderOne.Id), null, null, 'false');
        
        	Map<String,Map<String,String>> gitems2 = GetCYRILOrderInfoController.getItems('OrderApi__Sales_Order__c', String.valueOf(salesOrderOne.Id), String.valueOf(igroup.Id), 'false');
        
        Test.stopTest();
        //}
        
    }
    
    @isTest static void testGetDefaultValue() {
        GetCYRILOrderInfoTypesController controller = new GetCYRILOrderInfoTypesController();
		GetCYRILOrderLineTypesController controller2 = new GetCYRILOrderLineTypesController();
        // Test getDefaultValue method
        VisualEditor.DataRow defaultValue = controller.getDefaultValue();
        VisualEditor.DataRow defaultValue2 = controller2.getDefaultValue();
        //System.assertNotEquals(null, defaultValue, 'Default value should not be null');
        //System.assertEquals('Select Order Information Set Group', defaultValue.label, 'Label should match the default value');
        //System.assertEquals('', defaultValue.value, 'Value should be an empty string');
    }

    @isTest static void testGetValues() {
        GetCYRILOrderInfoTypesController controller = new GetCYRILOrderInfoTypesController();
    	GetCYRILOrderLineTypesController controller2 = new GetCYRILOrderLineTypesController();
        
        // Test getValues method
        VisualEditor.DynamicPickListRows values = controller.getValues();
        VisualEditor.DynamicPickListRows values2 = controller2.getValues();
        //System.assertNotEquals(null, values, 'Values should not be null');

    }
}