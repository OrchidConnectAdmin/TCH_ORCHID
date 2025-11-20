({
	 fetchTableData : function(component, event, helper) {
       debugger;  
      var action = component.get("c.fetchProgProfile");    
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displaySpinner",false);
            if (state === "SUCCESS") {   
                var proff = response.getReturnValue();
                console.log("proff",proff);
                component.set("v.tableDetails",response.getReturnValue());
                component.set("v.ppfId", response.getReturnValue().progProList[0].Id);

                console.log("TABLEDETAILS",response.getReturnValue());
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
    uploadFile : function(component, file, recordId) {
        var fr = new FileReader();
        
        fr.onload = $A.getCallback(function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            
            var action = component.get("c.saveTheFile"); // Apex method
            action.setParams({
                fileName: file.name,
                base64Data: encodeURIComponent(fileContents),
                contentType: file.type,
                recordId: recordId
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.displaySpinner",false);
                    console.log("File uploaded successfully!",response.getReturnValue());

                } else {
                    alert("Error in file upload.");
                }
            });
            
            $A.enqueueAction(action);
        });
        
        fr.readAsDataURL(file);
    }
})