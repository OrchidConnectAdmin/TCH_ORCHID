@IsTest
public class FON_AccountSearchControllerTest {

     @testSetup static void createData() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
        Contact cont = new contact(LastName='Test Cont',AccountId = acc.Id);
        insert cont;
        
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
        
     }
    
    @IsTest
    public static void cover_All(){
         User u = [SELECT Id FROM User WHERE Email = 'puser000@amamama.com'];
         Account accRec = [SELECT Id FROM Account Where Name='Test Acc' LIMIT 1];
       Contact con = [SELECT Id FROM Contact Where LastName='Test Con' LIMIT 1];
        
         System.runAs(u) {
             FON_AccountSearchController fAccSc = new FON_AccountSearchController();
             fAccSc.strSearchTxt = 'Test Acc';
             fAccSc.fetchAccount();
             fAccSc.strAccountSearchTxt = 'Test Acc';
             fAccSc.fetchAccountByName();
             fAccSc.selectedAcc = accRec.id;
             
             
             ApexPages.currentPage().getParameters().put('Id',accRec.id);
             try{
                 fAccSc.nextStep();
             }catch(exception ex){
                 
             }
             
             try{
                 fAccSc.backButton();
             }catch(exception ex){
                 
             }
             

             
             
             //
             //fAccSc.nextStep();
         }
    }
}