/**=====================================================================
* Name: MetadataService_Test
* Description: Test class for MetadataService class
* Created Date: [09/25/2019]
* Created By: Abhishek Pratik
* 
* Date Modified                Modified By                  Description of the update
* [MON DD, YYYY]               [FirstName LastName]         [Short description for changes]
=====================================================================*/
@isTest
public with sharing class MetadataService_Test {
    
    static testMethod void testupdate() {   
        
		
		MetadataService MetadataServices = new MetadataService();
		
		
        MetadataService.RemoteSiteSetting RemoteSiteSettings = new MetadataService.RemoteSiteSetting();
		
        MetadataService.createResponse_element createResponse_elements = new MetadataService.createResponse_element();
        MetadataService.AsyncResult AsyncResults = new MetadataService.AsyncResult();
        MetadataService.checkStatus_element checkStatus_elements = new MetadataService.checkStatus_element();
        MetadataService.checkStatusResponse_element checkStatusResponse_elements = new MetadataService.checkStatusResponse_element();
        MetadataService.PackageTypeMembers PackageTypeMemberss = new MetadataService.PackageTypeMembers();
        MetadataService.DebuggingHeader_element DebuggingHeader_elements = new MetadataService.DebuggingHeader_element();
        MetadataService.LogInfo LogInfos = new MetadataService.LogInfo();
        MetadataService.Metadata Metadatas = new MetadataService.Metadata();
        MetadataService.SessionHeader_element SessionHeader_elements = new MetadataService.SessionHeader_element();
        MetadataService.retrieveResponse_element retrieveResponse_elements = new MetadataService.retrieveResponse_element();
        MetadataService.DebuggingInfo_element DebuggingInfo_elements = new MetadataService.DebuggingInfo_element();
        MetadataService.CallOptions_element CallOptions_elements = new MetadataService.CallOptions_element();
        MetadataService.checkDeployStatus_element checkDeployStatus_elements = new MetadataService.checkDeployStatus_element();
		checkDeployStatus_elements.asyncProcessId = 'test';
        MetadataService.create_element create_elements = new MetadataService.create_element();		
		
			MetadataService.MetadataPort MetadataPorts = new MetadataService.MetadataPort();
		try{MetadataPorts.checkStatus(new List<string>{'test'});}catch (Exception e) { }
		try{MetadataPorts.create(new list<MetadataService.Metadata> {Metadatas});}catch (Exception e) { }
        
    }
}