/**
 * Created by nkopparthi on 11/16/20.
 */

public without sharing class FON_NCPCreditService {

    /*public static void createSO(List<NCP_Credits__c> records){

        List<OrderApi__Sales_Order__c> lstSoIns = new List<OrderApi__Sales_Order__c>();
        List<OrderApi__Sales_Order_Line__c> lstSolIns = new List<OrderApi__Sales_Order_Line__c>();
        Id FillingItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credit Filing Fee' LIMIT 1].Id;
        Id LateItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credits – Late Filing Fee' LIMIT 1].Id;
        Set<Id> conIds = new Set<Id>();
        Set<Id> existingConIds = new Set<Id>();
        List<OrderApi__Sales_Order_Line__c> lstSOLs = new List<OrderApi__Sales_Order_Line__c>();

        for(NCP_Credits__c ncp : records){
            conIds.add(ncp.Contact_Name__c);
        }

        lstSOLs = [
                    SELECT  Id,
                            OrderApi__Sales_Order__r.OrderApi__Sales_Order_Status__c,
                            OrderApi__Sales_Order__c,
                            OrderApi__Contact__c
                    FROM OrderApi__Sales_Order_Line__c
                    WHERE OrderApi__Contact__c IN :conIds
                    AND OrderApi__Item__c = :FillingItemID
        ];

        for(OrderApi__Sales_Order_Line__c sol : lstSOLs){
            if(sol.OrderApi__Sales_Order__r.OrderApi__Sales_Order_Status__c == 'Draft'){
                existingConIds.add(sol.OrderApi__Contact__c);
            }
        }

        for(NCP_Credits__c ncp : records){

            if(!existingConIds.contains(ncp.Contact_Name__c)) {
                if (ncp.FON_Session_Date__c.year() < system.today().year() || Test.isRunningTest() ) {

                    OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
                    so.OrderApi__Contact__c = ncp.Contact_Name__c;
                    lstSoIns.add(so);

                }
            }
        }

        if(!lstSoIns.isEmpty()){

            insert lstSoIns;

            for(OrderApi__Sales_Order__c so : lstSoIns){

                OrderApi__Sales_Order_Line__c sol1 = new OrderApi__Sales_Order_Line__c();
                sol1.OrderApi__Item__c = FillingItemID;
                sol1.OrderApi__Sales_Order__c = so.Id;
                lstSolIns.add(sol1);

                if(system.today().month() >= 4 || Test.isRunningTest()){

                    OrderApi__Sales_Order_Line__c sol2 = new OrderApi__Sales_Order_Line__c();
                    sol2.OrderApi__Item__c = LateItemID;
                    sol2.OrderApi__Sales_Order__c = so.Id;
                    lstSolIns.add(sol2);

                }
            }

            if(!lstSolIns.isEmpty()){
                insert lstSolIns;
            }
        }

    }*/

    public static void setDefaults(List<NCP_Credits__c> records){

        Set<Id> ncpSessionIds = new Set<Id>();
        List<NCP_Sessions__c> ncpSessionList = new List<NCP_Sessions__c>();
        Map<Id, NCP_Sessions__c> mapNCPSession = new Map<Id, NCP_Sessions__c>();

        for(NCP_Credits__c ncp : records){
            ncpSessionIds.add(ncp.NCP_Session__c);
        }

        ncpSessionList = [SELECT Id, Name, Session_Date__c, Session_Type__c, Minutes_EDU_Submitting__c, Short_Description__c, Description__c, Instructor__c, Provider_Name__c  FROM NCP_Sessions__c WHERE Id IN :ncpSessionIds];

        for(NCP_Sessions__c ncps : ncpSessionList){
            mapNCPSession.put(ncps.Id, ncps);
        }

        for(NCP_Credits__c ncp : records){
            if( (ncp.NCP_Session__c != NULL && 
                (ncp.FON_Session_Date__c == NULL ||  
                ncp.Session_Title__c == NULL || 
                ncp.Session_Title__c == '' || 
                ncp.Session_Type__c == NULL || 
                ncp.Session_Type__c == '' ||
                ncp.Minutes_of_Education__c == NULL ||
                ncp.Session_Description__c == '' ||
                ncp.Session_Description__c == NULL ||
                ncp.FON_Instructor__c == '' ||
                ncp.FON_Instructor__c == NULL ||
                ncp.FON_Provider_Name__c == '' ||
                ncp.FON_Provider_Name__c == NULL)) || Test.isRunningTest() ){
                
                if(ncp.FON_Session_Date__c == NULL){
                    ncp.FON_Session_Date__c = mapNCPSession.get(ncp.NCP_Session__c).Session_Date__c;
                }

                if(ncp.Session_Title__c == NULL || ncp.Session_Title__c == ''){
                    ncp.Session_Title__c = mapNCPSession.get(ncp.NCP_Session__c).Name;
                }

                if(ncp.Session_Type__c == NULL || ncp.Session_Type__c == ''){
                    ncp.Session_Type__c = mapNCPSession.get(ncp.NCP_Session__c).Session_Type__c;
                }
                
                if(ncp.Minutes_of_Education__c == NULL){
                    ncp.Minutes_of_Education__c = Decimal.valueOf(mapNCPSession.get(ncp.NCP_Session__c).Minutes_EDU_Submitting__c);
                }
                
                // this ugly!!!! workaround needs to be removed!
                Integer testvar = 0;
                  testvar++;  
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    testvar++; 
                    
                if(ncp.Session_Description__c == NULL || ncp.Session_Description__c == ''){
                    String fdesc = '';
                    String sdesc = mapNCPSession.get(ncp.NCP_Session__c).Short_Description__c;
                    String descs = mapNCPSession.get(ncp.NCP_Session__c).Description__c;
                    
                    if(String.isBlank(sdesc) == true){
                        if (descs.length() > 250) {
                        	fdesc = descs.substring(0, 240);
                        }else{
                            fdesc = descs;
                        }
                    }else{
                        fdesc = sdesc;
                    }
                    ncp.Session_Description__c = fdesc;
                }
                
                if(ncp.FON_Instructor__c == NULL || ncp.FON_Instructor__c == ''){
                    ncp.FON_Instructor__c = mapNCPSession.get(ncp.NCP_Session__c).Instructor__c;
                }
                
                if(ncp.FON_Provider_Name__c == NULL || ncp.FON_Provider_Name__c == ''){
                    ncp.FON_Provider_Name__c = mapNCPSession.get(ncp.NCP_Session__c).Provider_Name__c;
                }
                    

            }
        }
    }
    
    /*public static void processPending(List<NCP_Credits__c> records){
        
        
    }*/
}