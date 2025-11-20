@isTest 
private class Fon_Contact_ServiceTest {
    public static Boolean isInstalled = false;
        
        private static void install() {
            if (!isInstalled) {
                //Fon_PackageScripts.install();
                Framework.Installer.install();
                PagesApi.PackageScripts.install();
                OrderApi.PackageScripts.install();
                 EventApi.PackageScripts.install();
                
                // Create a routing rule for Contact
                Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
                Framework.RoutingRule cons = new Framework.RoutingRule();
                cons.apexClass = Fon_Contact_Trigger.class.getName();
                cons.namespace = '';
                cons.isEnabled = true;
                cons.sObjectName = 'Contact';
                cons.executionOrder = 0;
                rules.add(cons);
                Framework.Config.push(rules);               
                
                isInstalled = true;
               
            }
        }
        
    static testMethod void TestUpdateUsername() {
        
        install();
        
        Account acc = new Account();
        acc.name = 'AccName';
        insert acc;
        
        Contact con1 = new Contact();
        con1.Lastname = 'con1Lastname';
        con1.Firstname = 'testdata';
        con1.Email = 'test1@email.com';
        con1.AccountId = acc.ID;
        insert con1;
        
        Profile p = [select Id, Name from Profile where Name IN ('Fonteva Customer Community Login User') limit 1];
        
        User newUser = new User(
             profileId = p.id,
             username = 'newUser@yahoo.com',
             emailencodingkey = 'UTF-8',
             localesidkey = 'en_US',
             languagelocalekey = 'en_US',
             timezonesidkey = 'America/Los_Angeles',
             alias='nuser',
             lastname='lastname',
             contactId = con1.id
        );
        newUser.Email = 'test1@email.com';
        insert newUser;
       
            Test.startTest();
            con1.email = 'test222@email.com';
           
            
             update con1;
            Test.stopTest();
       
        
   }
}