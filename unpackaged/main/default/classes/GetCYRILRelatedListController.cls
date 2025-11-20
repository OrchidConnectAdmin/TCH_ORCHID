public without sharing class GetCYRILRelatedListController {
    @AuraEnabled(cacheable=false)
    public static Map<String,List<String>> getItems(String obj, String fields, String soq, String mfield, String cid, String grp, String sch, String enc,String fpass,String dist,String dfield) {
		Map<String,List<String>> coll = new Map<String,List<String>>();
        
        //String cID = UserInfo.getUserId();
        if (enc == 'true'){
            cid = EncodingUtil.urlDecode(cid, 'UTF-8');
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
        
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
        	con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
		//sch = 'banana';

        // get record details
        
        List<String> wheres = new List<String>();
        if(String.isBlank(soq) != true){
            // get account id
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
        
        String qfields = fields;
        if(String.isBlank(fpass) != true){
            qfields = fields+','+fpass;
        }
		if(String.isBlank(dfield) != true){
            qfields = fields+','+dfield;
        }
        String sQuery = 'SELECT '+qfields+' from '+obj;
        if(wheres.size() > 0){
            sQuery = 'SELECT '+qfields+' from '+obj+' where '+ String.join(wheres,' AND ');
        }
        /*if(String.isBlank(dfield) != true){
            sQuery = sQuery + ' GROUP BY '+dfield;
        }*/

		List<SObject> rec = database.query(sQuery);
        
        Set<String> distinctSet = new Set<String>();
        
        List<String> fls = fields.split(',');
        for (Integer i = 0, j = 0; i < rec.size(); i++) {
            List<String> item = new List<String>();
            String did = String.valueOf(rec[i].get('Id'));
            if(String.isBlank(fpass) != true){
            	did = String.valueOf(rec[i].get(fpass));
            }
            if(did==null){
                did = 'item'+i;
            }
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
            if(String.isBlank(dfield) != true){
                if(distinctSet.contains(String.valueOf(rec[i].get(dfield)))){
                   //do nothing
                }else{
                   coll.put(did,item); 
                }
            }else{
                coll.put(did,item);
            }
        	
            
            if(String.isBlank(dfield) != true){
                if(String.valueOf(rec[i].get(dfield)) != null){
                    distinctSet.add(String.valueOf(rec[i].get(dfield)));
                }
            }
    	}
        
        
        return coll;
    }
    @AuraEnabled
    public static List<String> getColumns(String obj, String fields) {
		List<String> columns = new List<String>();
        
        
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
    /*@AuraEnabled
    public static List<SObject> getAccessPermission(String rid, String mfield, String ucid) {
        
        // get object
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();

        String cID = UserInfo.getUserId();
        
        // construct userfield
        if (ucid == 'true'){
            cID  = [Select ContactId from User where Id =: cID].ContactId;
        }
        


        // get record details
        String sQuery = 'SELECT '+mfield+' from '+obj+' where Id=\''+rid+'\' AND '+mfield+'=\''+cID+'\' LIMIT 1';
		List<SObject> rec = database.query(sQuery);
        
       
        
        return rec;
    }*/
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
    @AuraEnabled(cacheable=false)
    public static Boolean getDisplay(String obj, String soq,String mfield, String cid, String enc) {
		Boolean disp = true;
              
        if (enc == 'true'){
            cid = EncodingUtil.urlDecode(cid, 'UTF-8');
        }
        
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
        	con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
        
		//sch = 'banana';

        // get record details
        
        List<String> wheres = new List<String>();
        if(String.isBlank(soq) != true){
            // get account id
            //if(soq.Contains('[user:AccountId]')){
            //soq = soq.replace('[user:AccountId]', con.AccountId);

            //}
            wheres.add(soq);
        }

        String sQuery = 'SELECT Id from '+obj+' LIMIT 999';
        if(String.isBlank(cid) != true){
            wheres.add(mfield+'=\''+cid+'\'');
        }
        if(wheres.size() > 0){
            sQuery = 'SELECT Id from '+obj+' where '+ String.join(wheres,' AND ') +' LIMIT 10';
        }

		List<SObject> rec = database.query(sQuery);
        
        if(rec.size() > 0){
            disp = false;
        }
        
        
        return disp;
    }
    
}