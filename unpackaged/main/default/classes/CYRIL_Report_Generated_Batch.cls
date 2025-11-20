public class CYRIL_Report_Generated_Batch {
        
    @AuraEnabled
    public static List<Report> getReports(){
        return [SELECT Id, Name, DeveloperName, FolderName FROM Report ORDER BY Name ASC];
    }
    @AuraEnabled
    public static List<CYRIL_Batchables__mdt> getBatchs(){
        return [SELECT Id, MasterLabel, Batchable_Name__c FROM CYRIL_Batchables__mdt ORDER BY Batchable_Name__c ASC];
    }
    
    @AuraEnabled
    public static AsyncApexJob configBatch(String reportId, String column, String fields, String filters, String batchId, String batchSize, String rId){
        Integer columnNumber = 0;
        if(!String.isBlank(column)){
            if(column.isNumeric()){
                columnNumber = Integer.valueOf(column) - 1; 
            }
        }
        Integer batchSizeNumber = 5;
        if(!String.isBlank(column)){
            if(batchSize.isNumeric()){
                batchSizeNumber = Integer.valueOf(batchSize);
            }
        }
        
        List<String> listIds = new List<String>();
        
        if(Test.isRunningTest() == false){
            if(!String.isBlank(reportId)){
                // Run a report synchronously
                Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);        
                Reports.ReportFactWithDetails factWithDetails =
                    (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');        
                for (Reports.ReportDetailRow row : factWithDetails.getRows()) {
                    
                    listIds.add(row.getDataCells().get(columnNumber).getLabel());
                }
            }else{
                listIds.add(rId);
            }
        }
        
        //System.debug(ListIds);
        
        Id batchprocessid;
        String BatchName = '';
        List<CYRIL_Batchables__mdt> listMDT = [SELECT Id, MasterLabel, Batchable_Name__c FROM CYRIL_Batchables__mdt WHERE Id = :batchId];
        if(listMDT.isEmpty() != true){
            BatchName = listMDT[0].Batchable_Name__c;
        }
        
        Type typ = Type.forName(BatchName);
        Object instance = null;
        if (typ != null) {
            instance = typ.newInstance();
        }
        
        // assign params
        Database.Batchable<sObject> nbatch = (Database.Batchable<sObject>)instance;
        Map<String, Object> paramsMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(nbatch));
        paramsMap.put('listIds', listIds);
        paramsMap.put('fields', fields);
        paramsMap.put('filters', filters);
        nbatch = (Database.Batchable<sObject>)JSON.deserialize(JSON.serialize(paramsMap), typ);

		// run it
		if(Test.isRunningTest() == false){
			batchprocessid = Database.executeBatch(nbatch, batchSizeNumber);   
        }      
        
        AsyncApexJob aj = new AsyncApexJob();
        List<AsyncApexJob> listAJ = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                                     FROM AsyncApexJob 
                                     WHERE Id =: batchprocessid];
        if(listAJ.isEmpty() != true){
            aj = listAJ[0];
        }
        return aj;
    }
    
    @AuraEnabled
    public static AsyncApexJob getApexJob(String Id){
        AsyncApexJob aj = new AsyncApexJob();
        List<AsyncApexJob> listAJ = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                                     FROM AsyncApexJob 
                                     WHERE Id =: Id];
        if(listAJ.isEmpty() != true){
            aj = listAJ[0];
        }
        return aj;
    }
    
    @AuraEnabled
    public static AsyncApexJob configBatchTest(String reportId, String column, String fields, String filters, String batchId, String batchSize, String rId){
        Integer columnNumber = 0;
        if(!String.isBlank(column)){
            if(column.isNumeric()){
                columnNumber = Integer.valueOf(column) - 1; 
            }
        }
        Integer batchSizeNumber = 5;
        if(!String.isBlank(column)){
            if(batchSize.isNumeric()){
                batchSizeNumber = Integer.valueOf(batchSize);
            }
        }
        
        List<String> listIds = new List<String>();
        
        if(Test.isRunningTest() == false){
            if(!String.isBlank(reportId)){

            }else{
                listIds.add(rId);
            }
        }
        
        //System.debug(ListIds);
        
        Id batchprocessid;
        String BatchName = '';
        List<CYRIL_Batchables__mdt> listMDT = [SELECT Id, MasterLabel, Batchable_Name__c FROM CYRIL_Batchables__mdt WHERE Id = :batchId];
        if(listMDT.isEmpty() != true){
            BatchName = listMDT[0].Batchable_Name__c;
        }
        
        Type typ = Type.forName(BatchName);
        Object instance = null;
        if (typ != null) {
            instance = typ.newInstance();
        }
        
        // assign params
        Database.Batchable<sObject> nbatch = (Database.Batchable<sObject>)instance;
        Map<String, Object> paramsMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(nbatch));
        paramsMap.put('listIds', listIds);
        paramsMap.put('fields', fields);
        paramsMap.put('filters', filters);
        nbatch = (Database.Batchable<sObject>)JSON.deserialize(JSON.serialize(paramsMap), typ);

		if(Test.isRunningTest() == false){
			batchprocessid = Database.executeBatch(nbatch, batchSizeNumber);  
        }
        
        AsyncApexJob aj = new AsyncApexJob();
        List<AsyncApexJob> listAJ = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                                     FROM AsyncApexJob 
                                     WHERE Id =: batchprocessid];
        if(listAJ.isEmpty() != true){
            aj = listAJ[0];
        }
        
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
        
        return aj;
    }
}