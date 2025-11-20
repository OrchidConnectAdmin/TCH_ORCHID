public class Fon_EditFormController {

    @AuraEnabled 
    public static RecordIdWithFields retrieveFields(String fieldsetName
                                                    , String ObjectName
                                                    , String apiLookupFieldName
                                                    , String currentRecordId
                                                    , boolean isRecordFound) {
                                                    system.debug('in frst isRecordFound = ' + isRecordFound);
                                                    system.debug('in currentRecordId = ' + currentRecordId);
        return getFieldSet(fieldsetName
                            , ObjectName
                            , apiLookupFieldName
                            , currentRecordId
                            , isRecordFound);
    }
    
    private static RecordIdWithFields getFieldSet(String fieldSetName
                                                    , String ObjectName
                                                    , String relatedField
                                                    , String recId
                                                    , boolean isRecordFound) {
        List<FieldWrapper> lstfieldWrapper = new List<FieldWrapper>();
        String objN = 'OrderApi__Sales_Order__c';
        if (String.isNotBlank(fieldSetName) && String.isNotBlank(objN)) {
            Schema.DescribeSObjectResult describeSObjectResult = Schema.getGlobalDescribe().get(objN).getDescribe();
            Map<String,Schema.SObjectField> objFieldMap = describeSObjectResult.fields.getMap();
            Schema.FieldSet fieldSetObj = describeSObjectResult.FieldSets.getMap().get(fieldSetName);
            if (fieldSetObj != null) {
                for(Schema.FieldSetMember fieldSet : fieldSetObj.getFields() ) {
                    lstfieldWrapper.add( new FieldWrapper(
                        String.ValueOf(fieldSet.getLabel()),
                        String.ValueOf(fieldSet.getFieldPath()), 
                        (fieldSet.getDBRequired() || fieldSet.getRequired()),
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().getInlineHelpText(),
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().isHtmlFormatted() &&
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().isCalculated()
                    ));
                }
            }
        }
        String recordSOQL = '';
        system.debug('record found = ' + isRecordFound);
        if(isRecordFound){
            recordSOQL = 'Select ' + relatedField +' From ' + ObjectName + ' Where id  =: recId';
        }else{
        recordSOQL = 'Select ' + relatedField +' From ' + ObjectName + ' Where OrderApi__Encrypted_Id__c  =: recId';
        }
        system.debug('sql = ' + recordSOQL);
        List<sObject> allRecords = Database.query(recordSOQL);
        String soRecordId = (string)allRecords[0].get(relatedField);
        RecordIdWithFields recordFields = new RecordIdWithFields(soRecordId, lstfieldWrapper);
        
        return recordFields; 
    }
    
    public class RecordIdWithFields{
        @AuraEnabled public String sfRecordId {get;set;}
        @AuraEnabled  public  List<FieldWrapper> allFields {get;set;}
        
        public RecordIdWithFields(String myRecordId, List<FieldWrapper> fieldsWrap){
            this.sfRecordId = myRecordId;
            this.allFields = fieldsWrap;
        }
    }
    
    public class FieldWrapper {
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldLabel {get;set;}
        @AuraEnabled public Boolean isRequired {get;set;}
        @AuraEnabled public String helpText {get;set;}
        @AuraEnabled public Boolean isHtmlFormatted {get;set;}
        
        public FieldWrapper(String fieldLabel,String fieldName,Boolean isRequired, String helpText, Boolean isHtmlFormatted ) {
            this.fieldLabel  = fieldLabel;
            this.fieldName   = fieldName;
            this.isRequired  = isRequired;
            this.helpText    = helpText;
            this.isHtmlFormatted = isHtmlFormatted;
        }
    }
}