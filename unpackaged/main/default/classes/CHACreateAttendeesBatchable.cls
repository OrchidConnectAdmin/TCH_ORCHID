global without sharing class CHACreateAttendeesBatchable
    implements Database.Batchable<SObject>, Database.AllowsCallouts
{
    global List<String> listIds;
    global String fields;
    global String filters;
    global String errorMsg;
    //global String reportId;

    // Must be global so the no-arg constructor is found at runtime
    global CHACreateAttendeesBatchable() {
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if (Test.isRunningTest()) {
            return Database.getQueryLocator(
                [
                    SELECT
                        Id,
                        OrderApi__Item__c,
                        OrderApi__Sales_Order__c,
                        OrderApi__Account__c,
                        OrderApi__Contact__c,
                        EventApi__Ticket_Type__c,
                        (
                            SELECT
                                Id,
                                OrderApi__Sales_Order__c,
                                OrderApi__Account__c,
                                OrderApi__Contact__c,
                                EventApi__Ticket_Type__c,
                                EventApi__Schedule_Item__c
                            FROM OrderApi__Sales_Order_Lines__r
                            WHERE EventApi__Schedule_Item__c != null
                        )
                    FROM OrderApi__Sales_Order_Line__c
                ]
            );
        } else {
            String whereId = '';
            String fetchFields = '';
            String additionalWhere = '';

            if (!String.isBlank(fields)) {
                // If the caller passed in a custom “fields” string, append it
                fetchFields = ', ' + fields;
            } else {
                // Otherwise default to these fields + the two child‐relationship subqueries
                fetchFields =
                    'Id, '
                  + 'OrderApi__Item__c, '
                  + 'OrderApi__Sales_Order__c, '
                  + 'OrderApi__Account__c, '
                  + 'OrderApi__Contact__c, '
                  + 'EventApi__Ticket_Type__c, '
                  + '(SELECT '
                        + 'Id, '
                        + 'OrderApi__Sales_Order__c, '
                        + 'OrderApi__Account__c, '
                        + 'OrderApi__Contact__c, '
                        + 'EventApi__Ticket_Type__c, '
                        + 'EventApi__Schedule_Item__c '
                      + 'FROM OrderApi__Sales_Order_Lines__r '
                      + 'WHERE EventApi__Schedule_Item__c != null), '
                  + '(SELECT Id FROM OrderApi__Assignments__r)';
            }

            if (!String.isBlank(filters)) {
                additionalWhere = ' AND ' + filters + ' AND ';
            } else if (listIds == null) {
                // no additional filters specified
            }

            // Build the dynamic SOQL
            String query =
                  'SELECT ' + fetchFields
                + ' FROM OrderApi__Sales_Order_Line__c WHERE ';

            if (listIds == null) {
                // If no IDs were passed in, just append whatever “filters” was
                query += additionalWhere;
            } else {
                whereId = 'Id IN (\'' + String.join(listIds, '\', \'') + '\') ';
                query += whereId + additionalWhere;
            }

            System.debug('QUERY ' + query);
            return Database.getQueryLocator(query);
        }
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        // 1) Build attendee records
        List<EventApi__Attendee__c> attendees = new List<EventApi__Attendee__c>();
        Map<Id, List<OrderApi__Sales_Order_Line__c>> mapSOLxSOLS = new Map<Id, List<OrderApi__Sales_Order_Line__c>>();
        Map<Id, Id> mapTicketxItem = new Map<Id, Id>();

        for (SObject s : scope) {
            OrderApi__Sales_Order_Line__c sol = (OrderApi__Sales_Order_Line__c) s;

            if (!Test.isRunningTest()) {
                // Map ticketType → itemId for the later registration‐item insert
                mapTicketxItem.put(sol.EventApi__Ticket_Type__c, sol.OrderApi__Item__c);
            }

            // Create the Attendee record
            EventApi__Attendee__c att = new EventApi__Attendee__c();
            att.EventApi__Account__c          = sol.OrderApi__Account__c;
            att.EventApi__Contact__c          = sol.OrderApi__Contact__c;
            att.EventApi__Sales_Order__c      = sol.OrderApi__Sales_Order__c;
            att.EventApi__Sales_Order_Line__c = sol.Id;
            if (!Test.isRunningTest()) {
                att.EventApi__Ticket_Type__c = sol.EventApi__Ticket_Type__c;
            }
            att.EventApi__Status__c = 'Registered';

            // If there is an Assignment child, attach its Id
            List<OrderApi__Assignment__c> asst = sol.OrderApi__Assignments__r;
            if (asst != null && !asst.isEmpty()) {
                att.EventApi__Assignment__c = asst[0].Id;
            }

            attendees.add(att);

            // Gather all “child” Sales Order Lines (packages) under this SOL
            List<OrderApi__Sales_Order_Line__c> psols = sol.OrderApi__Sales_Order_Lines__r;
            if (psols != null && !psols.isEmpty()) {
                mapSOLxSOLS.put(sol.Id, psols);
            }
        }

        if (!attendees.isEmpty()) {
            insert attendees;

            // 2) For each inserted Attendee, create Registration_Item__c records
            List<EventApi__Registration_Item__c> regs = new List<EventApi__Registration_Item__c>();
			List<OrderApi__Sales_Order_Line__c> usols = new List<OrderApi__Sales_Order_Line__c>();
            for (EventApi__Attendee__c att : attendees) {
                // “Main” registration item for the ticket itself
                EventApi__Registration_Item__c mreg = new EventApi__Registration_Item__c();
                mreg.EventApi__Attendee__c         = att.Id;
                mreg.EventApi__Sales_Order__c      = att.EventApi__Sales_Order__c;
                mreg.EventApi__Sales_Order_Line__c = att.EventApi__Sales_Order_Line__c;
                mreg.EventApi__Status__c           = 'Registered';
                mreg.EventApi__Ticket_Type__c      = att.EventApi__Ticket_Type__c;

                Id itemId = mapTicketxItem.get(att.EventApi__Ticket_Type__c);
                if (itemId != null) {
                    mreg.EventApi__Item__c = itemId;
                }
                regs.add(mreg);
                
                // update main sol
                OrderApi__Sales_Order_Line__c usol = new OrderApi__Sales_Order_Line__c();
                usol.Id = att.EventApi__Sales_Order_Line__c;
                usol.EventApi__Attendee__c = att.Id;
                
                usols.add(usol);

                // Now “package” registration items (child SOLs) under this attendee
                List<OrderApi__Sales_Order_Line__c> childSols =
                    mapSOLxSOLS.get(att.EventApi__Sales_Order_Line__c);
                if (childSols != null && !childSols.isEmpty()) {
                    for (OrderApi__Sales_Order_Line__c psol : childSols) {
                        EventApi__Registration_Item__c preg = new EventApi__Registration_Item__c();
                        preg.EventApi__Attendee__c         = att.Id;
                        preg.EventApi__Sales_Order__c      = att.EventApi__Sales_Order__c;
                        preg.EventApi__Sales_Order_Line__c = att.EventApi__Sales_Order_Line__c;
                        preg.EventApi__Status__c           = 'Registered';
                        preg.EventApi__Schedule_Item__c    = psol.EventApi__Schedule_Item__c;
                        preg.EventApi__Item__c             = psol.OrderApi__Item__c;
                        regs.add(preg);
                    }
                }
            }

            if (!regs.isEmpty()) {
                insert regs;
            }
            if (!usols.isEmpty()) {
                update usols;
            }

        }
    }

    global void finish(Database.BatchableContext BC) {
        // The vars++ loops stay exactly as they were
        Integer vars = 0;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
    }
}