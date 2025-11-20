({
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        var vRID = component.get("v.rID");
        var vRIDName = component.get("v.rIDName");
        var fname = component.get("v.flowName");
        
        // In that component, start your flow. Reference the flow's API Name.
        if((vRID != null || vRID !== 'undefined') && (vRIDName != null || vRIDName !== 'undefined')){
            var inputVariables = [
                 { name : vRIDName, type : "String", value: vRID },
            ];
            if(fname != null || fname !== 'undefined'){
                
                flow.startFlow(fname,inputVariables);
                console.log("1", inputVariables);
            }
            
        }else{
            if(fname != null || fname !== 'undefined'){
                flow.startFlow(fname);
                console.log("2");
            }
                
        }

        
        
              
    },
    handleStatusChange : function (component, event) {
        //console.log("STAT",event.getParam("status"));
        //var flow = component.find("flowData");
        //console.log("current stage",event.getParam("outputVariables"));      
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
                
        var vRID = component.get("v.rID");
        
        var fname = component.get("v.flowName");
                
        if(fname != null || fname !== 'undefined'){   
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
                
            console.log(vRID, outputVariables,"OUT");
                
            var rVar = component.get("v.redirectVar");
            var rVal = component.get("v.redirectVarVal");
            var rValName = component.get("v.redirectVarValName");
            var rPath = component.get("v.redirectPath"); 
    		
            if(outputVariables != undefined){
                for(var i = 0; i < outputVariables.length; i++) {
                    outputVar = outputVariables[i];
                    if(outputVar.name === rValName) {
                        rVal = outputVar.value;
                    }
                }
                console.log(vRID, outputVariables,"OUT",rVal);
                for(var i = 0; i < outputVariables.length; i++) {
                    outputVar = outputVariables[i];
                    if(outputVar.name === rVar && outputVar.value === true) {
                        window.location.replace(baseURL+rPath+vRID);
                        //console.log("RTEDDDD",baseURL+rPath+rVal);
                    }
                }
                      
        
                if(event.getParam("status") === "FINISHED") {
                    // Simulate an HTTP redirect:
                    window.location.replace(baseURL+"/s/#/store/checkout/"+vRID);
                    //console.log("RTEDDDD----",baseURL+rPath+rVal);
                }
    		}
    	}
    }
})