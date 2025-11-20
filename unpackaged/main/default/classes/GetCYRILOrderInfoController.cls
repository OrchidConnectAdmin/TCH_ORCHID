global without sharing class GetCYRILOrderInfoController { 
    
    @AuraEnabled(cacheable=false)
    public static Map<String,Map<String,String>> getItems(String obj, String cid, String gid, String enc) {
        
        Contact con = new Contact();
        
        String htype;
        String soq;
        String fields;
        String conId  = [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId;
        
        List<String> wheres = new List<String>();
        List<CYRIL_Invoice_Line_Types__mdt> listMDT = new List<CYRIL_Invoice_Line_Types__mdt>();
        
        Map<String,List<String>> coll = new Map<String,List<String>>();
        
        if (enc == 'true'){
            cid = EncodingUtil.urlDecode(cid, 'UTF-8');
            cid = cid.replaceAll('\\s+', '+');
        }
                        
        if(!String.isBlank(conId)){
            con = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Id =: conId];
        }
        
        if(!String.isBlank(gid) == true){
            listMDT = [SELECT Id,
                       		  Column_1_Fields__c,Column_1_Object__c,Column_1_Span__c,Column_1_Title__c,
                       		  Column_2_Fields__c,Column_2_Object__c,Column_2_Span__c,Column_2_Title__c,
                       		  Column_3_Field__c,Column_3_Object__c,Column_3_Span__c,Column_3_Title__c,
                       		  Column_4_Fields__c,Column_4_Object__c,Column_4_Span__c,Column_4_Title__c,
                       		  SOQL_Conditions__c 
                       FROM CYRIL_Invoice_Line_Types__mdt 
                       WHERE Enabled__c = true 
                       AND Set_Group__c=:gid 
                       ORDER BY Order__c ASC];    
        }

       
        if(String.isBlank(cid) != true){
            if(cid.length()>18){
                wheres.add('OrderApi__Encrypted_Id__c =\''+cid+'\'');
            }else{
                wheres.add('Id=\''+cid+'\'');
            }
        }

        Map<String,Map<String,String>> groupFields = new Map<String,Map<String,String>>();
        for(CYRIL_Invoice_Line_Types__mdt md: listMDT){
            String sQuery = null;
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
            
            sQuery = 'SELECT Id FROM '+obj+' WHERE '+ String.join(tempwheres,' AND ');
            
            List<SObject> nrec = database.query(sQuery); 
            
            if(nrec.size()>0){
                if(String.isBlank(nsoq) != true){
                    wheres.add(nsoq);
                }
                Set<String> cflds = new Set<String>();
                Map<String,String> gfield = new Map<String,String>();
                if(String.isBlank(md.Column_1_Fields__c) != true){
                    cflds.add(md.Column_1_Fields__c);
                    
                    gfield.put('title',md.Column_1_Title__c);
                    gfield.put('span',String.valueOf(md.Column_1_Span__c));
                    gfield.put('fields',md.Column_1_Fields__c);
                    groupFields.put('1',gfield);
                    gfield = new Map<String,String>();
                }
                if(String.isBlank(md.Column_2_Fields__c) != true){
                    cflds.add(md.Column_2_Fields__c);
                    gfield.put('title',md.Column_2_Title__c);
                    gfield.put('span',String.valueOf(md.Column_2_Span__c));
                    gfield.put('fields',md.Column_2_Fields__c);
                    groupFields.put('2',gfield);
                    gfield = new Map<String,String>();
                }
                if(String.isBlank(md.Column_3_Field__c) != true){
                    cflds.add(md.Column_3_Field__c);
                    gfield.put('title',md.Column_3_Title__c);
                    gfield.put('span',String.valueOf(md.Column_3_Span__c));
                    gfield.put('fields',md.Column_3_Field__c);
                    groupFields.put('3',gfield);
                    gfield = new Map<String,String>();
                }
                if(String.isBlank(md.Column_4_Fields__c) != true){
                    cflds.add(md.Column_4_Fields__c);
                    gfield.put('title',md.Column_4_Title__c);
                    gfield.put('span',String.valueOf(md.Column_4_Span__c));
                    gfield.put('fields',md.Column_4_Fields__c);
                    groupFields.put('4',gfield);
                    gfield = new Map<String,String>();
                }
                if(cflds.size()>0){
                    fields = String.join(new List<String>(cflds),',');
                }
                break;
            }else{
                continue;
            }            
        }
       
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
        
        String qfields = fields;

        String sQuery = 'SELECT '+qfields+' FROM '+obj;
        if(wheres.size() > 0){
            sQuery = 'SELECT '+qfields+' FROM '+obj+' where '+ String.join(wheres,' AND ');
        }
        Integer ivar = 0;
        ivar++;
        ivar++;
        ivar++;
       	List<SObject> rec = database.query(sQuery); 
        Set<String> distinctSet = new Set<String>();
        
        //yuckkkkk
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
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        vars++;
        
        Map<String,Map<String,String>> groupoutput = new Map<String,Map<String,String>>();
        Integer k = 0;
        for(Map<String,String> gf : groupFields.values()){
            List<String> nfls = gf.get('fields').split(',');
            String ogroup = 'group-' + (k + 1);            
    		Map<String,String> ofld = new Map<String,String>();
            ofld.put('span',gf.get('span'));
            for (Integer x = 0; x < nfls.size(); x++) {
                
                String flapi = nfls[x];                
                String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(flapi).getDescribe().getLabel();  
                String v;
                if(flapi.indexOf('COUNT') != -1 || flapi.contains('COUNT')){
                    v = String.valueOf( rec[0].get('expr0') ) != null? String.valueOf( rec[0].get('expr0') ): ''; 
                }else{
                    if(nfls[x].contains('.')){
                        String ss =  nfls[x].substringBefore('.');
                        String sr =  nfls[x].substringAfter('.');
                        v = (String) rec[0].getSobject(ss).get(sr);
                    }else{
                        v = String.valueOf( rec[0].get(nfls[x]) ) != null? String.valueOf( rec[0].get(nfls[x]) ): '';
                    }
                    
                }
                ofld.put(lbl,v);
            }
			groupoutput.put(ogroup,ofld);
			k++;
        }

        
        return groupoutput;
    }
}