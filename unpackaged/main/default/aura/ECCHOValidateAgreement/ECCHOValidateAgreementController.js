({
	doInit : function(component, event, helper) {
		var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        
        var flow = component.find("flowData");
        var vRID = component.get("v.rID");
        
        // In that component, start your flow. Reference the flow's API Name.
        if(vRID != null || vRID !== 'undefined'){
            var inputVariables = [
                 { name : "rID", type : "String", value: vRID },
            ];
                
            flow.startFlow('Screenflow_Verify_Access_to_Agreement',inputVariables);
            console.log("1", inputVariables);
            
        }
        
        
        
	},
    handleStatusChange : function (component, event) {
     
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
                
        var vRID = component.get("v.rID");
                
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
               
                console.log(outputVariables);
            if(outputVariables != undefined){
                for(var i = 0; i < outputVariables.length; i++) {
                    outputVar = outputVariables[i];
                    if(outputVar.name === 'isCompleted' && outputVar.value === 'Yes') {
                        window.location.replace(baseURL);
                        //console.log("RTEDDDD",baseURL+rPath+rVal);
                    }else if(outputVar.name === 'isCompleted' && outputVar.value === null) {
                        console.log("is null");
                        component.set("v.coverMe", false);
                    }
                }

    		}
    }
})