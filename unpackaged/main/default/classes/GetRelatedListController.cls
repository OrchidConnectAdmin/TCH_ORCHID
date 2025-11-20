public class GetRelatedListController {
    @AuraEnabled
    public static Map<String,List<String>> getItems(String obj, String fields, String soq, String mfield, String cid, String grp) {
		Map<String,List<String>> coll = new Map<String,List<String>>();
        
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
            
        


        // get record details
        String sQuery = 'SELECT '+fields+' from '+obj+' where '+mfield+'=\''+cid+'\' LIMIT 999';
        if(String.isBlank(soq) != true){
            sQuery = 'SELECT '+fields+' from '+obj+' where '+soq+' AND '+mfield+'=\''+cid+'\' LIMIT 999';
        }
		List<SObject> rec = database.query(sQuery);
        
        List<String> fls = fields.split(',');
        for (Integer i = 0, j = 0; i < rec.size(); i++) {
            List<String> item = new List<String>();
            String did = String.valueOf(rec[i].get('Id'));
            for (Integer x = 0; x < fls.size(); x++) {
                String v = String.valueOf( rec[i].get(fls[x]) ) != null? String.valueOf( rec[i].get(fls[x]) ): 'N/A';
            	item.add( v );
            }
        	coll.put(did,item);
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
            
            String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ss).getDescribe().getLabel();
        	columns.add(lbl);
    	}
        

        return columns;
    }
    @AuraEnabled
    public static List<SObject> getAccessPermission(String rid, String mfield, String ucid) {
        
        // get object
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();

        String cID = UserInfo.getUserId();
        
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
        //String userSOQL = '('+String.join(nuf,' OR ')+')';*/
        if (ucid == 'true'){
            cID  = [Select ContactId from User where Id =: cID].ContactId;
        }
        


        // get record details
        String sQuery = 'SELECT '+mfield+' from '+obj+' where Id=\''+rid+'\' AND '+mfield+'=\''+cID+'\' LIMIT 1';
		List<SObject> rec = database.query(sQuery);
        
       
        
        return rec;
    }
}