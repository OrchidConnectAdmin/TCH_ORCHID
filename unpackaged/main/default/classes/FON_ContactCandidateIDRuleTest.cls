@isTest
public class FON_ContactCandidateIDRuleTest {
    
    @TestSetup
    private static void install() {

        Framework.Installer.install();
        /* PagesApi.PackageScripts.install();
        OrderApi.PackageScripts.install();
        EventApi.PackageScripts.install();
        ROEApi.PackageScripts.install();
        CPBase.PackageScripts.install();
        LTE.PackageScripts.install(); */

        Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
        Framework.RoutingRule accountJoinDateUpdate = new Framework.RoutingRule();
        accountJoinDateUpdate.apexClass = FON_ContactCandidateIDRule.class.getName();
        accountJoinDateUpdate.namespace = '';
        accountJoinDateUpdate.isEnabled = true;
        accountJoinDateUpdate.sObjectName = 'Contact';
        accountJoinDateUpdate.executionOrder = 0;
        rules.add(accountJoinDateUpdate);
        Framework.Config.push(rules);
    }
    
    @isTest static void getTest() {
        
        Contact con = new contact(FirstName= 'Test name',Email='test125@mailinator.com',LastName='Test Con');
        insert con;

        con.FON_NCP_Candidate_ID__c = 'HRNCP230040';
		update con;

        //system.runAs(u)
        //{
            //Test.startTest();
                
            
            //Test.stopTest();
        //}
        
    }
}