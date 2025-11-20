@isTest
public class CYRILExportDataCSVControllerTest {
    @isTest static void getTest() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
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
            
                PageReference pageRef = Page.CYRILExportDataCSV;
                Test.setCurrentPage(pageRef);
            	System.currentPageReference().getParameters().put('fld','Name');
            	System.currentPageReference().getParameters().put('obj','Contact');
            	System.currentPageReference().getParameters().put('whr','Id!=null'); 
            	System.currentPageReference().getParameters().put('title','My Contacts');  
            
                CYRILExportDataCSVController gpdf = new CYRILExportDataCSVController();
                System.debug('Test1xxx' + gpdf );
            
            	Map<Integer,List<String>> items= gpdf.items;
            	Integer sz1 = items.size();
            	System.assertEquals(sz1, items.size());
            
            	List<String> cols = gpdf.columns;
            	Integer sz2 = cols.size();
            	System.assertEquals(sz2, cols.size());
            
            
            Test.stopTest();
        }
        
    }
}