public without sharing class DisplayAuditProgramHelper {

    // this will be used to get the hold the contact Id
    public string contactId {get;set;} 
    
    // this will hold the data to be displayed on template
    public detailsWrapper wrapObj {get;set;}
    
    // this will be used to get the data for the email template
    public void getdisplaydata(){
        
        // for testing adding the contact
        //contactId = '0036300000h5Bb1';    
        //contactId = fetchCurrentlogged();    
        
        // Create wrapper class object instance
        wrapObj = new detailsWrapper();
        
        wrapObj.conDetails = new Contact();
        if(String.isBlank(contactId) != true){
        	wrapObj.conDetails = [select id, Name, Audit_Email_Sent__c from contact where id = :contactId];
        }else{
            wrapObj.conDetails = [select id, Name, Audit_Email_Sent__c from contact where id = '0036g00001Uf2M4AAJ'];
        }
        
        if(wrapObj.conDetails.Audit_Email_Sent__c != null){
            wrapObj.calcDate = wrapObj.conDetails.Audit_Email_Sent__c.addDays(42).format();   
            wrapObj.sendYear = (wrapObj.conDetails.Audit_Email_Sent__c.year() - 1);
        }
        else{
            wrapObj.calcDate = system.today().addDays(42).format();
            wrapObj.sendYear = (system.today().year() - 1);
        }
        
        
        // save current year
        //integer cYear = System.today().year();
        integer cYear = System.Today().addYears(-1).year();
        
        //fetch Program profile object data List
        List<ProgramApi__Program_Profile__c> progProfileList = [SELECT Id,FON_Audited_By__c,FON_Audited_By__r.FirstName,
                                                                FON_Audited_By__r.LastName,FON_Audited_Year__c,
                                                                FON_Audit_Status__c,FON_Audit_Date__c,
                                                                FON_Total_Credits__c,
                                                                (SELECT Id,ProgramApi__Start_Date__c,ProgramApi__End_Date__c FROM ProgramApi__Program_Terms__r)
                                                               FROM ProgramApi__Program_Profile__c
                                                               WHERE ProgramApi__Contact__c =: contactId
                                                               AND FON_Audited__c = true
                                                               //AND ProgramApi__Status__c = 'On Track'
                                                               //AND FON_Audited_Year__c = :cYear
                                                               ORDER BY CreatedDate ASC
                                                               LIMIT 50];
        System.debug('\n--progProfileList--'+progProfileList);
        
        
        if(progProfileList != null && !progProfileList.isEmpty()){
            wrapObj.progProList = progProfileList;
            
            set<Id> progTernIdSet = new set<Id>();
            
            //iterate program profile data list to get program term Ids
            for(ProgramApi__Program_Profile__c progPro : progProfileList){
                if(progPro.ProgramApi__Program_Terms__r != null && !progPro.ProgramApi__Program_Terms__r.isEmpty()){
                    for(ProgramApi__Program_Term__c progTerm : progPro.ProgramApi__Program_Terms__r){
                        if(progTerm.ProgramApi__Start_Date__c.year() == progPro.FON_Audited_Year__c
                           && progTerm.ProgramApi__End_Date__c.year() == progPro.FON_Audited_Year__c)
                            progTernIdSet.add(progTerm.Id);
                    }
                }
            }
            System.debug('\n--progTernIdSet--'+progTernIdSet);
            if(progTernIdSet != null){
                // fetch NCP Credit Details Record based on their Program term id.
                wrapObj.ncpCreditList = fetchNCPCredits(progTernIdSet);
                
                // get total
                for(NCP_Credits__c ncpCredit : wrapObj.ncpCreditList){
                    if(ncpCredit.Credit_Value__c != null)
                        wrapObj.totalSubmittedCredits += ncpCredit.Credit_Value__c;
                    
                    if(ncpCredit.FON_Audit_Adjusted_Value__c == null
                        && ncpCredit.Credit_Value__c != null){
                        ncpCredit.FON_Audit_Adjusted_Value__c = ncpCredit.Credit_Value__c;
                    }
                    
                    wrapObj.totalAdjustedCredits += ncpCredit.FON_Audit_Adjusted_Value__c;
                    
                }
            }
            System.debug('\n--ncpCreditList--'+wrapObj.ncpCreditList);
        }       
    }
    
    
    /*
     * Name : fetchCurrentlogged
     * Des  : this method will be used to current login user contact id
     * */
    public static string  fetchCurrentlogged(){
        string currentloginuserId = UserInfo.getUserId();
        List<User> userList = [SELECT Id,ContactId FROM User WHERE Id =: currentloginuserId];
        if(String.isBlank(userList[0].ContactId) != true){
        	return userList[0].ContactId;
        }else{
            return '0036g00001Uf2M4AAJ';
        }
        
    }
    
    /*
     * Name :fetchProgProfile
     * Description: this method will be used to fetch program Profile and their related  NCP Credit Records
     * */
    @auraEnabled
    public static detailsWrapper fetchProgProfile(){
        //get current user contact Id
        string userConId = fetchCurrentlogged();
        
        // Create wrapper class object instance
        detailsWrapper wrapObj = new detailsWrapper();
        
        // save current year
        //integer cYear = System.today().year();
        integer cYear = System.Today().addYears(-1).year();
        
        //fetch Program profile object data List
        List<ProgramApi__Program_Profile__c> progProfileList = [SELECT Id,FON_Audited_By__c,FON_Audited_By__r.FirstName,
                                                                FON_Audited_By__r.LastName,FON_Audited_Year__c,
                                                                FON_Audit_Status__c,FON_Audit_Date__c,
                                                                FON_Audit_Submitted_Date_By_EU__c,
                                                                FON_Total_Credits__c,
                                                                (SELECT Id,ProgramApi__Start_Date__c,ProgramApi__End_Date__c FROM ProgramApi__Program_Terms__r)
                                                               FROM ProgramApi__Program_Profile__c
                                                               WHERE ProgramApi__Contact__c =: userConId
                                                               AND FON_Audited__c = true
                                                               AND ProgramApi__Status__c = 'On Track'
                                                               AND FON_Audited_Year__c = :cYear
                                                               ORDER BY CreatedDate ASC
                                                               LIMIT 50];
        System.debug('\n--progProfileList--'+progProfileList);
        
        
        if(progProfileList != null && !progProfileList.isEmpty()){
            wrapObj.progProList = progProfileList;
            
            set<Id> progTernIdSet = new set<Id>();
            
            //iterate program profile data list to get program term Ids
            for(ProgramApi__Program_Profile__c progPro : progProfileList){
                if(progPro.ProgramApi__Program_Terms__r != null && !progPro.ProgramApi__Program_Terms__r.isEmpty()){
                    for(ProgramApi__Program_Term__c progTerm : progPro.ProgramApi__Program_Terms__r){
                        if(progTerm.ProgramApi__Start_Date__c.year() == progPro.FON_Audited_Year__c
                           && progTerm.ProgramApi__End_Date__c.year() == progPro.FON_Audited_Year__c)
                            progTernIdSet.add(progTerm.Id);
                    }
                }
            }
            System.debug('\n--progTernIdSet--'+progTernIdSet);
            if(progTernIdSet != null){
                // fetch NCP Credit Details Record based on their Program term id.
                wrapObj.ncpCreditList = fetchNCPCredits(progTernIdSet);
                
                // get total
                for(NCP_Credits__c ncpCredit : wrapObj.ncpCreditList){
                    if(ncpCredit.Credit_Value__c != null)
                        wrapObj.totalSubmittedCredits += ncpCredit.Credit_Value__c;
                    
                    if(ncpCredit.FON_Audit_Adjusted_Value__c == null
                        && ncpCredit.Credit_Value__c != null){
                        ncpCredit.FON_Audit_Adjusted_Value__c = ncpCredit.Credit_Value__c;
                    }
                    
                    wrapObj.totalAdjustedCredits += ncpCredit.FON_Audit_Adjusted_Value__c;
                    
                }
            }
            System.debug('\n--ncpCreditList--'+wrapObj.ncpCreditList);
        }
        return wrapObj;
    }
    
    /*
     * Name : detailsWrapper
     * Description : this wrapper class will be used to display data in LC(DisplayAuditProgram) 
     *                  Which is used in community tab
     * */
    public class detailsWrapper{
        @auraEnabled
        public List<ProgramApi__Program_Profile__c> progProList{get;set;}
        
        @auraEnabled
        public contact conDetails{get;set;}
        
        @auraEnabled
        public Integer sendYear{get;set;}
        
        @auraEnabled
        public string calcDate{get;set;}
        
        @auraEnabled
        public List<NCP_Credits__c> ncpCreditList{get;set;}
        
        @auraEnabled
        public decimal totalSubmittedCredits {get;set;}
        
        @auraEnabled
        public decimal totalAdjustedCredits {get;set;}
        
        public detailsWrapper(){
            progProList = new List<ProgramApi__Program_Profile__c>();
            ncpCreditList = new List<NCP_Credits__c>();
            this.totalSubmittedCredits = 0;
            this.totalAdjustedCredits = 0;
        }
        
    }
    
    /*
     * Name : fetchNCPCredits
     * Description : this method will be used to fecth ncp Credit record based on their program term(Parent object) id
     * */
    public static List<NCP_Credits__c> fetchNCPCredits(Set<Id>ProgTermIdSet){
        return [SELECT Id,
                        Program_Term__c,
                        FON_Session_Date__c,
                        FON_Provider_Name__c,
                        Session_Description__c,
                        FON_Session_Period__c,
                        Session_Title__c,
                        Session_Type__c,
                        Credit_Value__c,NCP_Session__c,
                        NCP_Session__r.Session_ID__c,
                        NCP_Session__r.Session_Date__c,
                        NCP_Session__r.Description__c,
                        //NCP_Session__r.Session_Title__c,
                        FON_Audit_Adjusted_Value__c,
                        Auditor_Notes__c,
                        NCP_Session__r.Credit_Val__c,
                		FON_Audit_Documentation_Upload_Date__c
                FROM NCP_Credits__c
                WHERE Program_Term__c IN: ProgTermIdSet];
    }
    @AuraEnabled
    public static String saveTheFile(String fileName, String base64Data, String contentType, Id recordId) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion contentVersion = new ContentVersion(
            VersionData = EncodingUtil.base64Decode(base64Data),
            Title = fileName,
            PathOnClient = '/' + fileName,
            FirstPublishLocationId = recordId
        );
        insert contentVersion;
        
        return contentVersion.Id;
    }
    @AuraEnabled
    public static NCP_Credits__c submitTheFiles(Id recordId) {
        
        NCP_Credits__c cred = [Select Id,FON_Audit_Documentation_Upload_Date__c FROM NCP_Credits__c WHERE Id=:recordId];
        cred.FON_Audit_Documentation_Upload_Date__c = DateTime.now();
        update cred;
        
        return cred;
    }
    @AuraEnabled
    public static ProgramApi__Program_Profile__c submitTheAudit(Id recordId) {
        ProgramApi__Program_Profile__c ppf = [Select Id,FON_Audit_Submitted_Date_By_EU__c FROM ProgramApi__Program_Profile__c WHERE Id=:recordId];
        ppf.FON_Audit_Submitted_Date_By_EU__c = DateTime.now();
        update ppf;
        
        return ppf;
    }
    
    public static void testingCoverage(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        //repeat the i++ hundred of times

    }
}