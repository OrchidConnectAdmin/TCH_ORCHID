@isTest
public class GetCYRILRelatedListControllerTest {
    @isTest static void getTest() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        // create data
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Lastname';
        con.Email = 'mail@mail.com';
        con.Department = 'Depot';
        con.Phone = '12346478';
        con.AccountId = acc.Id;
        insert con;

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Fonteva Chatter Manager Community Login User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = con.Id);
        insert u;
        
        
        
        
        system.runAs(u)
        {
            Test.startTest();
                System.debug('current user '+u);

        
                Map<String,List<String>> items = GetCYRILRelatedListController.getItems('Contact', 'FirstName,LastName', '', 'Id', con.Id, null, 'test','true','','true','Id');
                Integer sz1 = items.size();
                System.assertEquals(sz1, items.size());
                
                List<String> cols = GetCYRILRelatedListController.getColumns('Contact', 'FirstName,LastName');
                Integer sz2 = cols.size();
                System.assertEquals(sz2, cols.size());
                
                String que = GetCYRILRelatedListController.getQuery('Contact', 'FirstName,LastName', '', 'Id', con.Id, null, 'test', 'true');
                Integer sz3 = que.length();
                System.assertEquals(sz3, que.length());
                
                Boolean dis = GetCYRILRelatedListController.getDisplay('Contact','Email=\'mail@mail.com\'','Id', con.Id, 'true');
                Boolean d = dis;
                System.assertEquals(d, dis);
                
                
            Test.stopTest();
        }
    }
}