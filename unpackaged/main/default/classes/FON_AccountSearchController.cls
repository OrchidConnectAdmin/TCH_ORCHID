/**
 * This is the apex class for the VF page Fon_AccountSearch and is a copy of FON_AccountSearchCntrl, in attempt to make the next path generic instead of using custom labels
 **/
global without sharing class FON_AccountSearchController extends PagesApi.DefaultTemplateController{
    
    // this will save the searchTxt
    public string strSearchTxt {get;set;}
    
    // this will save the searchTxt
    public string strAccountSearchTxt {get;set;}
    
    // this will be used to save the searched accounts
    public List<Account> lstSearchedAccounts {get;set;}
    
    // this will save the logged user details
    public User usrRec {get;set;}
    
    // this will save the selected acc Id
    public string selectedAcc {get;set;}
    
    
    // constructor
    public FON_AccountSearchController(){
        this.lstSearchedAccounts = new List<Account>();
        this.strSearchTxt = '';
        this.usrRec = new User();
        
        // code to fetch logged in user details
        usrRec = fetchCurrentUserContact();
    }
    
   
    public void fetchAccountByName(){
        system.debug('\n--strAccountSearchTxt--'+strAccountSearchTxt);
        String query = 'SELECT Id,Name,BillingCountry,BillingPostalCode,BillingState,BillingCity,BillingStreet,Primary_R_T_Number__c FROM Account WHERE Name LIKE \'%'+strAccountSearchTxt+'%\' LIMIT 100';
		lstSearchedAccounts = Database.query(query);
        /*lstSearchedAccounts = [SELECT Id,
                                       Name,
                                        BillingCountry,
                                        BillingPostalCode,
                                        BillingState,
                                        BillingCity,
                                        BillingStreet,
                                        Primary_R_T_Number__c
                                FROM Account
                                WHERE Name = :strAccountSearchTxt
                                LIMIT 100];*/
    }
    
    // this is the method which wil be used to pull the account
    public void fetchAccount(){
        system.debug('\n--strSearchTxt--'+strSearchTxt);
        
        // if the search string is blank then return
        if(string.isBlank(strSearchTxt)){
            return ;
        }
       
        lstSearchedAccounts = [SELECT Id,
                                        Name,
                                        BillingCountry,
                                        BillingPostalCode,
                                        BillingState,
                                        BillingCity,
                                        BillingStreet,
                                        Primary_R_T_Number__c
                                    FROM Account
                                    WHERE Primary_R_T_Number__c = :strSearchTxt
                                    AND Primary_R_T_Number__c != null
                                    LIMIT 100];
        
        system.debug('\n--lstSearchedAccounts--'+lstSearchedAccounts);
        
        if(lstSearchedAccounts == null 
            || lstSearchedAccounts.isEmpty()){            
            fetchAccountDetails();
        }
    }  
    
    // fetch acc Id by RT Number by search key
    public void fetchAccountDetails(){
        system.debug('\n--strSearchTxt--'+strSearchTxt);
       
        
        //get additional number rec based on their Additional_RT_Number__c
        List<Additional_RT_Number__c> rtnumberList = [SELECT Id,
                                                                Account__c 
                                                            FROM Additional_RT_Number__c
                                                            WHERE Additional_RT_Number__c = :strSearchTxt
                                                            AND Additional_RT_Number__c != null
                                                            LIMIT 100];
        
        // store account ids
        Set<Id> accIdSet = new set<Id>();
        
        // checking if the data is present
        if(rtnumberList != null 
            && !rtnumberList.isEmpty()){
            
            // getting account ids
            for(Additional_RT_Number__c aRN : rtnumberList){
                accIdSet.add(aRN.Account__c);
            }
        }
        
        // get accounts by their ids
        if(accIdSet != null && !accIdSet.isEmpty()){
            lstSearchedAccounts = [SELECT Id,
                                            Name,
                                               BillingCountry,
                                               BillingPostalCode,
                                               BillingState,
                                               BillingCity,
                                               BillingStreet,
                                               Primary_R_T_Number__c
                                        FROM Account
                                        WHERE Id IN: accIdSet
                                        LIMIT 100];
        }
    }    

   
    
    // when user click on next button
    public pageReference nextStep(){
        
        system.debug(Logginglevel.INFO,'\n--usrRec--'+usrRec+'\n--selectedAcc--'+selectedAcc);
        
        // making instance of account for update
        //Contact con = new Contact(Id = usrRec.contactId);
        
        if(selectedAcc != null && !string.isBlank(selectedAcc)){            
            updateContactAccount(selectedAcc, usrRec.contactId);
            
        }
        
        // get redirect
        String sId = Apexpages.currentPage().getparameters().get('id');
        
        joinapi__Step__c cstep = [Select Id,joinapi__Next_Step__c,joinapi__Navigation_URL__c  FROM joinapi__Step__c WHERE Id =: sId];
    	
        String redirectURL = cstep.joinapi__Navigation_URL__c;
        Framework.Message.addMessage('redirecting to '+redirectURL);
        
        PageReference newUrl = new PageReference(redirectURL);
        newUrl.setRedirect(true);
        
        return newUrl;

  
    }

    @future
    public static void updateContactAccount(string accId, string conId){
        
        system.debug(Logginglevel.INFO,'\n--conId--'+conId+'\n--accId--'+accId);
        Contact con = new Contact(Id = conId);
        con.AccountId = accId;
        update con;
        
        
    }
    
   
    // thie method is used to fetch the account of the logged in user
    private User fetchCurrentUserContact(){
        
        User usrDetails = [SELECT ID,
                                    ContactId,
                                    Contact.AccountId,
                                    Contact.Account.Name
                                FROM User
                                WHERE Id =: userInfo.getUserId()];
                                
        // retrun the usr record details
        return usrDetails; 
    }
    
    // when user click on back button
    public pageReference backButton(){
        String stepId = Framework.PageUtils.getParam('id');
        joinApi.JoinUtils joinUtil = new joinApi.JoinUtils(stepId); 
        return new PageReference(joinUtil.getPreviousStep('{}'));
    }
    
    
    

}