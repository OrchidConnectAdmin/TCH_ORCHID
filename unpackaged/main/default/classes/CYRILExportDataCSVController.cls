global without sharing class CYRILExportDataCSVController {

    public List<String> columns {get;set;}
    public Map<Integer,List<String>> items {get;set;}
    public String que {get;set;}
    public Integer lastIndex {get;set;}
    public CYRILExportDataCSVController () {
        
        String fld = Apexpages.currentPage().getparameters().get('fld');
        String obj = Apexpages.currentPage().getparameters().get('obj');
        String whr = Apexpages.currentPage().getparameters().get('whr');
        String title = Apexpages.currentPage().getparameters().get('title');
        String dfield = Apexpages.currentPage().getparameters().get('dfield');
        
        //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+obj+'-'+rID+'.pdf');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+title+'.csv');
        //

        // Set Fields
        String qfields = fld;
        if(String.isBlank(dfield) != true){
            qfields = fld+','+dfield;
        }
        
        List<String> fls = fld.split(',');
        
        // Get Data
        Map<Integer,List<String>> its = new Map<Integer,List<String>>();
        String sQuery = 'SELECT '+qfields+' from '+obj;
        if(String.isBlank(whr) != true){
            sQuery = 'SELECT '+qfields+' from '+obj+' where '+ whr.replace('+', ' ');
        }
        que = sQuery;

		List<SObject> rec = database.query(sQuery);
        
        Set<String> distinctSet = new Set<String>();
        
        
        for (Integer i = 0, j = 0; i < rec.size(); i++) {
            List<String> item = new List<String>();
            String did = String.valueOf(rec[i].get('Id'));
            for (Integer x = 0; x < fls.size(); x++) {
                String v = String.valueOf( rec[i].get(fls[x]) ) != null? String.valueOf( rec[i].get(fls[x]) ): '';
            	item.add( v );
            }

            
            if(String.isBlank(dfield) != true){
                if(distinctSet.contains(String.valueOf(rec[i].get(dfield)))){
                   //do nothing
                }else{
                    its.put(i,item);
                    lastIndex = i;
                }
            }else{
                its.put(i,item);
                lastIndex = i;
            }
        	
            
            if(String.isBlank(dfield) != true){
                if(String.valueOf(rec[i].get(dfield)) != null){
                    distinctSet.add(String.valueOf(rec[i].get(dfield)));
                }
            }
            
    	}
        items = its;
        
        
        // Get Column
        List<String> cols = new List<String>();
        //List<String> fls = fld.split(',');
        for (Integer i = 0, j = 0; i < fls.size(); i++) {
            String ss = fls[i];
            if(fls[i].contains('r.')){
                ss =  fls[i].substringBefore('r.')+'c';
            }
            
            String lbl = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(ss).getDescribe().getLabel();
        	cols.add(lbl);
    	}
		columns = cols;

        
        
        
        
        
        

    }



	
}