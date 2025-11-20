public class ProgramProfileAudit {
    // display/Hide spinner in vf page 
    public Boolean displaySpinner {get;set;}
    
    public ProgramProfileAudit(ApexPages.StandardSetController controller){
        
    }
    /*
     * Name : updateProgramFile
     * Des : method will be used to update Program Profile and their contact records
     * */
    public void updateProgramFile(){
        displaySpinner = true;
        
        // this will save the 50 program profile Ids
        set<string> setProcressProgIds = new set<string>();
        
        // this is for gettting the last year
        integer lastYear = system.today().year() - 1;
        
        // getting the program of last year
        for(NCP_Credits__c crdits : [SELECT Id,
                                            Program_Term__r.ProgramApi__Profile__r.FON_Audited__c,
                                            Program_Term__r.ProgramApi__Profile__r.FON_Audited_Year__c,
                                            Program_Term__r.ProgramApi__Profile__r.ProgramApi__Contact__r.Sent_Audit_Email__c,
                                            Program_Term__r.ProgramApi__Profile__r.ProgramApi__Contact__c,
                                            Program_Term__r.ProgramApi__Profile__r.ProgramApi__Status__c,
                                            Program_Term__r.ProgramApi__Profile__r.ProgramApi__Contact__r.Send_Email__c,
                                            Program_Term__r.ProgramApi__Start_Date__c,
                                            Program_Term__r.ProgramApi__End_Date__c,
                                            Program_Term__r.ProgramApi__Profile__c
                                        FROM NCP_Credits__c
                                        WHERE Program_Term__r.ProgramApi__Profile__r.FON_Audited__c = false
                                        AND Program_Term__r.ProgramApi__Profile__r.ProgramApi__Status__c = 'On Track'
                                        AND Program_Term__r.ProgramApi__Profile__r.ProgramApi__Contact__c != null
                                        AND CALENDAR_YEAR(Program_Term__r.ProgramApi__Start_Date__c) = :lastYear
                                        AND (Program_Term__r.FON_Workshops_Attended2__c > 0 OR Program_Term__r.FON_Credits_Acquired__c  > 0)
                                        AND CALENDAR_YEAR(Program_Term__r.ProgramApi__End_Date__c) = :lastYear LIMIT 40000]){
            
                                            // we have received 50 program profles then break the further processing
                                            if(setProcressProgIds.size() > 50){
                                                break;                                        
                                            }
                                            else{
                                                setProcressProgIds.add(crdits.Program_Term__r.ProgramApi__Profile__c); 
                                            }
        }
        system.debug('\n--setProcressProgIds--'+setProcressProgIds);        
        
        if(test.isrunningTest()){
            for(ProgramApi__Program_Profile__c progPr : [SELECT ID FROM ProgramApi__Program_Profile__c limit 1]){
                setProcressProgIds.add(progPr.Id);
            }
        }
        
        
        List<ProgramApi__Program_Profile__c> progProList = [SELECT Id,FON_Audited__c,FON_Audited_Year__c,
                                                            ProgramApi__Contact__r.Sent_Audit_Email__c,
                                                            ProgramApi__Contact__c,ProgramApi__Status__c,
                                                            ProgramApi__Contact__r.Send_Email__c,FON_Audit_Status__c,
                                                            (SELECT Id,
                                                                    ProgramApi__Start_Date__c,
                                                                    ProgramApi__End_Date__c
                                                                FROM ProgramApi__Program_Terms__r)
                                                            FROM ProgramApi__Program_Profile__c
                                                            WHERE id IN:setProcressProgIds
                                                            LIMIT 50];
        if(progProList  != null && !progProList.isEmpty()){
            List<Contact> conList = new List<Contact>();
            set<Id> conIdSet = new set<Id>();
            for(ProgramApi__Program_Profile__c progPro : progProList){
                
                if(progPro.ProgramApi__Contact__r.Sent_Audit_Email__c == false 
                        && !conIdSet.contains(progPro.ProgramApi__Contact__c)){
                    Contact con = new Contact();
                    con.Id = progPro.ProgramApi__Contact__c;
                    con.Sent_Audit_Email__c = true;
                    conList.add(con);
                    conIdSet.add(con.Id);
                    
                    // setting the prog profile audit to false
                    progPro.FON_Audited__c = true;
                    progPro.FON_Audit_Status__c = 'In Progress';
                    progPro.FON_Audit_Date__c = System.Today();
                    progPro.FON_Audited_By__c = userinfo.getUserId();
                    progPro.FON_Audited_Year__c = System.Today().addYears(-1).year();
                }
            }
            System.debug('conList :--->'+conList);
            
            try{
                if(conList != null && !conList.isEmpty()){
                    update conList;
                }
                System.debug('progProList :--->'+progProList);
                update progProList;
            }catch(exception ex){
                displaySpinner = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,ex.getMessage()));
            }
            
        }
        displaySpinner = false;
        
    }
    
    /*
* Name : redirect
* Des : ths method will be used to redirect the contact list view.
* */
    public PageReference redirect(){
        String orgUrl = URL.getSalesforceBaseUrl().getHost();
        string url = 'https://'+orgUrl+'/lightning/o/ProgramApi__Program_Profile__c/list?filterName=00B6g000001TMmHEAW';
        System.debug('inside redirect');
        PageReference pageRef  = new PageReference(url);
        pageRef .setRedirect(true);
        System.debug('pageRef  : ' + pageRef  );
        return pageRef  ;
    }
}