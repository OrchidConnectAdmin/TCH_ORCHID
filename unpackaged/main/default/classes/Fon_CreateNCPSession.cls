/**
 * THis is the class which is associated with the Fon_CreateNCPSession lightning component
 */
public without sharing class Fon_CreateNCPSession {
    
    // This method will be called when component is loaded
    @AuraEnabled
    public static OnLoadWrapper handleComponentLoad(){
        
        // getting contact of current user which is logged in
        String ContactId = Fon_CEInfoCntrl.fetchCurrentlogged();
        system.debug('\n--ContactId--'+ContactId);
        
        string AccId = fetchCurrentloggedAccount();
        
        // getting aplication record
        Application__c applciation = fetchApplication(ContactId, AccId);
        system.debug('\n--applciation--'+applciation);        
               
        // getting the sales order
        OrderApi__Sales_Order__c so = fetchSalesOrder(ContactId,applciation);
        system.debug('\n--so--'+so);
        
        // this is going to be pull the session for the contact
        List<NCP_Sessions__c> lstSession= fetchContactSession(ContactId);
        system.debug('\n--lstSession--'+lstSession);
        
        
        // making instance of the wrapper to be returned
        return new OnLoadWrapper(applciation, so, lstSession, ContactId, AccId);        
    }
     
    
    // code to get the Session based on login user contact id
 	private static List<NCP_Sessions__c> fetchContactSession(string ContactId){
        return [SELECT ID,
                        Name,
                        Session_ID__c,
                        Account__c,Account__r.Name,
                        App_Fee_Submitting__c,
                		Application_Number__c,
                		Is_Paid__c,
                        Application__c,Concurrent_Session__c,
                        Contact__c,Credit_Val__c,Contact__r.Name,
                        Description__c,Held_in_Conjunction__c,
                        Instructor__c,Instructor_Title__c,
                        Minutes_EDU_Submitting__c,
                        Provider_Name__c,Provider_Notes__c,
                        Sales_Order__c,FON_Sales_Order_Line__c,                        
                        Series_Name__c,
                        Session_Date__c,Session_Time__c,                       
                        Session_Type__c,
                		Files_Uploaded__c,
                        Session_Type_for_ID__c,Status__c,Year__c
                	FROM NCP_Sessions__c
               	 	WHERE Contact__c =: ContactId
                    ORDER BY CreatedDate DESC];
    }
    
    // code to get the application else create the application
    private static Application__c fetchApplication(string ContactId, string AccId){
        
        // getting the latest applciation
        List<Application__c> lstApplication = [SELECT ID,
                                                        Application_number__c
                                               		FROM Application__c 
                                                    WHERE Contact__c =: ContactId 
                                               		AND IsPaid__c = false LIMIT 1];
        // if we have the applciation record then return it
        if(!lstApplication.isEmpty()){
            return lstApplication[0];
        }
        
        // code to create new application
        else{
            lstApplication = [SELECT ID,
                                      	Application_number__c
                                	FROM Application__c
                                	WHERE Application_number__c != null
                                	Order By CreatedDate desc LIMIT 1];
            
            // this will save the application number
            Integer applicationNum = 1;
            if(!lstApplication.isEmpty()){
                applicationNum = Integer.valueOf(lstApplication[0].Application_number__c) + 1;
            }
            
            // code to create new application
            Application__c application = new Application__c();
            application.Contact__c = ContactId;
            application.Account__c = AccId;
            application.Application_number__c = string.valueOf(applicationNum);
            application.IsPaid__c = false;
            insert application;
            return application;
        }
    }
    
    // code to get the application else create the application
    private static OrderApi__Sales_Order__c fetchSalesOrder(string ContactId,Application__c applciation){
        
        // pulling sales order based uon contact
        List<OrderApi__Sales_Order__c> lstSO = [SELECT ID
                                                    FROM OrderApi__Sales_Order__c
                                                    WHERE OrderApi__Contact__c =: ContactId
                                                    AND Application__c =: applciation.Id];
        
        // if contact is found then return 
        if(!lstSO.isEmpty()){            
            return lstSO[0];
        }
        
        // if no SO is found then create the new on
        else{
            OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
            so.OrderApi__Contact__c = ContactId;
            so.Application__c = applciation.Id;
            insert so;
            return so;
        }        
        
    }
    
    Public class OnLoadWrapper{
        @AuraEnabled public Application__c applicationRecord {get;set;}
        @AuraEnabled public OrderApi__Sales_Order__c salesOrderRecord {get;set;}
        @AuraEnabled public List<NCP_Sessions__c> lstSession {get;set;}
        @AuraEnabled public string conId {get;set;}
        @AuraEnabled public string AccountId {get;set;}
        
        // constructor
        public OnLoadWrapper(Application__c applicationRecord, OrderApi__Sales_Order__c salesOrderRecord, List<NCP_Sessions__c> lstSession, string conId, string accId){
            this.applicationRecord = applicationRecord;
            this.salesOrderRecord = salesOrderRecord;
            this.lstSession = lstSession;
            this.conId = conId;
            this.AccountId =  accId;
        }
    }
    
    // method will be used to fetch ncp sesion record based on their parent application record and contact id 
    private static List<NCP_Sessions__c> fetchSessionRec(String ContactId){
        return [SELECT Id,
                		Application__c,
                		Credit_Val__c,
                		App_Fee_Submitting__c,
                		Application_Number__c,
                		Application__r.IsPaid__c,
                		FON_Sales_Order_Line__c
                	FROM NCP_Sessions__c
                	WHERE Contact__c =: ContactId
                	AND Application__r.IsPaid__c = false];
    }

	private static string  fetchCurrentloggedAccount(){
        string currentloginuserId = UserInfo.getUserId();
        List<User> userList = [SELECT Id,ContactId,contact.accountId FROM User WHERE Id =: currentloginuserId];
        return userList[0].contact.accountId;
    }
    
    // this method will be used to insert sales Order line records.
    @auraEnabled
    public static void createSalesOrderLines(OrderApi__Sales_Order__c sORec){
        System.debug('sORec : '+ sORec);
        if(sORec != null){
            
            // this will save the session to be updated with SOL
            List<NCP_Sessions__c> lstUpdateSession = new List<NCP_Sessions__c>();
            
            // getting contact of current user which is logged in
            String ContactId = Fon_CEInfoCntrl.fetchCurrentlogged();
            system.debug('\n--ContactId--'+ContactId);
            
            // getting contact Information
            contact conDetails = [SELECT Partner_External_Provider__c 
                                 		FROM Contact where Id =: ContactId];
            
            //getting ncp session records
            List<NCP_Sessions__c> ncpSessionList = fetchSessionRec(ContactId);
            System.debug('\n--ncpSessionList--'+ ncpSessionList);
            
            // getting items
            List<OrderApi__Item__c> lstItem = [SELECT ID 
                                               		FROM OrderApi__Item__c 
                                               		WHERE NAME = 'NCP Session Application Fee'];
            
            // Create Sales Order Line Records
            if(!ncpSessionList.isEmpty()
              	&& !lstItem.isEmpty()){
                    
                List<OrderApi__Sales_Order_Line__c> salesOrdrLineList = new List<OrderApi__Sales_Order_Line__c>();
                system.debug('\n--sess.FON_Sales_Order_Line__c--'+salesOrdrLineList);
                for(NCP_Sessions__c sess : ncpSessionList){
                    system.debug('\n--sess.FON_Sales_Order_Line__c--'+sess.FON_Sales_Order_Line__c);
                    
                    // adding SOL if the sales order line is not added
                    if(sess.FON_Sales_Order_Line__c == null){                        
                        OrderApi__Sales_Order_Line__c sOL = new OrderApi__Sales_Order_Line__c();
                        sOL.OrderApi__Sales_Order__c = sORec.Id;
                        sOL.OrderApi__Price_Override__c = true;
                        if(conDetails.Partner_External_Provider__c != 'Partner'){
                            sOL.OrderApi__Sale_Price__c = sess.App_Fee_Submitting__c;
                        }
                        else{
                           sOL.OrderApi__Sale_Price__c = 0; 
                        }
                        
                        sOL.OrderApi__Item__c = lstItem[0].Id;
                        salesOrdrLineList.add(sOL);
                        
                        // update the session list with SOL Id
                        sess.FON_Sales_Order_Line__r = sOL;
                        lstUpdateSession.add(sess);
                    }
                }
                
                // Insert Sales Order Line Records
                if(!salesOrdrLineList.isEmpty()){
                    insert salesOrdrLineList;
                    
                    // update session with SOL Lines
                    for(NCP_Sessions__c session : lstUpdateSession){
                        session.FON_Sales_Order_Line__c = session.FON_Sales_Order_Line__r.Id;
                        session.FON_Sales_Order_Line__r = null;
                    }
                    
                    update lstUpdateSession;
                }                
            }
        }
    }
    
    
    @auraEnabled
    public static void createCloneNCPSession(NCP_Sessions__c sess){
        
        System.debug('sess :-'+ sess);
        if(sess != null){
            insert sess;
            System.debug('sess :-'+ sess);
        }
    }
    
    @auraEnabled
    public static void checkUploaded(String rid){
        
        NCP_Sessions__c ns = [SELECT Id,Files_Uploaded__c FROM NCP_Sessions__c WHERE Id =: rid];
        ns.Files_Uploaded__c = true;
        update ns;
    }
}