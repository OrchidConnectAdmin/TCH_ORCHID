@isTest
public with sharing class Fon_EditFormControllerTest
{
	@TestSetup
	static void makeData()
	{
		Account account = new Account(Name = 'Test');
		Insert account;
	}

	@isTest
	static void test()
	{
		Id accountId = [SELECT Id
		                FROM Account
		                WHERE Name = 'Test'
		                LIMIT 1].Id;

		Fon_EditFormController.retrieveFields('LTE__Customer_Info', 'Account', 'Name', accountId, true);
	}
}