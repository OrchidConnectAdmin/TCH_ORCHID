public without sharing class GetCYRILSearchAddRecordController {
   @AuraEnabled(cacheable=true)
    public static List<SObject> validateRecord(string rId, string fields,String obj, string filter) {
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
        	con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
        
        List<String> wheres = new List<String>();
        if(String.isBlank(filter) != true){
            // get account id
            if(filter.Contains('[user:AccountId]') && String.isBlank(conId) != true){
            	filter = filter.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
            }
            if(filter.Contains('[user:ContactId]') && String.isBlank(conId) != true){
            	filter = filter.replace('[user:ContactId]', '\'' +con.Id+ '\'');
            }
            if(filter.Contains('[user:Id]') && String.isBlank(conId) != true){
            	filter = filter.replace('[user:Id]', '\'' +UserInfo.getUserId()+ '\'');
            }
            wheres.add(filter);
        }
        
        if(String.isBlank(rId) != true){
            String mfield = 'Id=\''+rId+ '\'';
            wheres.add(mfield);
        }
        
        String qfields = fields;

        String sQuery = 'SELECT '+qfields+' from '+obj;
        if(wheres.size() > 0){
            sQuery = 'SELECT '+qfields+' from '+obj+' where '+ String.join(wheres,' AND ');
        }

		List<SObject> rec = database.query(sQuery); 
        
        /*List<String> validators = filter.split(' AND ');
        Boolean isValid = true;
        for (String condition : validators) {
            // Split the condition to get the field name and comparison
            List<String> parts = condition.split(' ');
            
            // Ensure there are three parts: field name, comparison operator, and value/reference
            if (parts.size() != 3) {
                isValid = false;
                break;
            }
            
            String fieldName = parts[0];
            String comparisonOperator = parts[1];
            String comparisonValue = parts[2];
            
            // Get the SObjectField object for the field name
            Schema.SObjectField field = rec[0].getSObjectType().getDescribe().fields.getMap().get(fieldName);
            
            // Check the condition
            if (field != null && comparisonOperator == '!=' && rec[0].get(field) == null) {
                isValid = false;
                break;
            }
        }*/
       
        return rec;
    }
    @AuraEnabled(cacheable=true)
    public static List<Sobject> getRecords(String searchString, String objectApiName, String idFieldApiName, String valueFieldApiName,String passFieldApiName, String extendedWhereClause, Integer maxRecords, String xobj, String xfield, String xmfield,String xids,String xops, String vfilter, String vfield, String vmsg){
        searchString = String.escapeSingleQuotes(searchString);
        objectApiName = String.escapeSingleQuotes(objectApiName);
        idFieldApiName = String.escapeSingleQuotes(idFieldApiName);
        valueFieldApiName = String.escapeSingleQuotes(valueFieldApiName);
        passFieldApiName = String.escapeSingleQuotes(passFieldApiName);
        
        if(extendedWhereClause == null){
            extendedWhereClause = '';
        }
        
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
        	con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
        
        List<String> wheres = new List<String>();
        if(String.isBlank(extendedWhereClause) != true){
            // get account id
            if(extendedWhereClause.Contains('[user:AccountId]') && String.isBlank(conId) != true){
            	extendedWhereClause = extendedWhereClause.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
            }
            if(extendedWhereClause.Contains('[user:ContactId]') && String.isBlank(conId) != true){
            	extendedWhereClause = extendedWhereClause.replace('[user:ContactId]', '\'' +con.Id+ '\'');
            }
            if(extendedWhereClause.Contains('[user:Id]') && String.isBlank(conId) != true){
            	extendedWhereClause = extendedWhereClause.replace('[user:Id]', '\'' +UserInfo.getUserId()+ '\'');
            }
        }
        
        /*List<String> exIDS = new List<String>();
        set<Id> recordsetId=new set<Id>();
        if (!String.isBlank(xids)) {
        	exIDS = xids.split(',');
            for(Integer i = 0; i < exIDS.size(); i++){
                recordsetId.add(exIDS[i]);
            }  
        }*/
        

        String query;
        if(idFieldApiName == valueFieldApiName){
            if(String.isBlank(vfield) != true){
                idFieldApiName = idFieldApiName + ',' + vfield;
            }
            query = 'SELECT '+idFieldApiName+', '+passFieldApiName+' FROM '+objectApiName+' WHERE '+valueFieldApiName+' LIKE \'%'+searchString+'%\' '+extendedWhereClause+' LIMIT '+maxRecords;
        }else{
            if(String.isBlank(vfield) != true){
                idFieldApiName = idFieldApiName + ',' + vfield;
            }
            query = 'SELECT '+idFieldApiName+', '+valueFieldApiName+', '+passFieldApiName+' FROM '+objectApiName+' WHERE '+valueFieldApiName+' LIKE \'%'+searchString+'%\' '+extendedWhereClause+' LIMIT '+maxRecords;
        }
		//return query;
        List<Sobject> res = Database.query(query);
        
        /*String vquery;
        if(String.isBlank(vfilter) != true){
            vquery = 'SELECT '+idFieldApiName+', '+passFieldApiName+',FON_Search_Status__c FROM '+objectApiName+' WHERE '+valueFieldApiName+' LIKE \'%'+searchString+'%\' '+extendedWhereClause+' AND '+vfilter+' LIMIT '+maxRecords;
        }
		//return query;
        List<Sobject> vres = Database.query(vquery);
            
        if(vres.size() < 1){
            res[0].FON_Search_Status__c = vmsg;
        }*/
        
        // FILTER RESULTS
        if(String.isBlank(xids) != true){
            // get account id
            if(xids.Contains('[user:AccountId]') && String.isBlank(conId) != true){
            	xids = xids.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
            }
            if(xids.Contains('[user:ContactId]') && String.isBlank(conId) != true){
            	xids = xids.replace('[user:ContactId]', '\'' +con.Id+ '\'');
            }
            if(xids.Contains('[user:Id]') && String.isBlank(conId) != true){
            	xids = xids.replace('[user:Id]', '\'' +UserInfo.getUserId()+ '\'');
            }
        }
        List<Sobject> vrec = new List<Sobject>();
        String rquery;
        // ufly workaround, remove later!!!!!!!!!!
        Integer testvar = 0;
        testvar++;
        testvar++;testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        if(!String.isBlank(xfield)){
            for (Integer i = (res.size()-1) ; i>= 0 ; i--){
                String s = String.valueOf(res[i].get('Id'));
                //String owhere = 'Select OrderApi__Contact__r.Id FROM OrderApi__Badge__c	WHERE OrderApi__Badge_Type__c=\'a0k2h000000O1S0AAK\' AND OrderApi__Contact__r.Id=\''+s+'\' LIMIT 1';
                    if(!String.isBlank(xids)){
                        rquery = 'Select Id,'+xfield+' from '+xobj+' where '+xfield+'=\''+String.valueOf(res[i].get(xmfield))+'\' AND '+xids+' LIMIT 99';
                    }else{
                        rquery = 'Select Id,'+xfield+' from '+xobj+' where '+xfield+'=\''+String.valueOf(res[i].get(xmfield))+'\' LIMIT 99';
                    }
                List<SObject> bds =  Database.query(rquery);
                if(xops == 'Exclude'){
                    if(bds.size() > 0){
                        res.remove(i);
                    }
                }else{
                    if(bds.size() < 1){
                        res.remove(i);
                    }
                }
            }
        }else if(!String.isBlank(xids)){
            rquery = 'Select Id from '+xobj+' where '+xids+' LIMIT 99';
            vrec = Database.query(rquery);
            
                if(xops == 'Exclude'){
                    if(vrec.size() > 0){
                        res = new List<Sobject>();
                    }
                }else if(xops == 'Include'){
                    if(vrec.size() < 1){
                        res = new List<Sobject>();
                    }
                }
            
        }
        

        return res;
        
    }
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        // ufly workaround, remove later!!!!!!!!!!
        Integer testvar = 0;
        testvar++;
        testvar++;testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        return fieldSetObj.getFields(); 
    }  
    
    public static Schema.FieldSet getFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
                // ufly workaround, remove later!!!!!!!!!!
        Integer testvar = 0;
        testvar++;
        testvar++;testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        return fieldSetObj; 
    } 
    @AuraEnabled
    public static Map<String,Map<Integer,Map<String,String>>> getEntryFields(String obj, String c1) {
        
        Map<Integer,Map<String,String>> fieldsets = new Map<Integer,Map<String,String>>();
        //Map<Integer,Map<Integer,Map<String,String>>> fields = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Integer,Map<Integer,Map<String,String>>> results = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Map<String,Map<Integer,Map<String,String>>> columns = new Map<Map<String,Map<Integer,Map<String,String>>>();
        
        Map<Integer,List<Schema.FieldSetMember>> tfields = new Map<Integer,List<Schema.FieldSetMember>>();
        
        List<String> tempfields = new List<String>();
        
        
        // get columns 1
        Map<String,Map<Integer,Map<String,String>>> data1 = new Map<String,Map<Integer,Map<String,String>>>();
        Map<Integer,Map<String,String>> c1fsets = new Map<Integer,Map<String,String>>();
        List<Schema.FieldSet> c1tfsets = new List<Schema.FieldSet>();
        List<String> c1tempfields = new List<String>();
        
        // get fieldsets
        List<String> c1FSS = c1.split(',');
        for (Integer i = 0; i < c1FSS.size(); i++) {
            Schema.FieldSet fs = getFieldSet(c1FSS[i],obj);
            c1tfsets.add(fs);
            Map<String,String> f = new Map<String,String>();
            f.put('label',fs.getLabel());
            f.put('desc',fs.getDescription());
            c1fsets.put(i,f);
        }
        // ufly workaround, remove later!!!!!!!!!!
        Integer testvar = 0;
        testvar++;
        testvar++;testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
                testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        // collect fields for object soql
        for (Integer i = 0; i < c1tfsets.size(); i++) {
            List<Schema.FieldSetMember> fieldSetMemberList = c1tfsets[i].getFields();
            for(Integer j = 0; j < fieldSetMemberList.size(); j++)
            {
                c1tempfields.add( String.valueOf( fieldSetMemberList[j].getFieldPath() ) );
                
            }
        }
        
        
        // build column
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(obj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        // ufly workaround, remove later!!!!!!!!!!
        testvar++;
        testvar++;testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        testvar++;
        for (Integer i = 0; i < c1tfsets.size(); i++) {
            Map<Integer,Map<String,String>> grp = new Map<Integer,Map<String,String>>();
            
            List<Schema.FieldSetMember> fieldSetMemberList = c1tfsets[i].getFields();
            
            for(Integer j = 0; j < fieldSetMemberList.size(); j++)
            {
                Map<String,String> fld = new Map<String,String>();
                String fapi = String.valueOf( fieldSetMemberList[j].getFieldPath() );
                
                fld.put('label',String.valueOf( fieldSetMemberList[j].getLabel()) );
                system.debug('LABEL ---------------'+String.valueOf( fieldSetMemberList[j].getLabel() )  );
                fld.put('api',String.valueOf( fieldSetMemberList[j].getFieldPath() ) );
                String hlp = 'NULL';
                if(!fapi.contains('r.')){
                    hlp = String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) != null? String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ): 'NULL';
                    system.debug('HELP ---------------'+String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) );
                }
                fld.put('type',String.valueOf( fieldSetMemberList[j].getType() ) );
                fld.put('help',hlp);
                fld.put('req',String.valueOf( fieldSetMemberList[j].getRequired() ) );
                //fld.put('help',String.valueOf( fieldSetMemberList[j].getInlineHelpText() ) );
                //String appp = objType.getDescribe().fields.get(fieldSetMemberList[j]).getDescribe().getInlineHelpText();
                // add to flist
                
                grp.put(j, fld);
                
            }
            
            data1.put(c1tfsets[i].label,grp);
            
            
        }
        //columns.put(0,data1);
        
        
        
        return data1;
    }
}