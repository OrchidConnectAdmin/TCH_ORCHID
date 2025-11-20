@isTest
private class GetCYRILSearchAddRecordControllerTest {

    @TestSetup
    static void setup() {
        
        Account account = new Account(Name = 'Test Account',Sic='Test');
        insert account; 
        
        Contact contact = new Contact(AccountId = account.Id, Email = 'test@email.com', FirstName = 'FirstName', LastName = 'LastName',
            Phone = '(111) 111-1111',
            MailingPostalCode = '11111-1111'); 
        //insert contact; 
    }
    
    /*@isTest
    private static void searchListTest() {
        
        Test.startTest();
        
        Account contact = [SELECT Name FROM Account LIMIT 1];
        
        List<Account> contacts = GetCYRILSearchAddRecordController.searchList(contact.Name);
                    
        Boolean catchException = false;
        
        try {
            
            GetCYRILSearchAddRecordController.searchList('Fonteva');
            
        } catch(exception e) {
            
            catchException = true;
        }
        
      	System.assert(!contacts.isEmpty(), 'Contact was not found');
		System.assert(catchException, 'Exception was not catched');
        
        Test.stopTest();
    }  */
    
    @isTest
    private static void getFieldSetTest() {
        
        Test.startTest();
        
         GetCYRILSearchAddRecordController.getFieldSet('', 'Account');
        
        Test.stopTest();
    }
    
    @isTest
    private static void getRecTest() {
        DateTime dtYesterday = system.Now().addDays(-1);
        DateTime dt = datetime.newInstance(dtYesterday.year(), dtYesterday.month(), dtYesterday.day());
        String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        List<SObject> rec = GetCYRILSearchAddRecordController.getRecords('Sic', 'Account', 'Id,Name', 'Sic','CreatedDate', ' AND CreatedDate >'+formattedDt, 10, 'Contact', 'Name', 'Sic','Sic != null', 'Exclude', null, null, null);
        Integer cnt = rec.size();
        system.AssertEquals(cnt,rec.size());
    }
    
    @isTest
    private static void getReadFieldSetTest() {
        List<Schema.FieldSetMember> rec = GetCYRILSearchAddRecordController.readFieldSet('LTE__Demo_Field_Set', 'Account');
        system.Assert(rec.size() > 0);
    }
    
    @isTest
    private static void getEntryFieldsTest() {
        Map<String,Map<Integer,Map<String,String>>> rec = GetCYRILSearchAddRecordController.getEntryFields('Account', 'LTE__Demo_Field_Set');
        system.Assert(rec != null);
    }
}