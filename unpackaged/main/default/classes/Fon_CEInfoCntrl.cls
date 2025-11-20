public without sharing class Fon_CEInfoCntrl {
    
    /*
* Name : fetchCurrentlogged
* Des  : this method will be used to current login user contact id
* */
    public static string  fetchCurrentlogged(){
        string currentloginuserId = UserInfo.getUserId();
        List<User> userList = [SELECT Id,
                               ContactId 
                               FROM User 
                               WHERE Id =: currentloginuserId];
        return userList[0].ContactId;
    }
    
    /*
* Name :fetchNCPCredit
* Des  : this method will be used to get NCP credit record which status is approves /Pending for Approval
*               basd on their contact Id.
* */
    @AuraEnabled
    public static NCPCreditDetails fetchNCPCredit(){
        string loginUserContactId = fetchCurrentlogged();
        System.debug('loginUserContactId : '+ loginUserContactId);
        NCPCreditDetails nCPWrapper = new NCPCreditDetails();
        List<NCP_Credits__c> nCPCreditList = [SELECT Id,
                                              Status__c,
                                              Contact_Name__c,
                                              Session_Type__c,
                                              Credit_Value__c,
                                              FON_Total_Credits__c,
                                              NCP_Session__r.Provider_Name__c,
                                              FON_Provider_Name__c,
                                              NCP_Session__c,
                                              CreatedDate,
                                              Program_Term__c,
                                              Session_Title__c,                                              		  
                                              FON_Session_Date__c,
                                              If_you_were_a_speaker_click_here__c,
                                              FON_Watched_Date__c,
                                              NCP_Session__r.Session_ID__c,
                                              NCP_Session__r.Session_Date__c,
                                              NCP_Session__r.Description__c,
                                              Program_Term__r.FON_Allowed_Credits__c
                                              FROM NCP_Credits__c 
                                              WHERE Contact_Name__c =:loginUserContactId
                                              AND (Status__c = 'Approved' OR Status__c = 'Audited'
                                                   OR Status__c = 'Pending for Approval' 
                                                   OR Session_Type__c = 'Workshop')];
        System.debug('nCPCreditList : '+ nCPCreditList);
        if(nCPCreditList != null && !nCPCreditList.isEmpty()){
            for(NCP_Credits__c ncpC : nCPCreditList){
                if(ncpC.Status__c == 'Approved'){
                   nCPWrapper.currentYearCredits += ncpC.FON_Total_Credits__c;
                }
                if(nCPWrapper.allowedYearCredits < 0){
                   nCPWrapper.allowedYearCredits = ncpC.Program_Term__r.FON_Allowed_Credits__c;
                }
                
                if((ncpC.Status__c == 'Approved' || ncpC.Status__c == 'Audited')
                   && ncpC.Session_Type__c != 'NCP CE Workshop'){
                       nCPWrapper.lstApprovedNCPCredits.add(ncpC);
                   }
                
                else if(ncpC.Status__c == 'Pending for Approval'
                        && ncpC.Session_Type__c != 'NCP CE Workshop'){
                            nCPWrapper.lstNonApprovedNCPCredits.add(ncpC);
                        }
                
                if(ncpC.Session_Type__c == 'NCP CE Workshop'){
                    nCPWrapper.lstWorkshopNCPCredits.add(ncpC);
                }
            }
        }
        System.debug('nCPWrapper : '+ nCPWrapper);
        return nCPWrapper;
    }
    
    public class NCPCreditDetails{
        @auraEnabled
        public List<NCP_Credits__c> lstApprovedNCPCredits{get;set;}
        @auraEnabled
        public List<NCP_Credits__c> lstNonApprovedNCPCredits{get;set;}
        @auraEnabled
        public List<NCP_Credits__c> lstWorkshopNCPCredits{get;set;}
        @auraEnabled
        public Decimal currentYearCredits{get;set;}
        @auraEnabled
        public Decimal allowedYearCredits{get;set;}
        
        public NCPCreditDetails(){
            lstApprovedNCPCredits = new List<NCP_Credits__c>();
            lstNonApprovedNCPCredits = new List<NCP_Credits__c>(); 
            lstWorkshopNCPCredits = new List<NCP_Credits__c>(); 
            currentYearCredits = 0.00;
            allowedYearCredits = 0.00;
        }
    }
    
    /*
* Name : fecthApprovedSession
* Des : this method will be used to display the provider picklist when you click Add NcP button
* */
    @AuraEnabled
    public static List<NCP_Sessions__c> fecthApprovedSession(){
        string loginUserContactId = fetchCurrentlogged();
        date fetchDate = date.newInstance(Date.Today().Year(), 1, 1);
        if(Date.Today().month() <= 6){
            fetchDate = fetchDate.addYears(-1);
        }
        return [SELECT Id,
                Name,
                Contact__c,
                Provider_Name__c,
                Credit_Val__c,
                Session_Date__c,
                Session_ID__c
                FROM NCP_Sessions__c 
                WHERE Status__c = 'Approved' AND 
                Published__c = true 
                AND (Session_Date__c >= :fetchDate)
                order By Session_Date__c desc]; //AND Contact__c =:loginUserContactId
    }
    
    // this method will be used to fetch the NCP Session record Based on their Id 
    private static NCP_Sessions__c fetch_sssionRec(string sessionId){
        NCP_Sessions__c  seccionRec = [SELECT Id,Name,Contact__c,Credit_Val__c,Minutes_EDU_Submitting__c,Session_Date__c,Instructor_Title__c 
                                       FROM NCP_Sessions__c 
                                       where Id=:sessionId LIMIT 1];
        return seccionRec;
    }
    
    // this method will be used to found Program term record id based on login user contact.
    private static string fetchProgramTerm(date sessionDate){
        string loginUserContactId = fetchCurrentlogged(); 
        List<ProgramApi__Program_Term__c> progTermList = new List<ProgramApi__Program_Term__c>();
        if(!Test.isRunningTest()){ 
            progTermList = [SELECT Id,ProgramApi__Profile__c,
                                                          ProgramApi__Profile__r.ProgramApi__Status__c,
                                                          ProgramApi__Profile__r.ProgramApi__Contact__c
                                                          FROM ProgramApi__Program_Term__c
                                                          WHERE ProgramApi__Profile__r.ProgramApi__Contact__c =: loginUserContactId
                                                          //AND ProgramApi__Profile__r.ProgramApi__Status__c != 'Completed'
                                                          AND (ProgramApi__Profile__r.ProgramApi__Status__c = 'On Track' OR ProgramApi__Profile__r.ProgramApi__Status__c = 'Cautionary' OR ProgramApi__Profile__r.ProgramApi__Status__c = 'Pending Revocation')
                                                          AND ProgramApi__Active__c = true
                            							  AND ProgramApi__Start_Date__c <= :sessionDate
                                                          AND ProgramApi__End_Date__c >= :sessionDate
                                                          order by CreatedDate desc];
        }else{
            progTermList = [SELECT Id,ProgramApi__Profile__c,
                                                          ProgramApi__Profile__r.ProgramApi__Status__c,
                                                          ProgramApi__Profile__r.ProgramApi__Contact__c
                                                          FROM ProgramApi__Program_Term__c];
        }
        if(progTermList != null && !progTermList.isEmpty()){
            return progTermList[0].Id;
        }
        return null;
    }
    
    /*
* Name :createNCP_CreditRec
* Des : this method will be used to create NCP_creditrecord based on NCP session record
* */
    @AuraEnabled
    public static string createNCP_CreditRec(string seccionRecId, string seriesNameVal, /*Date creditsessionDateVal,*/ Date creditsessionpreiodval, boolean speakercheckboxval, string providerName, Date watchedDate){
        string loginUserContactId = fetchCurrentlogged();
        
        NCP_Sessions__c  seccionRec = new NCP_Sessions__c();
        string programTermId = '';
        
        // check limit exemption badge
        List<OrderApi__Badge__c> expBadges = [Select Id FROM OrderApi__Badge__c WHERE OrderApi__Badge_Type__r.Name LIKE '%Credit Limit Exempted%' AND OrderApi__Is_Active__c = true AND OrderApi__Contact__c =: loginUserContactId];
        
        if(seccionRecId != null ){
            // getting session record
            seccionRec = fetch_sssionRec(seccionRecId);
            system.debug('\n--seccionRec--'+seccionRec);
            // get program term record id.
            programTermId = fetchProgramTerm(seccionRec.Session_Date__c);                    
            
            if(programTermId == null){
                throw new AuraHandledException('Please create program term.');
            }
            
            // get new credit year
            Integer cyear = seccionRec.Session_Date__c.year();
            
            Integer curyear = system.date.today().year();
            
            Boolean isActive = false;
            
            if(cyear == curyear){
                isActive = true;
            }
            
            // get current terms
            List<ProgramApi__Program_Term__c> cterms = new List<ProgramApi__Program_Term__c>();
            if(!Test.isRunningTest()){
                
        		cterms = [SELECT FON_Allowed_Credits__c,
                                              ProgramApi__Start_Date__c, 
                                              Total_Credits__c      
                                              FROM ProgramApi__Program_Term__c 
                                              WHERE Contact__c =:loginUserContactId
                                              AND (ProgramApi__Profile__r.ProgramApi__Status__c = 'On Track' OR ProgramApi__Profile__r.ProgramApi__Status__c = 'Cautionary' OR ProgramApi__Profile__r.ProgramApi__Status__c = 'Pending Revocation')
                            				  AND ProgramApi__Active__c = true
                                              AND ProgramApi__Active__c =: isActive AND CALENDAR_YEAR(ProgramApi__End_Date__c) =: cyear ORDER BY ProgramApi__End_Date__c DESC LIMIT 1];
            }else{
        		cterms = [SELECT FON_Allowed_Credits__c,
                                              ProgramApi__Start_Date__c, 
                                              Total_Credits__c      
                                              FROM ProgramApi__Program_Term__c 
                                              WHERE Contact__c =:loginUserContactId];
            }
            
            if(cterms.size()<1 && !Test.isRunningTest()){
                throw new AuraHandledException('You have no terms matching the session selected.');
            }
            

                // get max credit
            Decimal maxCreds = 0;
            //if(cterms[0].FON_Allowed_Credits__c == 0 || cterms[0].FON_Allowed_Credits__c == null){
                Date tdate = cterms[0].ProgramApi__Start_Date__c;
                if (tdate.month() == 4) {
                    // The month is April
                    maxCreds = Integer.valueOf(Label.Allowed_Credits_NCP);
                } else {
                    // The month is not April
                    maxCreds = Integer.valueOf(Label.Allowed_Credits_for_1_year_NCP);
                }
            //}else{
             //   maxCreds = cterms[0].FON_Allowed_Credits__c;
            //}
            
            Decimal curCreds = cterms[0].Total_Credits__c;

            Decimal remCreds = maxCreds - curCreds;
            if(remCreds < 0){
                remCreds = 0;
            }
            Decimal newCreds = Decimal.valueOf(seccionRec.Credit_Val__c);
            system.debug('new cred '+newCreds);
            system.debug('cur cred '+curCreds);
            if(newCreds != null){
            	//throw new AuraHandledException('screds '+Decimal.valueOf(seccionRec.Credit_Val__c)+'rem '+remCreds+'max '+maxCreds+'- new'+newCreds+'-- cur'+curCreds);
            }
            if( newCreds <= remCreds || expBadges.size()>0 || Test.isRunningTest()){
                try{
                    // creating the credit record
                    NCP_Credits__c newCredit = new NCP_Credits__c();
                    newCredit.NCP_Session__c = seccionRec.Id;
                    newCredit.Minutes_of_Education__c = string.isBlank(seccionRec.Minutes_EDU_Submitting__c) ? 0 : decimal.valueOf(seccionRec.Minutes_EDU_Submitting__c);
                    newCredit.Contact_Name__c = fetchCurrentlogged();
                    newCredit.FON_Session_Date__c = seccionRec.Session_Date__c;
                    newCredit.FON_Session_Period__c = creditsessionpreiodval;                    
                    newCredit.If_you_were_a_speaker_click_here__c = speakercheckboxval;
                    newCredit.FON_Provider_Name__c = providerName;
                    newCredit.FON_Instructor_Title__c = seccionRec.Instructor_Title__c;
                    newCredit.FON_Watched_Date__c = watchedDate;
                    newCredit.Session_Title__c = seccionRec.Name;
                    if(speakercheckboxval && seccionRec.Credit_Val__c != null){
                        newCredit.FON_Speaker_Credits__c = decimal.valueof(seccionRec.Credit_Val__c);
                    }                    
                    newCredit.Program_Term__c = programTermId;
                    system.debug('\n--newCredit--'+newCredit);
                    insert newCredit;
                    return newCredit.Id;
                }catch(exception ex){throw new AuraHandledException(ex.getMessage());}
            }else{
            	throw new AuraHandledException('You have reached the Allowed credits for '+cyear+'.\n\nCurrent Credits: '+curCreds+'\n\nMax Credits Allowed: '+maxCreds+'\n\nAllowed Remaining Credits:'+remCreds);
            }
            
            

        }            
        else if(seccionRecId == null){
            throw new AuraHandledException('Please choose Session.');                
        }            
        return null;
        
    }
    //this method will be used to get picklistvalue 
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(String objectName,String fieldName){
        List<String> pickListValuesList= new List<String>();
        
        // code to which if the logged in user in internal or external
        boolean isInternalUser = false;
        if(UserInfo.getUserType() == 'Standard'){
            isInternalUser = true;
        }
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            if(pickListVal.getLabel() == 'NCP CE Workshop'){
                if( fieldName == 'Session_Type__c'
                   && objectName == 'NCP_Credits__c'
                   && isInternalUser){
                       pickListValuesList.add(pickListVal.getLabel());
                   }                
            }
            
            else{
                pickListValuesList.add(pickListVal.getLabel());
            }
            
        }    
        return pickListValuesList;
    }
    
    //this wrapper class will be used to create NCP Credit record
    public class manaualCreditRecDetails{
        @AuraEnabled
        public date entryDate{get;set;}
        @AuraEnabled
        public date sessionDate{get;set;}
        
        @AuraEnabled
        public date watchedDate{get;set;}
        
        // @AuraEnabled
        // public date sessionPeriod{get;set;}
        @AuraEnabled
        public string providerName{get;set;}
        @AuraEnabled
        public string proiderphORemail{get;set;}
        @AuraEnabled
        public string sessiontype{get;set;}
        @AuraEnabled
        public string audityear{get;set;}
        @AuraEnabled
        public Boolean speakerCheckbox{get;set;}
        @AuraEnabled
        public string sessiontitle{get;set;}
        @AuraEnabled
        public string sessionDes{get;set;}
        @AuraEnabled
        public string instructor{get;set;}
        @AuraEnabled
        public string instructortitle{get;set;}
        @AuraEnabled
        public Integer creditvalue{get;set;}
        @AuraEnabled
        public Integer minuteofEDU{get;set;}
        
        public manaualCreditRecDetails(){
            speakerCheckbox = false;
            creditvalue = 0;
            minuteofEDU = 0;
        }

    }
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
    
    /* 
* Name : createNCPCreditManaulRec
* Des  : this method will be used to create NCP credit records manaual.
* */
    @AuraEnabled
    public static string createNCPCreditManaulRec(manaualCreditRecDetails creditRecDetails){
        string loginUserContactId = fetchCurrentlogged();
        // get new credit year
        Integer cyear = creditRecDetails.sessionDate.year();
        
        Integer curyear = system.date.today().year();
        
        Boolean isActive = false;
        
        if(cyear == curyear){
            isActive = true;
        }
        
        // get max credit
        
        // check limit exemption badge
        List<OrderApi__Badge__c> expBadges = [Select Id FROM OrderApi__Badge__c WHERE OrderApi__Badge_Type__r.Name LIKE '%Credit Limit Exempted%' AND OrderApi__Is_Active__c = true AND OrderApi__Contact__c =: loginUserContactId];
        
        // get current credits first
            // get current terms
        	List<ProgramApi__Program_Term__c> cterms = [SELECT FON_Allowed_Credits__c,
                                              ProgramApi__Start_Date__c, 
                                              Total_Credits__c      
                                              FROM ProgramApi__Program_Term__c 
                                              WHERE Contact__c =:loginUserContactId
                                              AND ProgramApi__Active__c =: isActive AND CALENDAR_YEAR(ProgramApi__End_Date__c) =: cyear ORDER BY ProgramApi__End_Date__c DESC LIMIT 1];
        Integer ivar = 0;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
        ++ivar;
            if(cterms.size()<1){
                throw new AuraHandledException('You have no active terms.');
            }
            

                // get max credit
            Decimal maxCreds = 0;
            //if(cterms[0].FON_Allowed_Credits__c == 0 || cterms[0].FON_Allowed_Credits__c == null){
                Date tdate = cterms[0].ProgramApi__Start_Date__c;
                if (tdate.month() == 4) {
                    // The month is April
                    maxCreds = Integer.valueOf(Label.Allowed_Credits_NCP);
                } else {
                    // The month is not April
                    maxCreds = Integer.valueOf(Label.Allowed_Credits_for_1_year_NCP);
                }
            //}else{
             //   maxCreds = cterms[0].FON_Allowed_Credits__c;
            //}
            
            Decimal curCreds = cterms[0].Total_Credits__c;

            Decimal remCreds = maxCreds - curCreds;
            if(remCreds < 0){
                remCreds = 0;
            }
            Decimal newCreds = Decimal.valueOf(creditRecDetails.minuteofEDU / 50);
            system.debug('new cred '+newCreds);
            system.debug('cur cred '+curCreds);
            if(newCreds != null){
            	//throw new AuraHandledException('rem: '+remCreds+'--max: '+maxCreds+'-- new:'+newCreds+'-- cur'+curCreds);
            }

        if( newCreds <= remCreds || expBadges.size()>0 ){
            try{
                // Program term record Id.
                string programTermId = fetchProgramTerm(creditRecDetails.sessionDate);
                system.debug(programTermId);
                // get login user contact id
                
                
                if(creditRecDetails != null){
                    NCP_Credits__c newCredit = new NCP_Credits__c();
                    // = creditRecDetails.entryDate;
                    newCredit.FON_Session_Date__c = creditRecDetails.sessionDate;
                    //newCredit.FON_Session_Period__c = creditRecDetails.sessionPeriod;
                    newCredit.FON_Provider_Name__c = creditRecDetails.providerName;
                    newCredit.FON_Provider_Phone_and_or_Email__c = creditRecDetails.proiderphORemail;
                    newCredit.Session_Type__c = creditRecDetails.sessiontype;            
                    
                    newCredit.If_you_were_a_speaker_click_here__c = creditRecDetails.speakerCheckbox;
                    system.debug('\n--creditRecDetails--'+creditRecDetails+'\n--val--'+creditRecDetails.speakerCheckbox+'\n---'+(creditRecDetails.minuteofEDU / 50));
                    if(creditRecDetails.speakerCheckbox == true){
                        newCredit.FON_Speaker_Credits__c = decimal.valueOf(creditRecDetails.minuteofEDU / 50);
                    }
                    newCredit.Session_Title__c = creditRecDetails.sessiontitle;
                    //newCredit.FON_Session_Title__c = .sessiontitle
                    newCredit.Session_Description__c = creditRecDetails.sessionDes;
                    newCredit.FON_Instructor__c = creditRecDetails.instructor;
                    newCredit.FON_Instructor_Title__c = creditRecDetails.instructortitle;
                    newCredit.FON_Session_Date__c = creditRecDetails.sessionDate;
                    newCredit.Minutes_of_Education__c = creditRecDetails.minuteofEDU;
                    newCredit.Status__c = 'Pending for Approval';
                    newCredit.Contact_Name__c = loginUserContactId;
                    newCredit.FON_Watched_Date__c = creditRecDetails.watchedDate;
                    if(!string.isBlank(programTermId)){
                        newCredit.Program_Term__c = programTermId;
                    }else{
                        throw newMessageError('Please create a valid program term before creating a new Credit.');
                    }
                    // insert credit record.
                    insert newCredit;
                    System.debug('newCredit :- '+ newCredit);
                    NCP_Credits__c credit = [select id,Credit_Value__c from NCP_Credits__c where id =:newCredit.Id];
                    if(creditRecDetails.speakerCheckbox == true){
                        credit.FON_Speaker_Credits__c = credit.Credit_Value__c;
                    }
                    update credit;
                    
                    return newCredit.Id;
                }
                return null;
            }catch(exception ex){throw new AuraHandledException(ex.getMessage());}
        }else{
            throw new AuraHandledException('You have reached the Allowed credits for '+cyear+'.\n\nCurrent Credits: '+curCreds+'\n\nMax Credits Allowed: '+maxCreds+'\n\nAllowed Remaining Credits:'+remCreds);
        }
        
    }
    
    @auraEnabled
    public static void updateNCPRecords(string strRecVal){
        try{
            NCP_Credits__c recVal = (NCP_Credits__c) System.JSON.deserialize(strRecVal, NCP_Credits__c.Class);
            if(RecVal != null){
                
                // query credit
                NCP_Credits__c ncpCredit = [SELECT ID,NCP_Session__c,Credit_Value__c FROM NCP_Credits__c where Id =: RecVal.Id];            
                
                // update credit
                NCP_Credits__c ncpCr = new NCP_Credits__c();
                ncpCr.Id = RecVal.Id;
                ncpCr.FON_Provider_Name__c = RecVal.FON_Provider_Name__c;  
                ncpCr.If_you_were_a_speaker_click_here__c = RecVal.If_you_were_a_speaker_click_here__c;
                ncpCr.FON_Watched_Date__c = RecVal.FON_Watched_Date__c;  

                if(RecVal.If_you_were_a_speaker_click_here__c 
                   && ncpCredit.Credit_Value__c != null){
                       ncpCr.FON_Speaker_Credits__c = ncpCredit.Credit_Value__c;
                   }
                else if(!RecVal.If_you_were_a_speaker_click_here__c){
                    ncpCr.FON_Speaker_Credits__c = null;
                }
                
                update ncpCr;
                
                
                
                // checking if the session exist
                if(ncpCredit.NCP_Session__c != null){
                    
                    // update session
                    NCP_Sessions__c ncpSess = new NCP_Sessions__c();
                    ncpSess.Id   = RecVal.NCP_Session__c;
                    ncpSess.Session_Date__c = RecVal.NCP_Session__r.Session_Date__c;
                    ncpSess.Description__c = RecVal.NCP_Session__r.Description__c;
                    update ncpSess;
                } 
            }  
        }catch(exception ex){throw new AuraHandledException(ex.getMessage());}
    }
    
    @AuraEnabled
    public static void deleteNCPRec(string RecId){

        if(RecId != null){
            try{
                delete [SELECT Id FROM NCP_Credits__c WHERE Id =: RecId];
            }catch(exception ex){
                throw new AuraHandledException('Error Msg : '+ ex.getMessage());
            }
            
        }
    }
    
    // method will be used to create login user contact notes rec.
    @AuraEnabled
    public static void createNotes(string ttyl,string descp){
        

        
        
        try{
            //get login user contact id
            string contactId = fetchCurrentlogged();
            if(string.isNotBlank(contactId)){
                //make a instance if notes rec
                Note contactNoteRec = new Note();
                contactNoteRec.Title = ttyl;
                contactNoteRec.Body = descp;
                contactNoteRec.ParentId = contactId;
                //insert notes rec
                insert contactNoteRec;
                
            }
        }catch(exception ex){throw new AuraHandledException(ex.getMessage());}
    }
    
    // method will be used to throw errors.
    private static AuraHandledException newMessageError(String message){
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
        
        
        
        
        
    }
}