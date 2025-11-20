@isTest
public class CHA_ProgramTermsBatchableTest {
    @isTest static void testTerms(){
        Contact con = new Contact();
        con.LastName = 'conLast';
        con.FirstName = 'conFirst';
        con.Email = 'conEmail@mail.com';
        insert con;
        
        ProgramApi__Program_Term__c pt1 = new ProgramApi__Program_Term__c();
        pt1.ProgramApi__Start_Date__c = Date.Today().addDays(-30);
        pt1.ProgramApi__End_Date__c = Date.Today().addDays(-10);
        pt1.ProgramApi__Active__c = true;
        insert pt1;
        
        ProgramApi__Program_Term__c pt2 = new ProgramApi__Program_Term__c();
        pt2.ProgramApi__Start_Date__c = Date.Today();
        pt2.ProgramApi__End_Date__c = Date.Today().addDays(+90);
        pt2.ProgramApi__Active__c = false;
        insert pt2;
        
        Test.startTest();
        
        	CHA_ProgramTermsBatchable bt = new CHA_ProgramTermsBatchable();
        	Id btID = Database.executeBatch(bt);
        
        Test.stopTest();
    }
}