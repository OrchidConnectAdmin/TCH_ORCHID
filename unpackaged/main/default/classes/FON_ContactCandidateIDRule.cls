global class FON_ContactCandidateIDRule extends Framework.Domain{
    public FON_ContactCandidateIDRule(List<Contact> sObjectList) {
        super(sObjectList);
    }

    global class Constructor implements Framework.Domain.DomainConstructor {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new FON_ContactCandidateIDRule(sObjectList);
        }
    }

    public override void beforeInsert() {
        Framework.Log.push(FON_ContactCandidateIDRule.class.getName(),'Before Insert');
        System.debug('Entered FON_ContactCandidateIDRule Before Insert');
    }
    
    public override void beforeUpdate(Map<Id, SObject> oldMap) {
        Framework.Log.push(FON_ContactCandidateIDRule.class.getName(), 'beforeUpdate');
        
        
        /*List<Contact> nrec = (List<Contact>) records;
        Map<Id,Contact> orec = (Map<Id,Contact>) oldMap;
        
        List<CandidateId__c> lci = [SELECT Id, Candidate_Id_Number__c, Candidate_Id_Text__c FROM CandidateId__c ORDER BY Candidate_Id_Number__c DESC LIMIT 1];
        
        String lastCandidateText;
        Integer currentCandidateNumber;
        String currentCandidateFull;
        
        lastCandidateText = ciG[0].Candidate_Id_Text__c + string.valueOf(currentYear).right(2);
        currentCandidateNumber = integer.valueOf(ciG[0].Candidate_Id_Number__c + 1);
        currentCandidateFull = lastCandidateText + string.valueOf(currentCandidateNumber).leftPad(4,'0');
        
        for (Contact con : nrec) {
            Contact ocon = orec.get(con.Id);
            if(con.FON_NCP_Candidate_ID__c == null){
                Integer currentYear = system.today().year();
                Decimal cid = Integer.valueOf(lci[0].Candidate_Id_Number__c);
                List<CandidateId__c> ci = [SELECT Id, Candidate_Id_Number__c, Candidate_Id_Text__c FROM CandidateId__c WHERE Candidate_Id_Number__c =: cid and Candidate_Id_Text__c=:lci[0].Candidate_Id_Text__c ORDER BY Candidate_Id_Number__c DESC LIMIT 1];
                con.FON_NCP_Candidate_ID__c = cid + 1;
                if(ci.size() < 1){
                    if(lci[0].Candidate_Id_Number__c < cid){
                        lci[0].Candidate_Id_Number__c = cid + 1;
                        update lci;
                    }
                    
                }
            }
        }    */    
        
        
        
        
        
        System.debug('Entered FON_ContactCandidateIDRule Before Update');
    }
    
    public override void afterUpdate(Map<Id,SObject> oldMap) {
        Framework.Log.push(FON_ContactCandidateIDRule.class.getName(), 'afterUpdate');
        List<Contact> nrec = (List<Contact>) records;
        Map<Id,Contact> orec = (Map<Id,Contact>) oldMap;
        
        List<CandidateId__c> lci = [SELECT Id, Candidate_Id_Number__c, Candidate_Id_Text__c FROM CandidateId__c ORDER BY Candidate_Id_Number__c DESC LIMIT 1];

        
        for (Contact con : nrec) {
            Contact ocon = orec.get(con.Id);
            if(ocon.FON_NCP_Candidate_ID__c != con.FON_NCP_Candidate_ID__c){
                Integer currentYear = system.today().year();
                Decimal cid = Integer.valueOf(con.FON_NCP_Candidate_ID__c.right(4));
                List<CandidateId__c> ci = [SELECT Id, Candidate_Id_Number__c, Candidate_Id_Text__c FROM CandidateId__c WHERE Candidate_Id_Number__c =: cid and Candidate_Id_Text__c=:lci[0].Candidate_Id_Text__c ORDER BY Candidate_Id_Number__c DESC LIMIT 1];
                
                if(ci.size() < 1){
                    if(lci[0].Candidate_Id_Number__c < cid){
                    	lci[0].Candidate_Id_Number__c = cid;
                        update lci;
                    }
                }
            }
            
        }
        
        
        
        Framework.Log.pop();
    }

}