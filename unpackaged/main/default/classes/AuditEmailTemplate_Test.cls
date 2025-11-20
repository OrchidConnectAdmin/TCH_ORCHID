@IsTest
public class AuditEmailTemplate_Test {

    @testSetup static void createData() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ECCHO Account').getRecordTypeId();
        
        Account acc = new Account(recordtypeId = devRecordTypeId,Name = 'Test Acc');
        insert acc;
        
        Contact con = new contact(LastName='Test Con',AccountId = acc.Id);
        insert con;
        
          OrderApi__Item__c itme = new OrderApi__Item__c();
        itme.Name = 'CE Credits – Late Filing Fee';
        insert itme;
        
        OrderApi__Item_Class__c itemclas = new OrderApi__Item_Class__c();
        itemclas.Name = 'item class';
        insert itemclas;
        
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.Name = 'item';
        item.OrderApi__Item_Class__c = itemclas.Id;
        insert item;
        
        OrderApi__Sales_Order__c slordr = new OrderApi__Sales_Order__c();
        insert slordr;
            
            
        OrderApi__Sales_Order_Line__c sodrline = new OrderApi__Sales_Order_Line__c();
        sodrline.OrderApi__Item_Class__c = itemclas.Id;
        sodrline.OrderApi__Item__c = item.Id;
        sodrline.OrderApi__Sales_Order__c = slordr.Id;
        insert sodrline;
        
        ProgramApi__Program__c pp = new ProgramApi__Program__c();
        pp.Name = 'NCP';
         pp.ProgramApi__Entity__c = 'Contact';
        insert pp;
        
        ProgramApi__Program_Profile__c ppp = new ProgramApi__Program_Profile__c();
        ppp.ProgramApi__Account__c = acc.Id;
        ppp.ProgramApi__Contact__c = con.Id;
        ppp.FON_Program_Start_Date__c = System.today();
        ppp.FON_Program_End_Date__c = System.today();
        ppp.Allowed_Workshops__c = 3;
        ppp.Allowed_Credits__c = 2;
        ppp.ProgramApi__SalesOrderLineId__c = sodrline.Id;
        ppp.ProgramApi__Program__c = pp.Id;
        ppp.FON_Exam_Results__c = 'Fail';
        insert ppp;
        
        
        ProgramApi__Program_Term__c ppt = new ProgramApi__Program_Term__c();
        ppt.ProgramApi__Profile__c = ppp.Id;
        insert ppt;
        
    }
    
    
    @IsTest
    public static void cover_All(){
      ProgramApi__Program_Profile__c  ppRec = [SELECT Id FROM ProgramApi__Program_Profile__c];
        AuditEmailTemplate at = new AuditEmailTemplate();
        at.progProfileRec = ppRec;
        at.getprogProfileDetails();
        at.getlstTableData();
    }
}