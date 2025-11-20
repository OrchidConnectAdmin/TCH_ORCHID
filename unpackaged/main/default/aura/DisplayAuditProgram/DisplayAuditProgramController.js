({
	doInit : function(component, event, helper) {
        component.set("v.displaySpinner",true);
        helper.fetchTableData(component, event, helper);
    },
    sessionUpload : function(component, event, helper) {
        console.log("session upload");
        var recId = event.target.name;
        console.log('my selected rec : '+ JSON.stringify(recId));
        component.set("v.uploadedFiles", []);
        component.set("v.showUploadModal",true);
		component.set("v.sessionRecordId",recId);

    },
    closenonappModal : function(component, event, helper) {
        component.set("v.showUploadModal",false);
        

    },
    submitFile : function(component, event, helper) {
		//console.log("submit files now");
        
		component.set("v.displaySpinner",true);
        var rId = component.get("v.sessionRecordId");
        console.log("submit files now",rId);
        var action = component.get("c.submitTheFiles"); 
        action.setParams({
            recordId: rId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				//component.set("v.displaySpinner",false);
                console.log("submitted files",response.getReturnValue());
                component.set("v.showUploadModal",false);
                helper.fetchTableData(component, event, helper);
				event.stopPropagation();
            } else {
                alert("Error in file upload.");
            }
        });
        
        $A.enqueueAction(action);
        //component.set("v.uploadedFiles", []);

    },
	submitAudit : function(component, event, helper) {
		//console.log("submit files now");
        
		component.set("v.displaySpinner",true);
        var rId = component.get("v.ppfId");
        console.log("submit audit now",rId);
        var action = component.get("c.submitTheAudit"); 
        action.setParams({
            recordId: rId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				//component.set("v.displaySpinner",false);
                console.log("submitted audit",response.getReturnValue());
                helper.fetchTableData(component, event, helper);
				event.stopPropagation();
            } else {
                alert("Error in file upload.");
            }
        });
        
        $A.enqueueAction(action);
        //component.set("v.uploadedFiles", []);

    },
    saveFile : function(component, event, helper) {
        component.set("v.displaySpinner",true);
        var fileInput = component.find("fileId").get("v.files");
        console.log("FILES",fileInput);
        var files = fileInput;
        var recordId = component.get("v.sessionRecordId");
        
        //var files = event.getSource().get("v.files");
    	var fileNames = [];
        for (var i = 0; i < files.length; i++) {
            //helper.readFile(component, files[i], recordId);
            helper.uploadFile(component, files[i], recordId);
            fileNames.push({
                'name' : files[i].name
            });
            console.log("file-name",files[i].name);
        }
        component.set("v.uploadedFiles", fileNames);
    },

})