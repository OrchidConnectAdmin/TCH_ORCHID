/**
* Created by nkopparthi on 11/16/20.
*/

public without sharing class FON_SalesOrderService {
    
    public static void approveOldCredits(List<OrderApi__Sales_Order__c> records, Map<Id,OrderApi__Sales_Order__c> oldRecords) {
        
        Set<Id> conIds = new Set<Id>();
        List<Id> soIds = new List<Id>();
        List<OrderApi__Sales_Order__c> soList = new List<OrderApi__Sales_Order__c>();
        List<NCP_Credits__c> ncpCredits = new List<NCP_Credits__c>();
        List<NCP_Credits__c> ncpCreditsUpd = new List<NCP_Credits__c>();
        Id ItemID = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'CE Credit Filing Fee' LIMIT 1].Id;
        
        for(OrderApi__Sales_Order__c so :records){
            if(so.OrderApi__Is_Posted__c == TRUE && oldRecords.get(so.Id).OrderApi__Is_Posted__c == FALSE){
                soIds.add(so.Id);
            }
        }
        
        soList = [
            SELECT  Id,
            OrderApi__Contact__c,
            (SELECT Id,
             OrderApi__Item__c
             FROM OrderApi__Sales_Order_Lines__r)
            FROM OrderApi__Sales_Order__c
            WHERE Id IN :soIds
        ];
        
        for(OrderApi__Sales_Order__c so : soList){
            for(OrderApi__Sales_Order_Line__c sol : so.OrderApi__Sales_Order_Lines__r){
                if(sol.OrderApi__Item__c == ItemID){
                    conIds.add(so.OrderApi__Contact__c);
                }
            }
        }
        
        ncpCredits = [
            SELECT  Id,
            FON_Session_Date__c,
            Status__c
            FROM NCP_Credits__c
            WHERE Contact_Name__c IN :conIds
            AND Status__c = 'Pending for Approval'
            AND Session_Type__c != 'NCP CE Workshop'
        ];
        
        for(NCP_Credits__c ncp : ncpCredits){
            if(ncp.FON_Session_Date__c.year() == system.today().year() - 1){
                ncp.Status__c = 'Approved';
                ncpCreditsUpd.add(ncp);
            }
        }
        
        if(!ncpCreditsUpd.isEmpty()){
            update ncpCreditsUpd;
        }
        
    }
    
    /***
*  This method will be called on update of the SO and if the is posted is made from false then it will query the
*  Related application and make the field is paid to true
**/
    public static void ApproveApplications(List<OrderApi__Sales_Order__c> records, Map<Id,OrderApi__Sales_Order__c> oldRecords) {
        List<Application__c> applicationList = new List<Application__c>();
        for(OrderApi__Sales_Order__c so : records){
            OrderApi__Sales_Order__c oldRec = oldRecords.get(so.Id);
            if(oldRec.OrderApi__Is_Posted__c == false && so.OrderApi__Is_Posted__c == true){
                Application__c app = new Application__c();
                if(so.Application__c!=null){
                    app.Id = so.Application__c;
                    app.IsPaid__c = true;
                    applicationList.add(app);
                }
            }
        }
        if(applicationList != null && !applicationList.isEmpty()){
            update applicationList;
        }
    }
    
    public static void generateCandidateId(List<OrderApi__Sales_Order__c> records){
        List<OrderApi__Sales_Order_Line__c> sols = [SELECT Id, OrderApi__Sales_Order__c, OrderApi__Contact__c 
                                                    FROM OrderApi__Sales_Order_Line__c 
                                                    WHERE OrderApi__Sales_Order__c IN: records AND (Event_Is_NCP_Exam__c = true OR Event_Name__c LIKE '%Exam%')];
        
        Integer currentYear = system.today().year();
        List<CandidateId__c> ci = [SELECT Id  FROM CandidateId__c LIMIT 1];
        
        if(ci.size() == 0){
            CandidateId__c newCI = new CandidateId__c();
            newCI.Candidate_Id_Number__c = 0;
            newCI.Candidate_Id_Text__c= 'HRNCP';
            insert newCI;
        }
        
        List<CandidateId__c> ciG = [SELECT Id, Candidate_Id_Number__c, Candidate_Id_Text__c  FROM CandidateId__c LIMIT 1];
        
        String lastCandidateText;
        Integer currentCandidateNumber;
        String currentCandidateFull;
        
        lastCandidateText = ciG[0].Candidate_Id_Text__c + string.valueOf(currentYear).right(2);
        currentCandidateNumber = integer.valueOf(ciG[0].Candidate_Id_Number__c + 1);
        currentCandidateFull = lastCandidateText + string.valueOf(currentCandidateNumber).leftPad(4,'0');
        
        
        List<String> contIds = new List<String>();
        Set<Contact> contsToUpdateSet = new Set<Contact>();
        List<Contact> contsToUpdate = new List<Contact>();
        Map<String, List<OrderApi__Sales_Order_Line__c>> soToExamSols = new Map<String, List<OrderApi__Sales_Order_Line__c>>();
        for(OrderApi__Sales_Order_Line__c sol : sols){
            contIds.add(sol.OrderApi__Contact__c);
            if(soToExamSols.containsKey(sol.OrderApi__Sales_Order__c)){
                soToExamSols.get(sol.OrderApi__Sales_Order__c).add(sol);
            }else{
                soToExamSols.put(sol.OrderApi__Sales_Order__c, new List<OrderApi__Sales_Order_Line__c>{sol});
            }
        }
        List<Contact> conts = [SELECT Id, FON_NCP_Candidate_ID__c, FON_Candidate_Id_Generated_On__c FROM Contact WHERE Id IN: contIds];
        Map<Id, Contact> mapConts = new Map<Id, Contact>(conts);
        for(OrderApi__Sales_Order__c so : records){
            if(soToExamSols.containsKey(so.Id)){
                if(string.isBlank(mapConts.get(so.OrderApi__Contact__c).FON_NCP_Candidate_ID__c)){
                    mapConts.get(so.OrderApi__Contact__c).FON_NCP_Candidate_ID__c = currentCandidateFull;
                    mapConts.get(so.OrderApi__Contact__c).FON_Candidate_Id_Generated_On__c = system.now();
                    contsToUpdateSet.add(mapConts.get(so.OrderApi__Contact__c));
                    currentCandidateNumber += 1;
                    currentCandidateFull = lastCandidateText + string.valueOf(currentCandidateNumber).leftPad(4,'0');
                }
            }
        }
        ciG[0].Candidate_Id_Number__c = currentCandidateNumber - 1;
        update ciG;
        
        if(contsToUpdateSet.size() > 0){
            contsToUpdate.addAll(contsToUpdateSet);
            update contsToUpdate;
        }
    }
    
}