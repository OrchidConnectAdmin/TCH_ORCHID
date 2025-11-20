public class Fon_TestDataFactory {
    
    public static Account createAccount(string accName){
        Account acc = new Account();
        acc.name = accName;
        return acc; 
    }
    public static Contact createContact(string fName,string lName){
        Contact con = new Contact();
        con.FirstName = fName;
        con.LastName = lName;
        return con;
    }
    public static ProgramApi__Program__c createProgram(string entity,string pName){
        ProgramApi__Program__c pgm = new ProgramApi__Program__c();
        pgm.ProgramApi__Entity__c = entity;
        pgm.Name = pName;
        return pgm;
    }
    public static OrderApi__Item__c createItem(string itemName,Id itemClassId){
        
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.Name = itemName;
        item.OrderApi__Is_Active__c = true;
        item.OrderApi__Item_Class__c = itemClassId;
        return item;
        
    }
    
    public static OrderApi__Item_Class__c createItemClass(string className){
        
        OrderApi__Item_Class__c itemCls = new OrderApi__Item_Class__c();
        itemCls.Name = className;
        itemCls.OrderApi__Is_Active__c = true;
        return itemCls;
        
    }
}