@IsTest
public class SendEmailContact_Test {

    @IsTest
    public static void covel_All(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id,FON_Exam_Results__c='Fail');
        insert con;
        
        List<Contact> conList = new List<Contact>();
        conList.add(con);
        
        Test.startTest();
        Test.setCurrentPage(Page.UpdateContactSendEmailField);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(conList);
        stdSetController.setSelected(conList);
        SendEmailContact ext = new SendEmailContact(stdSetController);
        ext.updateContactRecords();
        ext.redirect();
        Test.stopTest();
    }
}