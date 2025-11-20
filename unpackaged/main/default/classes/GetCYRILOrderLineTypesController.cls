global without sharing class GetCYRILOrderLineTypesController extends VisualEditor.DynamicPickList {
   global override VisualEditor.DataRow getDefaultValue(){
       VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Select Order Line Type Set', '');
       return defaultValue;
   }
   global override VisualEditor.DynamicPickListRows getValues() {
       List<CYRIL_Invoice_Line_Types__mdt> listMDT = [SELECT Id, MasterLabel FROM CYRIL_Invoice_Line_Types__mdt WHERE Type__c='Order Lines' AND Enabled__c=true ORDER BY Order__c];      
       
       VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();
       VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Automatic', 'auto');
       myValues.addRow(defaultValue);
       
       for(CYRIL_Invoice_Line_Types__mdt mdt : listMDT){
           VisualEditor.DataRow opt = new VisualEditor.DataRow(mdt.MasterLabel, '' + mdt.Id);
           myValues.addRow(opt);
       }
       return myValues;
   }
}