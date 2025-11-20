@isTest
public with sharing class GetRelatedListControllerTest
{
	@TestSetup
	static void makeData()
	{
		Contact contact = new Contact(LastName = 'test');
		Insert contact;
	}

	@isTest
	static void testGetItems()
	{
		GetRelatedListController.getItems('Contact', 'LastName', '', 'LastName', 'test', '');
	}

	@isTest
	static void testGetColumns()
	{
		GetRelatedListController.getColumns('Contact', 'FirstName,LastName');
	}

	@isTest
	static void testGetAccessPermissions()
	{
		Id contactId = [SELECT Id
		                FROM Contact
		                LIMIT 1].Id;

		GetRelatedListController.getAccessPermission(contactId, 'Id', null);
	}
}