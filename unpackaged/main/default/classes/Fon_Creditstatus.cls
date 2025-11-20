Public without sharing Class Fon_Creditstatus{    
    
    /*
     * Name : fetchCurrentlogged
     * Des  : this method will be used to current login user contact id
     **/
    private static User fetchCurrentlogged(){        
        List<User> userList = [SELECT Id,
                                        FirstName, 
                                        LastName, 
                                        contactId 
                                    FROM User 
                                    WHERE Id =:UserInfo.getUserId()];
        return userList[0];
    }
    
    
    // this method will be used to found Program term record id based on login user contact.
    private static List<ProgramApi__Program_Profile__c> fetchProgramProfile(){
        string loginUserContactId = fetchCurrentlogged().contactId; 
        return [SELECT Id,
                        FON_Program_Start_Date__c,
                        FON_Program_End_Date__c,
                        ProgramApi__Status__c,                        
                        Allowed_Credits__c,
                        Allowed_Workshops__c,
                        (SELECT Id,FON_Credits_Acquired__c,
                                FON_Workshops_Attended2__c,
                                FON_Allowed_Credits__c,
                                FON_Allowed_Workshops__c,
                                ProgramApi__Start_Date__c,
                                ProgramApi__End_Date__c,
                                Workshops_Approved__c,
                                FON_Workshops_Attended__c,
                                Total_Credits__c
                            FROM ProgramApi__Program_Terms__r)
                    FROM ProgramApi__Program_Profile__c
                    WHERE ProgramApi__Contact__c =: loginUserContactId
                    order by FON_Program_End_Date__c desc];
        
    }
    
    
    private static map<id,List<NCP_Credits__c>> fetchCredits(set<id> setProgramTermIds){        
        // this will store the if of the program term and its related crdits
        map<id,List<NCP_Credits__c>> mapTermCredit = new map<id,List<NCP_Credits__c>>();
        
        // for each credits
        for(NCP_Credits__c credits : [SELECT Id,
                                              Status__c,
                                              FON_Total_Credits__c,
                                              Program_Term__r.FON_Workshops_Attended2__c,
                                              Session_Type__c,
                                              Program_Term__c,
                                              Credit_Value__c,
                                      		  FON_Audit_Adjusted_Value__c
                                          FROM NCP_Credits__c
                                          WHERE Program_Term__c IN :setProgramTermIds
                                          //AND (Status__c = 'Approved' 
                                          //  OR Status__c = 'Pending for Approval' 
                                          //  OR Session_Type__c = 'Workshop')
                                     ]){
            
            // saving the credits
            List<NCP_Credits__c> lstCredits = new List<NCP_Credits__c>{credits};
            
            // checking if the program term is already present and update the list
            if(mapTermCredit.containsKey(credits.Program_Term__c)){
                lstCredits.addAll(mapTermCredit.get(credits.Program_Term__c));
            }
            
            // update the map
            mapTermCredit.put(credits.Program_Term__c,lstCredits);
        }  
        return mapTermCredit;        
    }
    
    public static List<ProgramApi__Program_Profile__c> currentProfProfile(string loginUserContactId){
        return  [SELECT Id,
                        FON_Program_Start_Date__c,
                        FON_Program_End_Date__c,
                        ProgramApi__Status__c,
                        Allowed_Credits__c,
                        Allowed_Workshops__c
                 FROM ProgramApi__Program_Profile__c
                 WHERE ProgramApi__Contact__c =: loginUserContactId                     
                 AND ProgramApi__Status__c = 'On Track'
                 order by createdDate desc LIMIT 1];
    }
    
    @AuraEnabled
    public static OnLoadWrapper fetchonLoadWrapper(){
        
        Integer allCredits = Integer.valueOf(System.Label.Allowed_Credits_for_1_year_NCP);
        Integer allWorkshop = Integer.valueOf(System.Label.Allowed_Workshops_in_1_year_NCP);
        
        // making instance return wrapper
        OnLoadWrapper onloadObj = new OnLoadWrapper();
        
        // getting user record
        onloadObj.userDetails = fetchCurrentlogged();
        
        // this will save the ids of the program term ids to get the NCP credits
        set<id> setPrgTermIds = new set<id>();
        
        // getting program profile
        List<ProgramApi__Program_Profile__c> lstProgProfile = fetchProgramProfile();
        system.debug('\n--lstProgProfile--'+lstProgProfile);
        
        // getting the current prof profile for table 1
        List<ProgramApi__Program_Profile__c> currentProgProfile = currentProfProfile(onloadObj.userDetails.ContactId);
        system.debug('\n--currentProgProfile--'+currentProgProfile);
        
        if(currentProgProfile.isEmpty()
            && !lstProgProfile.isEmpty()){
            currentProgProfile.add(lstProgProfile[0]);
        }
        
        
        // if current progprom profile is present
        if(!currentProgProfile.isEmpty()){
            // details for the first table in the component
            if(currentProgProfile[0].FON_Program_Start_Date__c != null){
                onloadObj.startYear = currentProgProfile[0].FON_Program_Start_Date__c.year();
            }
            
            if(currentProgProfile[0].FON_Program_End_Date__c != null){
                onloadObj.endYear = currentProgProfile[0].FON_Program_End_Date__c.year();
            }
            
            
            if(currentProgProfile[0].Allowed_Workshops__c != null){
                onloadObj.WCreditsRequired = currentProgProfile[0].Allowed_Workshops__c;
            }
            
            if(currentProgProfile[0].Allowed_Credits__c != null){
                onloadObj.CreditsRequired = currentProgProfile[0].Allowed_Credits__c;
            }
        }
         
        
        // for each proggram profile
        for(ProgramApi__Program_Profile__c progProfile : lstProgProfile){
            
            // checking if the program term is present
            if(progProfile.ProgramApi__Program_Terms__r != null){
                
                // for reach program term save the ids
                for(ProgramApi__Program_Term__c progTerm : progProfile.ProgramApi__Program_Terms__r){
                    setPrgTermIds.add(progTerm.Id);
                }
            }
        }
        system.debug('\n--setPrgTermIds--'+setPrgTermIds);
        
        // code to get the credits for the program term
        //map<id,List<NCP_Credits__c>> mapTermCredit = fetchCredits(setPrgTermIds); 
        
        Fon_CEInfoCntrl.NCPCreditDetails creditRec = Fon_CEInfoCntrl.fetchNCPCredit();
        system.debug('\n--creditRec--'+creditRec);
        
        
        // setitng the terms Ids
        set<string> setTermIdsNew = new set<string>();
        
        // getting the credits based upon logged in user
        Fon_CEInfoCntrl.NCPCreditDetails creditRec1 = Fon_CEInfoCntrl.fetchNCPCredit();
        
        // for approved non workshop
        for(NCP_Credits__c credit : creditRec1.lstApprovedNCPCredits){            
            setTermIdsNew.add(credit.Program_Term__c);
        }
        
        // for pending non workshop
        for(NCP_Credits__c credit : creditRec1.lstNonApprovedNCPCredits){
            setTermIdsNew.add(credit.Program_Term__c);
        }
        
        
        // for workshop
        for(NCP_Credits__c credit : creditRec1.lstNonApprovedNCPCredits){
            setTermIdsNew.add(credit.Program_Term__c);            
        }
        system.debug('\n--setTermIdsNew--'+setTermIdsNew);
        map<id,List<NCP_Credits__c>> mapTermCredit = fetchCredits(setPrgTermIds); 
        
        // if prog profile is present
        if(!lstProgProfile.isEmpty()){
            
            // initaize the prog profile details
            onloadObj.lstProfileWrapper = new List<ProfWrapper>();
            
            // for each program profile
            for(ProgramApi__Program_Profile__c progProfile : lstProgProfile){
                
                // creatng the instance of prog profile wrapper
                ProfWrapper progProfileObj = new ProfWrapper();
                progProfileObj.progProfile = progProfile;
                progProfileObj.progTerms = new List<programTermWrapper>();
                
                // this will save the credits for the prog profile
                List<NCP_Credits__c> lstCredits = new List<NCP_Credits__c>();
                
                // getting related Program Term
                if(progProfile.ProgramApi__Program_Terms__r != null){
                    
                    // for reach program term 
                    for(ProgramApi__Program_Term__c progTerm : progProfile.ProgramApi__Program_Terms__r){
                        
                        // saving the list of credits
                        List<NCP_Credits__c> lstTemp = new List<NCP_Credits__c>();
                        
                        // checking if the have the credits
                        if(mapTermCredit.containsKey(progTerm.Id)){
                            //lstTemp = mapTermCredit.get(progTerm.Id);
                            List<NCP_Credits__c> cr = mapTermCredit.get(progTerm.Id);
                            if(cr.size()>0){
                                for(NCP_Credits__c credit : cr){
                                    if(credit.Status__c == 'Approved' &&  credit.Session_Type__c != 'NCP CE Workshop'){
                                    //if(credit.Session_Type__c != 'NCP CE Workshop'){
                                    	lstTemp.add(credit);
                                    }
                                }
                            }
                            lstCredits.addAll(lstTemp);
                        }
                        
                        
                        
                        // making wrapper list
                        progProfileObj.progTerms.add(new programTermWrapper(progTerm,lstTemp));
                        
                    }
                }
                system.debug('\n--lstCredits--'+lstCredits);                     
                
                
                // for each term get the attended workshop
                for(programTermWrapper progTerm : progProfileObj.progTerms){   
                    if(progTerm.progTerm.Workshops_Approved__c != null){
                        progProfileObj.approvedWorkCredits += progTerm.progTerm.Workshops_Approved__c;
                        if(allWorkshop > progTerm.progTerm.Workshops_Approved__c){
                        	progProfileObj.calculatedWorkCredits += progTerm.progTerm.Workshops_Approved__c;
                        }else{
                            progProfileObj.calculatedWorkCredits += allWorkshop;
                        }
                    }
                    
                    if(progTerm.progTerm.FON_Workshops_Attended2__c != null){
                        progProfileObj.AllWorkCredits += progTerm.progTerm.FON_Workshops_Attended2__c;
                    }
                }

                for(programTermWrapper progTerm : progProfileObj.progTerms){

                    if(progTerm.progTerm.FON_Credits_Acquired__c != null){
                        // this is the original approved Credits as of july 2024
                        progProfileObj.approvedCredits += progTerm.progTerm.FON_Credits_Acquired__c;
                        
                        if(allCredits > progTerm.progTerm.FON_Credits_Acquired__c){
                        	progProfileObj.calculatedCredits += progTerm.progTerm.FON_Credits_Acquired__c;
                        }else{
                            progProfileObj.calculatedCredits += allCredits;
                        }
                        
                    }

                    if(progTerm.progTerm.Total_Credits__c != null)
                        progProfileObj.AllCredits += progTerm.progTerm.Total_Credits__c;
                }
                
               
                // iteration for each credits
                for(NCP_Credits__c credit : lstCredits){
                    
                    // if the record is approved and non workshop
                    //if(credit.Session_Type__c != 'NCP CE Workshop'){
                            if (credit.FON_Audit_Adjusted_Value__c != null && !String.isEmpty(String.valueOf(credit.FON_Audit_Adjusted_Value__c).trim())) {
                                progProfileObj.adjustedCredits += credit.FON_Audit_Adjusted_Value__c;
                            } else {
                                progProfileObj.adjustedCredits += credit.Credit_Value__c;
                            }
                    //   }

                }
                
                
                // adding obj to list
                system.debug('\n--progProfileObj--'+progProfileObj);
                onloadObj.lstProfileWrapper.add(progProfileObj);
                system.debug('\n--onloadObj--'+onloadObj);
            }
                      
        }
        return onloadObj;  
    }
        
    
    // wrapper classes
    public class OnLoadWrapper{
        @AuraEnabled public User userDetails {get;set;}
        @AuraEnabled public integer startYear {get;set;}
        @AuraEnabled public integer endYear {get;set;}
        @AuraEnabled public decimal CreditsRequired {get;set;}
        @AuraEnabled public decimal WCreditsRequired {get;set;}
        @AuraEnabled public ProgramApi__Program_Profile__c lastestProgProfile {get;set;}        
        @AuraEnabled public List<ProfWrapper> lstProfileWrapper {get;set;}        
    }
    
    public Class ProfWrapper{
        @AuraEnabled public ProgramApi__Program_Profile__c progProfile {get;set;}
        @AuraEnabled public List<programTermWrapper> progTerms {get;set;}
        @AuraEnabled public integer startYear {get;set;}
        @AuraEnabled public integer endYear {get;set;}
        
        @AuraEnabled public Decimal approvedCredits {get;set;}
        @AuraEnabled public Decimal adjustedCredits {get;set;}
         @AuraEnabled public Decimal calculatedCredits {get;set;}
        @AuraEnabled public Decimal approvedWorkCredits {get;set;}
        @AuraEnabled public Decimal calculatedWorkCredits {get;set;}
        @AuraEnabled public Decimal AllCredits {get;set;}
        @AuraEnabled public Decimal AllWorkCredits {get;set;}  
        
        // constructor
        public ProfWrapper(){
            this.approvedCredits = 0;
            this.adjustedCredits = 0;
            this.approvedWorkCredits = 0;
            this.calculatedCredits = 0;
            this.calculatedWorkCredits = 0;
            this.AllCredits = 0;
            this.AllWorkCredits = 0;
            this.progProfile = new ProgramApi__Program_Profile__c();
        }
        
    }
    
    public class programTermWrapper{
        @AuraEnabled public ProgramApi__Program_Term__c progTerm {get;set;}
        @AuraEnabled public Decimal approvedCredits {get;set;}
        @AuraEnabled public Decimal adjCredits {get;set;}
        @AuraEnabled public Decimal approvedWorkCredits {get;set;}
        @AuraEnabled public Decimal AllCredits {get;set;}
        @AuraEnabled public Decimal AllWorkCredits {get;set;}  
        
        // constructor
        public programTermWrapper(ProgramApi__Program_Term__c progTerm, List<NCP_Credits__c> lstCredits){
            this.progTerm = progTerm;
            this.approvedCredits = 0;
            this.adjCredits = 0;
            this.approvedWorkCredits = 0;
            this.AllCredits = 0;
            this.AllWorkCredits = 0;
            
            // code for making total for each prg profile            
            for(NCP_Credits__c credit : lstCredits){
                
                // if the record is approved and non workshop
                if(credit.Status__c == 'Approved'
                   &&  credit.Session_Type__c != 'NCP CE Workshop'){
                       if(credit.Credit_Value__c != null)
                           this.approvedCredits += credit.Credit_Value__c;
                       if (credit.FON_Audit_Adjusted_Value__c != null && !String.isEmpty(String.valueOf(credit.FON_Audit_Adjusted_Value__c).trim())) {
                            this.adjCredits += credit.FON_Audit_Adjusted_Value__c;
                        } else {
                            this.adjCredits += credit.Credit_Value__c;
                        }
                }



                
                // saving the credtis for all
                if(credit.Status__c == 'Pending for Approval'
                   &&  credit.Session_Type__c != 'NCP CE Workshop'){
                       if(credit.Credit_Value__c != null)
                           this.AllCredits += credit.Credit_Value__c;
                }
                
                // saving the workshop for all
                if(credit.Status__c == 'Approved'
                   &&  credit.Session_Type__c == 'NCP CE Workshop'){
                       if(credit.Credit_Value__c != null)
                           this.approvedWorkCredits += credit.Credit_Value__c;
                }
                
                // saving the workshop for all
                if(credit.Status__c == 'Pending for Approval'
                    && credit.Session_Type__c == 'NCP CE Workshop'){
                       if(credit.Credit_Value__c != null)
                           this.AllWorkCredits += credit.Credit_Value__c;
                }                
            }
        }
    }
     
}