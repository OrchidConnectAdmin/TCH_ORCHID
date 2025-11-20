@isTest(SeeAllData=True)
public class GetCYRILRecordDetailsControllerTest {
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

        
            String ob = GetCYRILRecordDetailsController.getObject(con.Id);
            System.assertEquals('Contact', ob);
            
            Map<String,Map<Integer,Map<String,String>>> phead = GetCYRILRecordDetailsController.getPageHeader(con.Id, 'FirstName', 'LastName');
            Integer sz1 = phead.size();
            System.assertEquals(sz1, phead.size());
            
            Map<String,Map<Integer,Map<String,String>>> col1 = GetCYRILRecordDetailsController.getColumnData1(con.Id, 'Contact_Information');
            Integer cz1 = col1.size();
            System.assertEquals(cz1, col1.size());
            
            Map<String,Map<Integer,Map<String,String>>> col2 = GetCYRILRecordDetailsController.getColumnData2(con.Id, 'Contact_Information');
            Integer cz2 = col2.size();
            System.assertEquals(cz2, col2.size());
            
            Map<String,Map<Integer,Map<String,String>>> col3 = GetCYRILRecordDetailsController.getColumnData3(con.Id, 'Contact_Information');
            Integer cz3 = col3.size();
            System.assertEquals(cz3, col3.size());
            
            Map<String,Map<Integer,Map<String,String>>> col4 = GetCYRILRecordDetailsController.getColumnData4(con.Id, 'Contact_Information');
            Integer cz4 = col4.size();
            System.assertEquals(cz4, col4.size());
                
                
            Test.stopTest();
        }
    }
}