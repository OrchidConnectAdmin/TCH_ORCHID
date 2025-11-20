public class GetCYRILEntrySearchController {
   @AuraEnabled(cacheable=true)
    public static List<Contact> searchList(string searchKey) {
        string sTempSearchKey = '%' + searchKey + '%';
		
       // create contact list to store search result 
        list<Contact> lstContact = new list<Contact>();
     
	   // query contact records
        for(contact oCon : [Select id,Name,Email,FirstName,LastName,Phone
                            From Contact
                            WHERE name LIKE : sTempSearchKey]){
           lstContact.add(oCon);
        }
		
       //If there are no records found with searchKey then, throw aura exception with a message
         if(lstContact.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
         }
         
        return lstContact;
    }
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String searchString, String objectApiName, String idFieldApiName, String valueFieldApiName,String passFieldApiName, String extendedWhereClause, Integer maxRecords, String xobj, String xfield, String xmfield,String xids,String xops){
        searchString = String.escapeSingleQuotes(searchString);
        objectApiName = String.escapeSingleQuotes(objectApiName);
        idFieldApiName = String.escapeSingleQuotes(idFieldApiName);
        valueFieldApiName = String.escapeSingleQuotes(valueFieldApiName);
        passFieldApiName = String.escapeSingleQuotes(passFieldApiName);
        
        if(extendedWhereClause == null){
            extendedWhereClause = '';
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
            query = 'SELECT '+idFieldApiName+', '+passFieldApiName+' FROM '+objectApiName+' WHERE '+valueFieldApiName+' LIKE \'%'+searchString+'%\' '+extendedWhereClause+' LIMIT '+maxRecords;
        }else{
            query = 'SELECT '+idFieldApiName+', '+valueFieldApiName+', '+passFieldApiName+' FROM '+objectApiName+' WHERE '+valueFieldApiName+' LIKE \'%'+searchString+'%\' '+extendedWhereClause+' LIMIT '+maxRecords;
        }

        List<Sobject> res = Database.query(query);
            
        // Get related records
        /*String rquery;
        Map<Integer,List<SObject>> test = new Map<Integer,List<SObject>>();
        SObject rel;
        List<SObject> fin = new List<SObject>();
        if(!String.isBlank(xobj) && !String.isBlank(xfield) && !String.isBlank(xmfield) && res.size() > 0){
        	for(Integer i = 0; i < res.size(); i++){
            	
            	
                if(!String.isBlank(xids)){
                    rquery = 'Select Id,'+xfield+' from '+xobj+' where '+xfield+'=\''+String.valueOf(res[i].get(xmfield))+'\' AND '+xids+' LIMIT 1';
                }else{
                    rquery = 'Select Id,'+xfield+' from '+xobj+' where '+xfield+'=\''+String.valueOf(res[i].get(xmfield))+'\' LIMIT 1';
                }
                try{
                    rel = Database.query(rquery);
                    //fin.add(rel);
                    fin.add(res[i]);
                } catch(System.QueryException e){
                    System.debug('NO Related Data -------------------------------------------');
                    //res.remove(i);
                }               
                
            }
        }else{
            fin = res;
        }*/
        
        // FILTER RESULTS
        String rquery;
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
        }
        
		//String que = 'Select Id,OrderApi__Contact__r.Id from OrderApi__Badge__c where OrderApi__Contact__r.Id=\'0032h00000Li9i2AAB\' AND OrderApi__Badge_Type__c IN (\'a0k2h000000O2B9AAK\',\'a0k2h000000O2H5AAK\') AND OrderApi__Is_Active__c=true LIMIT 2';
        //String que = 'Select Id,OrderApi__Contact__r.Id from OrderApi__Badge__c where OrderApi__Contact__r.Id=\'0032h00000Li8d2AAB\' AND OrderApi__Badge_Type__c = \'a0k2h000000O2B9AAK\' AND OrderApi__Is_Active__c=true LIMIT 2';
        //List<Sobject> req = Database.query(que);
        //String test = 'Select Id,OrderApi__Badge_Type__c,OrderApi__Contact__c from OrderApi__Badge__c where OrderApi__Contact__r.Id=\'0032h00000Li9YfAAJ\' AND (OrderApi__Badge_Type__c=\'a0k2h000000O2B9AAK\' OR OrderApi__Badge_Type__c=\'a0k2h000000O2H5AAK\' OR OrderApi__Badge_Type__c=\'a0k2h000000O2H3AAK\') AND OrderApi__Is_Active__c=true LIMIT 2';
        //List<SObject> tst =  Database.query(test);
        return res;
        //return rquery;
    }
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        return fieldSetObj.getFields(); 
    }  
    
    public static Schema.FieldSet getFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
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