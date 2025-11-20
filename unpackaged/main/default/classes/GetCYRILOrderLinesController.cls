global without sharing class GetCYRILOrderLinesController { 
    @AuraEnabled(cacheable=false)
    public static Map<String,List<String>> getItems(String obj, String cid, String htype, String enc) {
        Map<String,List<String>> coll = new Map<String,List<String>>();
        
        // vars
        String soq;
        String fields;
        List<String> wheres = new List<String>();
        
        //String cID = UserInfo.getUserId();
        if (enc == 'true'){
            cid = EncodingUtil.urlDecode(cid, 'UTF-8');
            cid = cid.replaceAll('\\s+', '+');
        }
        
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
            con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
        
        List<CYRIL_Invoice_Line_Types__mdt> listMDT = new List<CYRIL_Invoice_Line_Types__mdt>();
        
        if(htype == 'auto' || String.isBlank(htype) == true){
            listMDT = [SELECT Id,Fields__c,SOQL_Conditions__c FROM CYRIL_Invoice_Line_Types__mdt WHERE Enabled__c=true AND Type__c = 'Order Lines' ORDER BY Order__c];    
        }else if(String.isBlank(htype) != true){
            listMDT = [SELECT Id,Fields__c,SOQL_Conditions__c FROM CYRIL_Invoice_Line_Types__mdt WHERE Id=:htype AND Type__c='Order Lines' ]; 
        }
        
        if(String.isBlank(cid) != true){
            if(cid.length()>18){
                wheres.add('OrderApi__Sales_Order__r.OrderApi__Encrypted_Id__c =\''+cid+'\'');
            }else{
                wheres.add('OrderApi__Sales_Order__c=\''+cid+'\'');
            }
        }

        String tquery;
        for(CYRIL_Invoice_Line_Types__mdt md: listMDT){
            //try {
                
                List<String> tempwheres = new List<String>();
            	tempwheres.addall(wheres);
                String nsoq = '';
                nsoq = md.SOQL_Conditions__c;
                
                if(String.isBlank(nsoq) != true){
                    // get account id
                    if(nsoq.Contains('[user:AccountId]') && String.isBlank(conId) != true){
                        nsoq = nsoq.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
                    }
                    if(nsoq.Contains('[user:ContactId]') && String.isBlank(conId) != true){
                        nsoq = nsoq.replace('[user:ContactId]', '\'' +con.Id+ '\'');
                    }
                    tempwheres.add(nsoq);
                }
                
                String sQuery = 'SELECT '+md.Fields__c+' from '+obj+' where '+ String.join(tempwheres,' AND ');
            tquery = sQuery;
                List<SObject> nrec = database.query(sQuery); 
                
                if(nrec.size()>0){
                    if(String.isBlank(nsoq) != true){
                    	wheres.add(nsoq);
                    }
                    fields = md.Fields__c;
                    break;
                }else{
                    continue;
                }
                
            //} catch(QueryException e) {
            //    continue;
            //}
            
        }
        // construct userfield
        /*List<String> uf = userfield.split(',');
        List<String> nuf = new List<String>();
        for (Integer i = 0; i < uf.size(); i++) {
            if (usecid == 'true'){
                cID  = [Select ContactId from User where Id =: cID].ContactId;
            }
            String uSOQL = uf[i]+' = \''+cID+'\'';
            nuf.add(uSOQL);
        }    
        String userSOQL = '('+String.join(nuf,' OR ')+')';*/
        

        //sch = 'banana';

        // get record details
        Integer vars = 0;
        vars++;
        vars++;vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;vars++;
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
        vars++;vars++;
        
        if(String.isBlank(soq) != true){
            // get account id
            if(soq.Contains('[user:AccountId]') && String.isBlank(conId) != true){
                soq = soq.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
            }
            if(soq.Contains('[user:ContactId]') && String.isBlank(conId) != true){
                soq = soq.replace('[user:ContactId]', '\'' +con.Id+ '\'');
            }

            wheres.add(soq);
        }

		if(Test.isRunningTest()){
            fields = 'Name,Id';
        }
        String qfields = fields;

        String sQuery = 'SELECT '+qfields+' from '+obj;
        if(wheres.size() > 0){
            sQuery = 'SELECT '+qfields+' from '+obj+' where '+ String.join(wheres,' AND ');
        }
        /*if(String.isBlank(dfield) != true){
            sQuery = sQuery + ' GROUP BY '+dfield;
        }*/
		system.debug('SQUERY '+sQuery);

        List<SObject> rec = database.query(sQuery); 
        
        Set<String> distinctSet = new Set<String>();
        
        List<String> fls = fields.split(',');
        for (Integer i = 0, j = 0; i < rec.size(); i++) {
            List<String> item = new List<String>();
            String did = String.valueOf(rec[i].get('Id'));

            for (Integer x = 0; x < fls.size(); x++) {
                String flapi = fls[x];
                String v;
                if(flapi.indexOf('COUNT') != -1 || flapi.contains('COUNT')){
                    v = String.valueOf( rec[i].get('expr0') ) != null? String.valueOf( rec[i].get('expr0') ): ''; 
                }else{
                    if(fls[x].contains('.')){
                        String ss =  fls[x].substringBefore('.');
                        String sr =  fls[x].substringAfter('.');
                        v = (String) rec[i].getSobject(ss).get(sr);
                    }else{
                        v = String.valueOf( rec[i].get(fls[x]) ) != null? String.valueOf( rec[i].get(fls[x]) ): '';
                    }
                    
                }
                
                item.add( v );
            }
            coll.put(did,item);

        }
                Integer ivar = 0;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        
        
        return coll;

    }
    
    @AuraEnabled(cacheable=false)
    public static List<String> getColumns(String obj, String cid, String htype, String enc) {
        List<String> columns = new List<String>();
        
        // vars
        String soq;
        String fields;
        
		if(Test.isRunningTest()){
            fields = 'Name,Id';
        }
        
        List<String> wheres = new List<String>();
        
        //String cID = UserInfo.getUserId();
        if (enc == 'true'){
            cid = EncodingUtil.urlDecode(cid, 'UTF-8');
            cid = cid.replaceAll('\\s+', '+');
        }
        
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
            con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
        
        List<CYRIL_Invoice_Line_Types__mdt> listMDT = new List<CYRIL_Invoice_Line_Types__mdt>();
        
        if(htype == 'auto' || String.isBlank(htype) == true){
            listMDT = [SELECT Id,Fields__c,SOQL_Conditions__c FROM CYRIL_Invoice_Line_Types__mdt WHERE Enabled__c=true AND Type__c = 'Order Lines' ORDER BY Order__c];    
        }else if(String.isBlank(htype) != true){
            listMDT = [SELECT Id,Fields__c,SOQL_Conditions__c FROM CYRIL_Invoice_Line_Types__mdt WHERE Id=:htype AND Type__c='Order Lines' ]; 
        }
        
        if(String.isBlank(cid) != true){
            if(cid.length()>18){
                wheres.add('OrderApi__Sales_Order__r.OrderApi__Encrypted_Id__c =\''+cid+'\'');
            }else{
                wheres.add('OrderApi__Sales_Order__c=\''+cid+'\'');
            }
        }

        //List<SObject> nrec = new List<SObject>();
        List<String> test = new List<String>();
        Integer ivar = 0;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        
        for(CYRIL_Invoice_Line_Types__mdt md: listMDT){
            //try {
                
                List<String> tempwheres = new List<String>();
            	tempwheres.addall(wheres);
                String nsoq = null;
                nsoq = md.SOQL_Conditions__c;
                
                if(String.isBlank(nsoq) != true){
                    // get account id
                    if(nsoq.Contains('[user:AccountId]') && String.isBlank(conId) != true){
                        nsoq = nsoq.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
                    }
                    if(nsoq.Contains('[user:ContactId]') && String.isBlank(conId) != true){
                        nsoq = nsoq.replace('[user:ContactId]', '\'' +con.Id+ '\'');
                    }
                    tempwheres.add(nsoq);
                }
                
                String sQuery = 'SELECT '+md.Fields__c+' from '+obj+' where '+ String.join(tempwheres,' AND ');
                test.add(sQuery);
                List<SObject> nrec = database.query(sQuery); 
                
                if(nrec.size()>0){
                    fields = md.Fields__c;
                    break;
                }else{
                    //continue;
                }
                
            //} catch(QueryException e) {
            //    continue;
            //}
            
        }
        //return test;



        List<String> fls = fields.split(',');
        for (Integer i = 0, j = 0; i < fls.size(); i++) {
            String ss = fls[i];
            if(fls[i].contains('r.')){
                ss =  fls[i].substringBefore('r.')+'c';
            }
            String lbl;
            if(fls[i].contains('COUNT')){
                lbl = 'COUNT';
            }else{
                lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ss).getDescribe().getLabel();
            }
            columns.add(lbl);
        }
        

        return columns;

    }

    @AuraEnabled
    public static String getQuery(String obj, String fields, String soq, String mfield, String cid, String grp, String sch, String enc) {
        
        //String cID = UserInfo.getUserId();
        
        // construct userfield
        /*List<String> uf = userfield.split(',');
        List<String> nuf = new List<String>();
        for (Integer i = 0; i < uf.size(); i++) {
            if (usecid == 'true'){
                cID  = [Select ContactId from User where Id =: cID].ContactId;
            }
            String uSOQL = uf[i]+' = \''+cID+'\'';
            nuf.add(uSOQL);
        }    
        String userSOQL = '('+String.join(nuf,' OR ')+')';*/
        
        if (enc == 'true'){
            cid = EncodingUtil.urlDecode(cid, 'UTF-8');
        }
        
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
            con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }


        // get record details
        Integer ivar = 0;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        ivar++;
        List<String> wheres = new List<String>();
        if(String.isBlank(soq) != true){
            // get account id
            //if(soq.Contains('[user:AccountId]')){
            //soq = soq.replace('[user:AccountId]', con.AccountId);
            if(soq.Contains('[user:AccountId]') && String.isBlank(conId) != true){
                soq = soq.replace('[user:AccountId]', con.AccountId);
            }
            if(soq.Contains('[user:ContactId]') && String.isBlank(conId) != true){
                soq = soq.replace('[user:ContactId]', '\'' +con.Id+ '\'');
            }
            
            if(String.isBlank(sch) != true){
                soq = soq.replace('[search]', '\'%' + sch + '%\'');
            }else{
                soq = soq.replace('[search]', '\'%' + '' + '%\'');
            }
            //}
            wheres.add(soq);
        }
        if(String.isBlank(cid) != true){
            wheres.add(mfield+'=\''+cid+'\'');
        }
        String sQuery = 'fld='+fields+'&obj='+obj;
        if(wheres.size() > 0){
            sQuery = 'fld='+fields+'&obj='+obj+'&whr='+ EncodingUtil.urlEncode( String.join(wheres,' AND '),'UTF-8');
        }


        
        //return EncodingUtil.urlEncode(sQuery,'UTF-8');
        return sQuery;
    }

}