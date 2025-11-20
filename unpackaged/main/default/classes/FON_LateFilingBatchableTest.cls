@IsTest
public class FON_LateFilingBatchableTest {
    
    @IsTest
    public static void batch_Test(){
        Account acct2 = new Account();
        acct2.Name = 'Acc1358&*';
        insert acct2;
        
        Contact con = new contact(LastName='Test Con',AccountId = acct2.Id);
        insert con;
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.Name = 'Test BG';
        insert bg;
                       
        //create item class
        OrderApi__Item_Class__c ic = new OrderApi__Item_Class__c();
        ic.Name = 'Item Class';
        ic.OrderApi__Is_Active__c = true;
        insert ic;
        
        // create subs item
        OrderApi__Item__c sit = new OrderApi__Item__c();
        sit.Name = 'CE Credit Filing Fee';
        sit.OrderApi__Item_Class__c = ic.Id;
        sit.OrderApi__Business_Group__c = bg.Id;
        sit.OrderApi__Is_Active__c = true;
        insert sit;
        
        // create item
        OrderApi__Item__c it = new OrderApi__Item__c();
        it.Name = 'CE Credits – Late Filing Fee';
        it.OrderApi__Item_Class__c = ic.Id;
        it.OrderApi__Business_Group__c = bg.Id;
        it.OrderApi__Is_Active__c = true;
        insert it;
        
        
        //Test.startTest();
        
    	OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Contact__c = con.Id;
        so.OrderApi__Account__c = acct2.Id;
        so.OrderApi__Business_Group__c = bg.Id;
        so.OrderApi__Entity__c = 'Contact';
        so.OrderApi__Status__c = 'Open';
        insert so;
        
        List<OrderApi__Sales_Order_Line__c> sols = new List<OrderApi__Sales_Order_Line__c>();
    	
		OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c(); 
        sol.OrderApi__Account__c = acct2.Id;
        sol.OrderApi__Contact__c = con.Id;
        sol.OrderApi__Quantity__c = 1;
        sol.OrderApi__Sales_Order__c = so.Id;
        sol.OrderApi__Entity__c = 'Contact';
        sol.OrderApi__Item__c = sit.Id;
        insert sol;
        
        
        Test.startTest();
        FON_LateFilingBatchable obj = new FON_LateFilingBatchable();

        FON_LateFilingBatchableSchedule myClass = new FON_LateFilingBatchableSchedule();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, myClass);
        
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}