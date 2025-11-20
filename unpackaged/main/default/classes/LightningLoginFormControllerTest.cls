@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest
{
	@IsTest
	static void testLoginWithInvalidCredentials()
	{
		LightningLoginFormController.login('testUser', 'fakepwd', null);
	}

	@IsTest
	static void LightningLoginFormControllerInstantiation()
	{
		LightningLoginFormController controller = new LightningLoginFormController();
		System.assertNotEquals(controller, null);
	}

	@IsTest
	static void testIsUsernamePasswordEnabled()
	{
		System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
	}

	@IsTest
	static void testIsSelfRegistrationEnabled()
	{
		LightningLoginFormController.getIsSelfRegistrationEnabled();
	}

	@IsTest
	static void testGetSelfRegistrationURL()
	{
		LightningLoginFormController.getSelfRegistrationUrl();
	}

	@IsTest
	static void testAuthConfig()
	{
		Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
		System.assertNotEquals(null, authConfig);
	}
}