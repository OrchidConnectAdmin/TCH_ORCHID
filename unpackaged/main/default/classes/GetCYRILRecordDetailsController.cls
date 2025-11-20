public without sharing class GetCYRILRecordDetailsController {
    
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
    public static String getObject(String rid) {
        
        //get current user
        List<User> ccon = [Select ContactId from User where Id =: UserInfo.getUserId()];
        String conId;
        
        if(ccon.size()>0){
            conId  = ccon[0].ContactId;
        }
		Contact con = new Contact();
        
        if(!String.isBlank(conId)){
        	con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
       
        // get object
        if(rid == '[user:AccountId]'){
            rid = con.AccountId;
        }else if(rid == '[user:ContactId]'){
            rid = con.Id;
        }
        
        // get object
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();
 
        return obj;
    }
    @AuraEnabled
    public static Map<String,Map<Integer,Map<String,String>>> getPageHeader(String rid, String c1, String c2) {
        
        //get current user
        List<User> ccon = [Select ContactId from User where Id =: UserInfo.getUserId()];
        String conId;
        
        if(ccon.size()>0){
            conId  = ccon[0].ContactId;
        }
		Contact con = new Contact();
        
        if(!String.isBlank(conId)){
        	con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
       
        // get object
        if(rid == '[user:AccountId]'){
            rid = con.AccountId;
        }else if(rid == '[user:ContactId]'){
            rid = con.Id;
        }
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();
        
        // get columns 1
        Map<String,Map<Integer,Map<String,String>>> data = new Map<String,Map<Integer,Map<String,String>>>();
        Map<Integer,Map<String,String>> c1fsets = new Map<Integer,Map<String,String>>();
        List<Schema.FieldSet> c1tfsets = new List<Schema.FieldSet>();
        List<String> c1tempfields = new List<String>();
        
        // get fieldsets
        List<String> cfs = c2.split(',');
        
        // get data
        //String qFields = String.join(c1tempfields,',');
        String sQuery = 'SELECT '+c1+' from '+obj+' where Id = \''+rid+'\' LIMIT 1';
        if(!String.isBlank(c2)){
            sQuery = 'SELECT '+c1+','+c2+' from '+obj+' where Id = \''+rid+'\' LIMIT 1';
        }
        SObject rec = database.query(sQuery);
        
        // build dat1
        Map<Integer,Map<String,String>> grp = new Map<Integer,Map<String,String>>();
        
        if(!String.isBlank(c2)){
            
            for (Integer i = 0, j = 0; i < cfs.size(); i++) {
                Map<String,String> fld = new Map<String,String>();
                
                String ssi = cfs[i];
                if(cfs[i].contains('r.')){
                    ssi =  cfs[i].substringBefore('r.')+'c';
                }
                
                String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ssi).getDescribe().getLabel();
                String hlp = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ssi).getDescribe().getInlineHelpText() != null? Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ssi).getDescribe().getInlineHelpText(): 'NULL';
                Schema.DisplayType fype = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ssi).getDescribe().getType();
                String fapi = cfs[i];
                
                fld.put('label',lbl);
                fld.put('api',fapi );
                String ans;
                if(fapi.contains('r.')){
                    String ss =  fapi.substringBefore('r.')+'c';
                    String fl =  fapi.substringBefore('.');
                    String ssa = fapi.substringAfter('r.');
                    ans = String.valueOf( rec.getSobject(fl).get(ssa) ) != null? String.valueOf( rec.getSobject(fl).get(ssa) ): 'NULL';
                }else{
                    ans = String.valueOf( rec.get( fapi ) ) != null? String.valueOf( rec.get( fapi ) ): 'NULL';
                }
                system.debug('ANSSSSS------'+ans);
                
                String fans;
                if (String.valueOf(fype) == 'MULTIPICKLIST' && ans != 'NULL'){
                    List<String> aas = String.valueOf( rec.get( fapi ) ).split(';');
                    String cans = '<ul>';
                    for(Integer x = 0; x < aas.size(); x++)
                    {
                        cans += '<li>'+aas[x]+'</li>';
                    }
                    cans += '</ul>';
                    fans = cans;   
                }else{
                    fans = ans;
                }
                fld.put('answer', fans);
                fld.put('type',String.valueOf(fype) );
                fld.put('help',hlp);
                //fld.put('help',String.valueOf( fieldSetMemberList[j].getInlineHelpText() ) );
                //String appp = objType.getDescribe().fields.get(fieldSetMemberList[j]).getDescribe().getInlineHelpText();
                // add to flist
                
                grp.put(i, fld);
            }
        }
        data.put(String.valueOf(rec.get(c1)),grp);
        return data;
    }

    @AuraEnabled
    public static Map<String,Map<Integer,Map<String,String>>> getColumnData1(String rid, String c1) {
        
        Map<Integer,Map<String,String>> fieldsets = new Map<Integer,Map<String,String>>();
        //Map<Integer,Map<Integer,Map<String,String>>> fields = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Integer,Map<Integer,Map<String,String>>> results = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Map<String,Map<Integer,Map<String,String>>> columns = new Map<Map<String,Map<Integer,Map<String,String>>>();
        
        Map<Integer,List<Schema.FieldSetMember>> tfields = new Map<Integer,List<Schema.FieldSetMember>>();
        
        List<String> tempfields = new List<String>();
        
        // get object
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();
        
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
        
        // get data
        String qFields = String.join(c1tempfields,',');
        String sQuery = 'SELECT '+qFields+' from '+obj+' where Id = \''+rid+'\' LIMIT 1';
        system.debug(sQuery);
        SObject rec = database.query(sQuery);
        
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
                String ans;
                if(fapi.contains('r.')){
                    String ss =  fapi.substringBefore('r.')+'c';
                    String fl =  fapi.substringBefore('.');
                    String ssa = fapi.substringAfter('r.');
                    
                    
                    //String sQuery2 = 'SELECT '+ssa+' FROM '+fobj+' WHERE Id= \''+fid+'\'';
                    //List<SObject> frec  = database.query(sQuery2);
                    //String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ss).getDescribe().get(ssa).getDescribe().getLabel();
                    
                    //String lbl = String.valueOf( rec.getSobject(fld).get(ssa) );
                    //String val = String.valueOf( rec.get(fls[x]) );
                    ans = String.valueOf( rec.getSobject(fl).get(ssa) ) != null? String.valueOf( rec.getSobject(fl).get(ssa) ): 'NULL';
                }else{
                    ans = String.valueOf( rec.get( fapi ) ) != null? String.valueOf( rec.get( fapi ) ): 'NULL';
                }
                system.debug('ANSSSSS------'+ans);
                
                String fans;
                if (String.valueOf( fieldSetMemberList[j].getType() ) == 'MULTIPICKLIST' && ans != 'NULL'){
                    List<String> aas = String.valueOf( rec.get( fapi ) ).split(';');
                    String cans = '<ul>';
                    for(Integer x = 0; x < aas.size(); x++)
                    {
                        cans += '<li>'+aas[x]+'</li>';
                    }
                    cans += '</ul>';
                    fans = cans;   
                }else{
                    fans = ans;
                }
                String hlp = 'NULL';
                if(!fapi.contains('r.')){
                    hlp = String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) != null? String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ): 'NULL';
                    system.debug('HELP ---------------'+String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) );
                }
                fld.put('answer', fans);
                fld.put('type',String.valueOf( fieldSetMemberList[j].getType() ) );
                fld.put('help',hlp);
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
    
    @AuraEnabled
    public static Map<String,Map<Integer,Map<String,String>>> getColumnData2(String rid, String c1) {
        
        Map<Integer,Map<String,String>> fieldsets = new Map<Integer,Map<String,String>>();
        //Map<Integer,Map<Integer,Map<String,String>>> fields = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Integer,Map<Integer,Map<String,String>>> results = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Map<String,Map<Integer,Map<String,String>>> columns = new Map<Map<String,Map<Integer,Map<String,String>>>();
        
        Map<Integer,List<Schema.FieldSetMember>> tfields = new Map<Integer,List<Schema.FieldSetMember>>();
        
        List<String> tempfields = new List<String>();
        
        // get object
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();
        
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
        
        // get data
        String qFields = String.join(c1tempfields,',');
        String sQuery = 'SELECT '+qFields+' from '+obj+' where Id = \''+rid+'\' LIMIT 1';
        system.debug(sQuery);
        SObject rec = database.query(sQuery);
        
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
                String ans;
                if(fapi.contains('r.')){
                    String ss =  fapi.substringBefore('r.')+'c';
                    String fl =  fapi.substringBefore('.');
                    String ssa = fapi.substringAfter('r.');
                    
                    
                    //String sQuery2 = 'SELECT '+ssa+' FROM '+fobj+' WHERE Id= \''+fid+'\'';
                    //List<SObject> frec  = database.query(sQuery2);
                    //String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ss).getDescribe().get(ssa).getDescribe().getLabel();
                    
                    //String lbl = String.valueOf( rec.getSobject(fld).get(ssa) );
                    //String val = String.valueOf( rec.get(fls[x]) );
                    ans = String.valueOf( rec.getSobject(fl).get(ssa) ) != null? String.valueOf( rec.getSobject(fl).get(ssa) ): 'NULL';
                }else{
                    ans = String.valueOf( rec.get( fapi ) ) != null? String.valueOf( rec.get( fapi ) ): 'NULL';
                }
                system.debug('ANSSSSS------'+ans);
                
                String fans;
                if (String.valueOf( fieldSetMemberList[j].getType() ) == 'MULTIPICKLIST' && ans != 'NULL'){
                    List<String> aas = String.valueOf( rec.get( fapi ) ).split(';');
                    String cans = '<ul>';
                    for(Integer x = 0; x < aas.size(); x++)
                    {
                        cans += '<li>'+aas[x]+'</li>';
                    }
                    cans += '</ul>';
                    fans = cans;   
                }else{
                    fans = ans;
                }
                String hlp = 'NULL';
                if(!fapi.contains('r.')){
                    hlp = String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) != null? String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ): 'NULL';
                    system.debug('HELP ---------------'+String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) );
                }
                fld.put('answer', fans);
                fld.put('type',String.valueOf( fieldSetMemberList[j].getType() ) );
                fld.put('help',hlp);
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
    
    @AuraEnabled
    public static Map<String,Map<Integer,Map<String,String>>> getColumnData3(String rid, String c1) {
        
        Map<Integer,Map<String,String>> fieldsets = new Map<Integer,Map<String,String>>();
        //Map<Integer,Map<Integer,Map<String,String>>> fields = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Integer,Map<Integer,Map<String,String>>> results = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Map<String,Map<Integer,Map<String,String>>> columns = new Map<Map<String,Map<Integer,Map<String,String>>>();
        
        Map<Integer,List<Schema.FieldSetMember>> tfields = new Map<Integer,List<Schema.FieldSetMember>>();
        
        List<String> tempfields = new List<String>();
        
        // get object
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();
        
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
        
        // get data
        String qFields = String.join(c1tempfields,',');
        String sQuery = 'SELECT '+qFields+' from '+obj+' where Id = \''+rid+'\' LIMIT 1';
        system.debug(sQuery);
        SObject rec = database.query(sQuery);
        
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
                String ans;
                if(fapi.contains('r.')){
                    String ss =  fapi.substringBefore('r.')+'c';
                    String fl =  fapi.substringBefore('.');
                    String ssa = fapi.substringAfter('r.');
                    
                    
                    //String sQuery2 = 'SELECT '+ssa+' FROM '+fobj+' WHERE Id= \''+fid+'\'';
                    //List<SObject> frec  = database.query(sQuery2);
                    //String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ss).getDescribe().get(ssa).getDescribe().getLabel();
                    
                    //String lbl = String.valueOf( rec.getSobject(fld).get(ssa) );
                    //String val = String.valueOf( rec.get(fls[x]) );
                    ans = String.valueOf( rec.getSobject(fl).get(ssa) ) != null? String.valueOf( rec.getSobject(fl).get(ssa) ): 'NULL';
                }else{
                    ans = String.valueOf( rec.get( fapi ) ) != null? String.valueOf( rec.get( fapi ) ): 'NULL';
                }
                system.debug('ANSSSSS------'+ans);
                
                String fans;
                if (String.valueOf( fieldSetMemberList[j].getType() ) == 'MULTIPICKLIST' && ans != 'NULL'){
                    List<String> aas = String.valueOf( rec.get( fapi ) ).split(';');
                    String cans = '<ul>';
                    for(Integer x = 0; x < aas.size(); x++)
                    {
                        cans += '<li>'+aas[x]+'</li>';
                    }
                    cans += '</ul>';
                    fans = cans;   
                }else{
                    fans = ans;
                }
                String hlp = 'NULL';
                if(!fapi.contains('r.')){
                    hlp = String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) != null? String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ): 'NULL';
                    system.debug('HELP ---------------'+String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) );
                }
                fld.put('answer', fans);
                fld.put('type',String.valueOf( fieldSetMemberList[j].getType() ) );
                fld.put('help',hlp);
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
    
    @AuraEnabled
    public static Map<String,Map<Integer,Map<String,String>>> getColumnData4(String rid, String c1) {
        
        Map<Integer,Map<String,String>> fieldsets = new Map<Integer,Map<String,String>>();
        //Map<Integer,Map<Integer,Map<String,String>>> fields = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Integer,Map<Integer,Map<String,String>>> results = new Map<Integer,Map<Integer,Map<String,String>>>();
        //Map<Map<String,Map<Integer,Map<String,String>>> columns = new Map<Map<String,Map<Integer,Map<String,String>>>();
        
        Map<Integer,List<Schema.FieldSetMember>> tfields = new Map<Integer,List<Schema.FieldSetMember>>();
        
        List<String> tempfields = new List<String>();
        
        // get object
        Id oid = Id.valueOf(rid);
        String obj = oid.getSObjectType().getDescribe().getName();
        Schema.SObjectType objType = oid.getSObjectType();
        
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
        
        // get data
        String qFields = String.join(c1tempfields,',');
        String sQuery = 'SELECT '+qFields+' from '+obj+' where Id = \''+rid+'\' LIMIT 1';
        system.debug(sQuery);
        SObject rec = database.query(sQuery);
        
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
                String ans;
                if(fapi.contains('r.')){
                    String ss =  fapi.substringBefore('r.')+'c';
                    String fl =  fapi.substringBefore('.');
                    String ssa = fapi.substringAfter('r.');
                    
                    
                    //String sQuery2 = 'SELECT '+ssa+' FROM '+fobj+' WHERE Id= \''+fid+'\'';
                    //List<SObject> frec  = database.query(sQuery2);
                    //String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ss).getDescribe().get(ssa).getDescribe().getLabel();
                    
                    //String lbl = String.valueOf( rec.getSobject(fld).get(ssa) );
                    //String val = String.valueOf( rec.get(fls[x]) );
                    ans = String.valueOf( rec.getSobject(fl).get(ssa) ) != null? String.valueOf( rec.getSobject(fl).get(ssa) ): 'NULL';
                }else{
                    ans = String.valueOf( rec.get( fapi ) ) != null? String.valueOf( rec.get( fapi ) ): 'NULL';
                }
                system.debug('ANSSSSS------'+ans);
                
                String fans;
                if (String.valueOf( fieldSetMemberList[j].getType() ) == 'MULTIPICKLIST' && ans != 'NULL'){
                    List<String> aas = String.valueOf( rec.get( fapi ) ).split(';');
                    String cans = '<ul>';
                    for(Integer x = 0; x < aas.size(); x++)
                    {
                        cans += '<li>'+aas[x]+'</li>';
                    }
                    cans += '</ul>';
                    fans = cans;   
                }else{
                    fans = ans;
                }
                String hlp = 'NULL';
                if(!fapi.contains('r.')){
                    hlp = String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) != null? String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ): 'NULL';
                    system.debug('HELP ---------------'+String.valueOf( fieldMap.get(fapi).getDescribe().getInlineHelpText() ) );
                }
                fld.put('answer', fans);
                fld.put('type',String.valueOf( fieldSetMemberList[j].getType() ) );
                fld.put('help',hlp);
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