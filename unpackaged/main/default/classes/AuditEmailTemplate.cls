public class AuditEmailTemplate{
    
    public ProgramApi__Program_Profile__c progProfileRec {get;set;}
    public List<NCP_Credits__c  > ncpCreditList {get;set;}
    
    
    // getting prog prof details
    public ProgramApi__Program_Profile__c getprogProfileDetails(){
        return [select ProgramApi__Contact__r.FirstName, ProgramApi__Contact__r.LastName FROM ProgramApi__Program_Profile__c WHERE ID=:progProfileRec.Id];
    }
    
    // this method will be used to pull the data for the table
    public List<NCP_Credits__c> getlstTableData(){
        System.debug('getlstTableData : ');
        System.debug('progProfileRec : ' + progProfileRec);
        if(progProfileRec != null && progProfileRec.Id != null){
           List<ProgramApi__Program_Term__c> progTermList =  getProgTermList();
            if(progTermList != null && !progTermList.isEmpty()){
                Set<Id> progTermIdSet = new set<Id>();
                for(ProgramApi__Program_Term__c progTerm : progTermList){
                    progTermIdSet.add(progTerm.Id);
                }
                ncpCreditList = fetchNCPCredits(progTermIdSet);
                System.debug('ncpCreditList : '+ ncpCreditList);
            }
        }
        return ncpCreditList;
    }
    
    
    /*
     * Name : getProgTermList
     * Description : this method will be used to fetch Program Term record based on theri parent(Program Profile) Ids.
     * */
    public List<ProgramApi__Program_Term__c> getProgTermList(){
        return [SELECT Id 
                FROM ProgramApi__Program_Term__c 
                WHERE ProgramApi__Profile__c =: progProfileRec.Id];
    }
    
     /*
     * Name : fetchNCPCredits
     * Description : this method will be used to fecth ncp Credit record based on their program term(Parent object) id
     * */
    public  List<NCP_Credits__c> fetchNCPCredits(Set<Id>ProgTermIdSet){
        return [SELECT Id,
                Program_Term__c,FON_Session_Date__c,FON_Provider_Name__c,
                Session_Description__c,FON_Session_Period__c,
                Session_Title__c,
                Session_Type__c,
                Credit_Value__c,NCP_Session__c,
                NCP_Session__r.Session_ID__c,
                NCP_Session__r.Session_Date__c,
                NCP_Session__r.Description__c,
                //NCP_Session__r.Session_Title__c,
                NCP_Session__r.Credit_Val__c
                FROM NCP_Credits__c
                WHERE Program_Term__c IN: ProgTermIdSet];
    }

}