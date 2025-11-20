@IsTest
public class FON_AprilBatchJob_Test {

    @IsTest
    public static void coverAll(){
    
        OrderApi__Item_Class__c itemclas = new OrderApi__Item_Class__c();
        itemclas.Name = 'item class';
        insert itemclas;
    
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.Name = 'CE Credit Filing Fee';
        item.OrderApi__Item_Class__c = itemclas.Id;
        insert item;
        
        OrderApi__Item__c item1 = new OrderApi__Item__c();
        item1.Name = 'CE Credits – Late Filing Fee';
        item1.OrderApi__Item_Class__c = itemclas.Id;
        insert item1;
        
        
        OrderApi__Sales_Order__c slordr = new OrderApi__Sales_Order__c();
        insert slordr;
            
            
        OrderApi__Sales_Order_Line__c sodrline = new OrderApi__Sales_Order_Line__c();
        sodrline.OrderApi__Item_Class__c = itemclas.Id;
        sodrline.OrderApi__Item__c = item.Id;
        sodrline.OrderApi__Sales_Order__c = slordr.Id;
        insert sodrline;
    
        database.executebatch(new FON_AprilBatchJob());
        
    }
}