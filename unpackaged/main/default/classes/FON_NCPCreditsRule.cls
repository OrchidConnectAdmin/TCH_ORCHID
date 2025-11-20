global without sharing class FON_NCPCreditsRule extends Framework.Domain{
    public FON_NCPCreditsRule(List<NCP_Credits__c> sObjectList) {
        super(sObjectList);
    }
    
  	global class Constructor implements Framework.Domain.DomainConstructor {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new FON_NCPCreditsRule(sObjectList);
        }
    }
    
    public override void beforeInsert() {
        Framework.Log.push(FON_NCPCreditsRule.class.getName(), 'beforeInsert');
			FON_NCPCreditService.setDefaults((NCP_Credits__c []) records);
        Framework.Log.pop();
    }
    
    public override void afterInsert(){
        Framework.Log.push(FON_NCPCreditsRule.class.getName(), 'afterInsert');
        
        Integer year = system.today().year();
        Integer cday = system.today().day();
        Integer cmonth = system.today().month();
        
        Set<Id> conIds = new Set<Id>();
        List<OrderApi__Sales_Order__c> lstSoIns = new List<OrderApi__Sales_Order__c>();
        List<OrderApi__Sales_Order_Line__c> lstSolIns = new List<OrderApi__Sales_Order_Line__c>();
        Id ItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credit Filing Fee' LIMIT 1].Id;
        
        	Map<String,Integer> mapCONxYEAR = new Map<String,Integer>();
        	Set<Integer> syears = new Set<Integer>();
        
            for(NCP_Credits__c cred : (NCP_Credits__c []) records){
                if(cred.Status__c == 'Pending for Approval' && cred.FON_Session_Date__c.Year() < year && cmonth < 4){
                    conIds.add(cred.Contact_Name__c);
                    mapCONxYEAR.put(cred.Contact_Name__c,cred.FON_Session_Date__c.Year());
                    syears.add(cred.FON_Session_Date__c.Year());
                }
            }
            
            List<OrderApi__Sales_Order_Line__c> currentSOLS = [Select Id, OrderApi__Item__c,OrderApi__Contact__c FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__r.Name = 'CE Credit Filing Fee' AND OrderApi__Sales_Order__r.OrderApi__Sales_Order_Status__c != 'Paid' AND OrderApi__Contact__c =: conIds ];
            Map<String,Boolean> mapCONxSOL = new Map<String,Boolean>();
        
            if(currentSOLS.size()>0){
                for(OrderApi__Sales_Order_Line__c cSOL : currentSOLS){
                    mapCONxSOL.put(cSOL.OrderApi__Contact__c,true);
                }
            }

            
            for(Id cId : conIds){
                Boolean hasSOL = mapCONxSOL.get(cId);
                if(hasSOL != true){
                    OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
                    so.OrderApi__Contact__c = cId;
                    so.OrderApi__Is_Closed__c = true;
                    so.OrderApi__Is_Proforma__c = true;
                    so.OrderApi__Proforma_Invoice_Email_Sent__c = true;
                    String ddate = mapCONxYEAR.get(cId) + 1 + '-01-01';
                    Date ndate = Date.valueOf(ddate);
                    so.OrderApi__Date__c = Date.valueOf(ddate);
                    so.OrderApi__Due_Date__c = Date.valueOf(ddate);
                    //so.OrderApi__Description__c = ddate;
                    lstSoIns.add(so);
                }

            }
    
            try {
    
                if(!lstSoIns.isEmpty()){
                    insert lstSoIns;
    
                    for(OrderApi__Sales_Order__c so : lstSoIns){
                        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                        sol.OrderApi__Item__c = ItemID;
                        sol.OrderApi__Sales_Order__c = so.Id;
                        lstSolIns.add(sol);
                    }
    
                    if(!lstSolIns.isEmpty()){
                        insert lstSolIns;
                    }
                }
    
            } catch(Exception e) {
                System.debug(e);
            }
            
            //FON_NCPCreditService.createSO((NCP_Credits__c []) records);
        
        
        Framework.Log.pop();
    }
    
    public override void beforeUpdate(Map<Id, SObject> oldMap) {
        Framework.Log.push(FON_NCPCreditsRule.class.getName(), 'beforeUpdate');
			//FON_NCPCreditService.setDefaults((NCP_Credits__c []) records);
        Framework.Log.pop();
    }

    public override void afterUpdate(Map<Id, SObject> oldMap) {
        Framework.Log.push(FON_NCPCreditsRule.class.getName(), 'afterUpdate');

        Integer year = system.today().year();
        Integer cday = system.today().day();
        Integer cmonth = system.today().month();
        
        Set<Id> conIds = new Set<Id>();
        List<OrderApi__Sales_Order__c> lstSoIns = new List<OrderApi__Sales_Order__c>();
        List<OrderApi__Sales_Order_Line__c> lstSolIns = new List<OrderApi__Sales_Order_Line__c>();
        Id ItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credit Filing Fee' LIMIT 1].Id;
        
        	Map<String,Integer> mapCONxYEAR = new Map<String,Integer>();
        	Set<Integer> syears = new Set<Integer>();
        
            for(NCP_Credits__c cred : (NCP_Credits__c []) records){
                if(cred.Status__c == 'Pending for Approval' && cred.FON_Session_Date__c.Year() < year && cmonth < 4){
                    conIds.add(cred.Contact_Name__c);
                    mapCONxYEAR.put(cred.Contact_Name__c,cred.FON_Session_Date__c.Year());
                    syears.add(cred.FON_Session_Date__c.Year());
                }
            }
            
            List<OrderApi__Sales_Order_Line__c> currentSOLS = [Select Id, OrderApi__Item__c,OrderApi__Contact__c FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__r.Name = 'CE Credit Filing Fee' AND OrderApi__Sales_Order__r.OrderApi__Sales_Order_Status__c != 'Paid' AND OrderApi__Contact__c =: conIds ];
            Map<String,Boolean> mapCONxSOL = new Map<String,Boolean>();
        
            if(currentSOLS.size()>0){
                for(OrderApi__Sales_Order_Line__c cSOL : currentSOLS){
                    mapCONxSOL.put(cSOL.OrderApi__Contact__c,true);
                }
            }

            
            for(Id cId : conIds){
                Boolean hasSOL = mapCONxSOL.get(cId);
                if(hasSOL != true){
                    OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
                    so.OrderApi__Contact__c = cId;
                    so.OrderApi__Is_Closed__c = true;
                    so.OrderApi__Is_Proforma__c = true;
                    so.OrderApi__Proforma_Invoice_Email_Sent__c = true;
                    String ddate = mapCONxYEAR.get(cId) + 1 + '-01-01';
                    Date ndate = Date.valueOf(ddate);
                    so.OrderApi__Date__c = Date.valueOf(ddate);
                    so.OrderApi__Due_Date__c = Date.valueOf(ddate);
                    //so.OrderApi__Description__c = ddate;
                    lstSoIns.add(so);
                }

            }
    
            try {
    
                if(!lstSoIns.isEmpty()){
                    insert lstSoIns;
    
                    for(OrderApi__Sales_Order__c so : lstSoIns){
                        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                        sol.OrderApi__Item__c = ItemID;
                        sol.OrderApi__Sales_Order__c = so.Id;
                        lstSolIns.add(sol);
                    }
    
                    if(!lstSolIns.isEmpty()){
                        insert lstSolIns;
                    }
                }
    
            } catch(Exception e) {
                System.debug(e);
            }
            
            //FON_NCPCreditService.createSO((NCP_Credits__c []) records);
                   
        
        Framework.Log.pop();
    }
    
    
}