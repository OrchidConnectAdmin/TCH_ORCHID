@isTest
public with sharing class GetCYRILEntrySearchControllerTest
{
	@TestSetup
	static void makeData()
	{
		Contact contact = new Contact(LastName = 'test');
		Insert contact;
	}

	@isTest
	static void testSearchList()
	{
		GetCYRILEntrySearchController.searchList('test');

		try
		{
			GetCYRILEntrySearchController.searchList('testKey');
		}
		catch (Exception e)
		{
			System.assertEquals(e.getTypeName(), 'System.AuraHandledException');
		}
	}

	@isTest
	static void testGetRecords()
	{
		GetCYRILEntrySearchController.getRecords('test', 'Contact', 'LastName', 'LastName', 'FirstName', null, 1, 'Contact', 'LastName', 'LastName', '', '');
		GetCYRILEntrySearchController.getRecords('test', 'Contact', 'Id', 'LastName', 'FirstName', null, 1, 'Contact', 'LastName', 'LastName', '', 'Exclude');
	}

	@isTest
	static void testReadFieldSet()
	{
		GetCYRILEntrySearchController.readFieldSet('LTE__Demo_Field_Set', 'Account');
	}

	@isTest
	static void testGetFieldSet()
	{
		GetCYRILEntrySearchController.getFieldSet('LTE__Demo_Field_Set', 'Account');
	}

	@isTest
	static void testGetEntryFields()
	{
		GetCYRILEntrySearchController.getEntryFields('Account', 'LTE__Demo_Field_Set');
	}
}