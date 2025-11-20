/**
 * Created by nkopparthi on 9/21/20.
 */

public without sharing class FON_ReceiptService {

    /*public static void generateCandidateID(List<OrderApi__Receipt__c> records, Map<Id,OrderApi__Receipt__c> oldRecords){

        Set<Id> receiptIds = new Set<Id>();
        List<OrderApi__Receipt_Line__c> recLines = new List<OrderApi__Receipt_Line__c>();
        Set<Id> contactIds = new Set<Id>();
        List<Contact> contacts = new List<Contact>();
        Set<Id> newCandidates = new Set<Id>();
        List<Contact> latestCandidate = new List<Contact>();
        List<Contact> finalList = new List<Contact>();
        List<Contact> lstUpdContacts = new List<Contact>();
        String lastCandidateId;
        Integer currentYear; // = date.today().year();


        for(OrderApi__Receipt__c rec : records){

            system.debug(LoggingLevel.INFO, '***Criteria1***'+rec.OrderApi__Is_Posted__c);
            system.debug(LoggingLevel.INFO, '***Criteria1***'+oldRecords.get(rec.Id).OrderApi__Is_Posted__c);
            system.debug(LoggingLevel.INFO, '***Criteria1***'+rec.OrderApi__Balance__c);

            if(rec.OrderApi__Is_Posted__c && oldRecords.get(rec.Id).OrderApi__Is_Posted__c != rec.OrderApi__Is_Posted__c && rec.OrderApi__Balance__c == 0){

                system.debug(LoggingLevel.INFO, '***FON_ReceiptService Criteria Satisfied***');

                receiptIds.add(rec.Id);

            }
        }

        recLines = [
                SELECT Id,
                        OrderApi__Item__r.ProgramApi__Program__r.Name,
                        OrderApi__Receipt__c,
                        OrderApi__Receipt__r.OrderApi__Contact__c,
                        OrderApi__Item__r.NCP_Exam_year__c
                FROM OrderApi__Receipt_Line__c
                WHERE OrderApi__Receipt__c IN :receiptIds
                AND OrderApi__Item__r.ProgramApi__Program__r.Name = 'NCP'
        ];

        system.debug(LoggingLevel.INFO, '***recLines***'+recLines);

        if(!recLines.isEmpty()) {
            for (OrderApi__Receipt_Line__c rls : recLines) {
                contactIds.add(rls.OrderApi__Receipt__r.OrderApi__Contact__c);
                if (rls.OrderApi__Item__r.NCP_Exam_year__c != NULL) {
                    currentYear = Integer.valueOf(rls.OrderApi__Item__r.NCP_Exam_year__c);
                }
            }


            system.debug(LoggingLevel.INFO, '***contactIds***' + contactIds);

            contacts = [
                    SELECT Id,
                            FON_NCP_Candidate_ID__c
                    FROM Contact
                    WHERE Id IN :contactIds
            ];

            system.debug(LoggingLevel.INFO, '***contacts***' + contacts);

            for (Contact con : contacts) {
                if (con.FON_NCP_Candidate_ID__c == NULL || con.FON_NCP_Candidate_ID__c == '') {
                    newCandidates.add(con.Id);
                }
            }

            system.debug(LoggingLevel.INFO, '***newCandidates***' + newCandidates);

            latestCandidate = [
                    SELECT Id,
                            FON_NCP_Candidate_ID__c
                    FROM Contact
                    WHERE FON_NCP_Candidate_ID__c != NULL
                    AND FON_Exam_Year__c = :currentYear
                    //AND CALENDAR_YEAR(FON_Candidate_Id_Generated_On__c) = :currentYear
                    ORDER BY FON_Candidate_Id_Generated_On__c DESC
                    LIMIT 1
            ];

            system.debug(LoggingLevel.INFO, '***latestCandidate***' + latestCandidate);

            if (!latestCandidate.isEmpty()) {
                lastCandidateId = latestCandidate[0].FON_NCP_Candidate_ID__c;
            } else {
                //lastCandidateId = 'HRNCP'+system.now().format('YY')+'0000';
                lastCandidateId = 'HRNCP' + string.valueOf(currentYear).right(2) + '0000';
            }

            system.debug(LoggingLevel.INFO, '***lastCandidateId***' + lastCandidateId);

            finalList = [
                    SELECT Id,
                            FON_NCP_Candidate_ID__c,
                            FON_Candidate_Id_Generated_On__c
                    FROM Contact
                    WHERE Id IN :newCandidates
            ];

            system.debug(LoggingLevel.INFO, '***finalList***' + finalList);

            Integer lastFour = Integer.valueOf(lastCandidateId.right(4));

            system.debug(LoggingLevel.INFO, '***lastFour***' + lastFour);

            for (Contact con : finalList) {
                lastFour = lastFour + 1;
                system.debug(LoggingLevel.INFO, '***lastFour***' + lastFour);
                String strZeros = '';
                system.debug(LoggingLevel.INFO, '***strZeros***' + strZeros);
                Integer length = string.valueOf(lastFour).length();
                system.debug(LoggingLevel.INFO, '***length***' + length);
                Integer i;
                system.debug(LoggingLevel.INFO, '***i***' + i);
                for (i = 0; i < 4 - length; i++) {
                    strZeros = strZeros + '0';
                }
                system.debug(LoggingLevel.INFO, '***strZeros***' + strZeros);
                String strNum = strZeros + string.valueOf(lastFour);
                system.debug(LoggingLevel.INFO, '***strNum***' + strNum);
                //con.FON_NCP_Candidate_ID__c = 'HRNCP'+system.now().format('YY')+strNum;
                con.FON_NCP_Candidate_ID__c = 'HRNCP' + string.valueOf(currentYear).right(2) + strNum;
                con.FON_Candidate_Id_Generated_On__c = system.now();
                con.FON_Exam_Year__c = Integer.valueOf(system.now().format('YYYY'));
                lstUpdContacts.add(con);
            }

            system.debug(LoggingLevel.INFO, '***lstUpdContacts***' + lstUpdContacts);

            if (!lstUpdContacts.isEmpty()) {
                update lstUpdContacts;
            }
        }

    }*/

    public static void createCEWrkshp(List<OrderApi__Receipt__c> records, Map<Id,OrderApi__Receipt__c> oldRecords){

        Set<Id> receiptIds = new Set<Id>();
        List<OrderApi__Receipt_Line__c> recLines = new List<OrderApi__Receipt_Line__c>();
        Set<Id> conId = new Set<Id>();
        List<ProgramApi__Program_Profile__c> ppList = new List<ProgramApi__Program_Profile__c>();
        Map<Id, Id> mapConPT = new Map<Id, Id>();
        List<NCP_Credits__c> lstNCPIns = new List<NCP_Credits__c>();

        for(OrderApi__Receipt__c rec : records){

            if(rec.OrderApi__Is_Posted__c && oldRecords.get(rec.Id).OrderApi__Is_Posted__c != rec.OrderApi__Is_Posted__c && rec.OrderApi__Balance__c == 0){

                receiptIds.add(rec.Id);

            }
        }

        recLines = [
                SELECT  Id,
                        OrderApi__Contact__c,
                        OrderApi__Item__r.FON_Session_Types__c,
                        OrderApi__Receipt__c,
                        OrderApi__Receipt__r.OrderApi__Contact__c
                FROM OrderApi__Receipt_Line__c
                WHERE OrderApi__Receipt__c IN :receiptIds
                AND (OrderApi__Item__r.FON_Session_Types__c = 'NCP CE Workshop' OR OrderApi__Item__r.OrderApi__Item_Class__r.Name = 'NCP CE Workshops')
        ];

        for(OrderApi__Receipt_Line__c rl : recLines){
            conId.add(rl.OrderApi__Contact__c);
        }

        ppList = [SELECT Id, ProgramApi__Contact__c, (SELECT Id, ProgramApi__Active__c FROM ProgramApi__Program_Terms__r) FROM ProgramApi__Program_Profile__c WHERE ProgramApi__Contact__c IN :conId];

        for(ProgramApi__Program_Profile__c pp : ppList){
            for(ProgramApi__Program_Term__c pt : pp.ProgramApi__Program_Terms__r){
                if(pt.ProgramApi__Active__c == TRUE){
                    mapConPT.put(pp.ProgramApi__Contact__c, pt.Id);
                }
            }
        }

        for(OrderApi__Receipt_Line__c rl : recLines){
            NCP_Credits__c ncp = new NCP_Credits__c();
            ncp.Contact_Name__c = rl.OrderApi__Contact__c;
            ncp.Session_Type__c = 'NCP CE Workshop';
            ncp.Program_Term__c = mapConPT.get(rl.OrderApi__Contact__c);
            lstNCPIns.add(ncp);
        }

        if(!lstNCPIns.isEmpty()){
            insert lstNCPIns;
        }

    }
}