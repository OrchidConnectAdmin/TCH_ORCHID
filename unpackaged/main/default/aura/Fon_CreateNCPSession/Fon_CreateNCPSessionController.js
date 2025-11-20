({
    doInit : function(component, event, helper) {
        component.set("v.displaySpinner",true);
        helper.handleOnLoad(component, event, helper);
        
        // only once per render
        if (!component.get("v.initialized")) {
            helper.enforceMaxTextarea(component);
            component.set("v.initialized", true);
        }
    },
    
    /*call dateUpdate function on onchange event on date field*/ 
    dateUpdate : function(component, event, helper) {
        /**
        debugger;
        var selectedDate = component.find("sessiondate").get("v.value");
        component.set("v.disableSave",false);
        component.set("v.dateErrorMessage","");
        
        // split dates
        var dateParts = selectedDate.split('-');
        if(dateParts.length == 3){
            var d = new Date();
            var n = d.getFullYear();
            
            if(dateParts[0] == n
               || dateParts[0] == (n -1 )){
                // valid selected
            }
            else{
                //show error
                component.set("v.disableSave",true);
                component.set("v.dateErrorMessage","Select current year or last year")
            }
        }
        **/
           	
    },
    
    handleClick: function(component, event, helper) {
        //debugger;
        var sessionId = event.target.name;
        component.set("v.actionName",'edit');
        console.log('sessionId :- '+ sessionId);
        component.set("v.selectedSessionId",sessionId);
        component.set("v.displayCreateModal",true);
    },
    
    handleUpload: function(component, event, helper) {
        //debugger;
        var sessionId = event.target.name;
        component.set("v.actionName",'upload');
        console.log('sessionId :- '+ sessionId);
        component.set("v.selectedSessionId",sessionId);
        component.set("v.displayUploadModal",true);
        
        var cmpTarget = component.find('modal-upload');
        var cmpBack = component.find('modal-upload-back'); 
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop_open'); 
        
        /*const flow = component.find("flowData");
        var rID = component.get("v.selectedSessionId");
        var inputvars = [{name: "recordId", type: "String", value: sessionId}];
        flow.startFlow("NCP_SESSION_File_Upload",inputvars);*/
        
    },
    
    handleclone: function(component, event, helper) {
        debugger;
        var sessionId = event.target.name;
        component.set("v.actionName",'clone');
        console.log('sessionId :- '+ sessionId);
        component.set("v.selectedSessionId",sessionId);
        component.set("v.displayCreateModal",true);
    },
    
    openCreateSessionModal : function(component, event, helper) {
        component.set("v.displaySpinner",true);
        component.set("v.displayCreateModal",true);
        component.set("v.actionName",'new');
    },
    
    
    
    
    closeCreateSessionModal : function(component, event, helper) {
        component.set("v.displayCreateModal",false);
        component.set("v.disableSave",false);
        //component.set("v.dateErrorMessage","");
    },
    closeUploadSessionModal : function(component, event, helper) {
        component.set("v.displayUploadModal",false);
        component.set("v.disableSave",false);
        alert("File Uploaded successfully.");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File Uploaded successfully."
        });
        toastEvent.fire();
        
        // update record
        var rid = component.get("v.selectedSessionId");
        var action = component.get("c.checkUploaded");  
        action.setParams({
            "rid" : rid
        });
        console.log("check the upload", rid);
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displaySpinner",false);
            if (state === "SUCCESS") {                
				console.log("upload checked");
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        
        
    },
    closeUploadModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        var cmpTarget = component.find('modal-upload');
        var cmpBack = component.find('modal-upload-back'); 
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');        
    },
    
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        console.log("file uploaded");
        var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);

        
        // update record
        /*var rid = cmp.get("v.selectedSessionId");
        var action = cmp.get("c.checkUpload");  
        action.setParams({
            "rid" : rid
        });
        console.log("check the upload", rid);
        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.displaySpinner",false);
            if (state === "SUCCESS") {                
				console.log("upload checked");
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);*/
        
        
        
        
        
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File "+fileName+" Uploaded successfully."
        });
        toastEvent.fire();
        
        
        
        
        
        
        
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
        

        
    },
    handleFlowChange : function(component, event, helper) {

    },
    handleCreateLoad : function(component, event, helper) {
        component.set("v.displaySpinner",false);
    },
    
    handleSubmit: function(component, event, helper) {
        //debugger;
        var des = component.get("v.description");
        console.log("description",des);
        try{
            
            var sessId = component.get("v.selectedSessionId");
            component.set("v.disableSave",true);
            
            // stop the form  submitting
            event.preventDefault();  
            
            // if the use case if of update i.e. record id is present
            if(sessId){
                
                // checking if the action is clone then call clone method else update
                var actionName = component.get("v.actionName");                
                if(actionName == 'clone'){
                    var fields = event.getParam('fields');
                    
                    // setting id to null
                    fields.Id = null;                    
                    
                    // setting applciation / sales order / contact id
                    fields.Application__c = component.get("v.Applciation").Id;
                    fields.Sales_Order__c = component.get("v.SO").Id;        
                    fields.Contact__c = component.get("v.contactId");
                    fields.Account__c = component.get("v.AccountId");
                    fields.FON_Sales_Order_Line__c = null;
                    fields.Description__c = des;
                    helper.cloneRecHelper(component, event, helper, fields);
                }
                else{
                    component.find('sessionform').submit(fields);  
                }
            }else{
                var fields = event.getParam('fields');
                
                // setting applciation / sales order / contact id
                fields.Application__c = component.get("v.Applciation").Id;
                fields.Sales_Order__c = component.get("v.SO").Id;
                fields.Contact__c = component.get("v.contactId");
                fields.Account__c = component.get("v.AccountId");
                fields.Description__c = des;
                component.find('sessionform').submit(fields);
            }
            component.set("v.selectedSessionId",'');
        }
        catch(e){                
            alert(e);
        }
    },    
    
    
    handleSuccess: function(component, event, helper) {  
        debugger;
        component.set("v.disableSave",false);
        var eventrec = event.getParams();        
        component.set("v.displayCreateModal",false);
        helper.handleOnLoad(component, event, helper);
    },
    
    handleError: function(component, event) {
        component.set("v.disableSave",false);
        var error = JSON.stringify(event.getParams());
        console.log('onError: ', error);
    },
    
    createsaleodrline : function(component, event, helper) {
        debugger;
        helper.createsaleodrlineHelper(component, event, helper);
    },
    handleDescChange : function(component, event, helper) {
		var val = event.getSource().get("v.value") || "";
        var trimmed = val.length > 250 ? val.substring(0, 250) : val;
    
        event.getSource().set("v.value", trimmed);
        component.set("v.description", trimmed); // This is crucial for save
    
        component.set("v.charCount", trimmed.length);
    }
})