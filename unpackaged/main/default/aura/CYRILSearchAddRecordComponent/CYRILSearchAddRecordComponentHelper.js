({
    searchRecords : function(component, searchString) {
        
        var eAdd = component.get("v.cEnableAdd");
        var eForm = component.get("v.cEnableAddForm");
        var sfilter = component.get("v.cValidationSOQL");
        var sfield = component.get("v.cValidationFields");
        var smessage = component.get("v.cValidationMsg");
        var svalidate = component.get("v.cEnableResultValidator");
        console.log("helper",searchString);
        
        var soqlD = decodeURIComponent(component.get("v.cSOQL"));
        console.log("decoded",soqlD);
        
        var action = component.get("c.getRecords");
        action.setParams({
            "searchString" : searchString,
            "objectApiName" : component.get("v.cObj"),
            "idFieldApiName" : component.get("v.cLField"),
            "valueFieldApiName" : component.get("v.cVField"),
            "passFieldApiName" : component.get("v.cPfield"),
            "extendedWhereClause" : decodeURIComponent(component.get("v.cSOQL")),
            "maxRecords" : component.get("v.cResultLimit"),
            "xobj" : component.get("v.xObj"),
            "xfield" : component.get("v.xObjField"),
            "xmfield" : component.get("v.xObjMField"),
            "xids" : component.get("v.xObjIDS"),
            "xops": component.get("v.xOperation"),
            "vfilter": sfilter,
            "vfield": sfield,
            "vmsg": smessage
        });
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log(response.getError(),"ERRROR");
            if (state === "SUCCESS") {
                const serverResult = response.getReturnValue();
                console.log("results",serverResult,serverResult.length);
                var fres = serverResult;
                // sanitize results first
                
                if(svalidate==true){
				fres = [];
// Splitting vkeys into an array of keys
var keys = sfield.split(',');
var vals = sfilter.split(',');
console.log("filters",fres,keys,vals);
// Iterating over the data array
for (var i = 0; i < serverResult.length; i++) {
  var isFailed = '';
  for (var j = 0; j < keys.length; j++) {
    var key = keys[j];
    var val = vals[j];
      
    // Accessing and logging the value associated with the key in the current object
    var cval = serverResult[i][key];
      console.log("key vals",key,val,cval);
      if(val == "!null"){
          console.log("is null",key,val,cval);
          if(typeof cval !== 'undefined'){
              isFailed = isFailed + 'false';
          }else{
              isFailed = isFailed + 'true';
          }
      }else if(val !== cval){
          isFailed = isFailed + 'false';
      }else{
          isFailed = isFailed + 'true';
      }
      console.log("FIELD VALIDATION ------ ",isFailed);
  }
    console.log("DATA VALIDAtION -------------------------- ",isFailed,isFailed.includes("false"));
    if(isFailed.includes("false")){
        fres.push(serverResult[i]);
    }
    
}
                }
                
                console.log("FNAL",fres,serverResult);
                
                const results = [];
                fres.forEach(element => {
                    const result = {id : element[component.get("v.cPfield")], value : element[component.get("v.cLField")]};
                    results.push(result);
                });
                component.set("v.results", results);
component.set("v.cloading", false);
                if(eAdd == true || eForm){
                    component.set("v.openDropDown", true);
                }else{
                    if(fres.length>0){
                        component.set("v.openDropDown", true);
                    }
                }
            
                if(fres.length == 0 && serverResult.length == 0){
                    component.set("v.openDropDown", true);
                    component.set("v.isResultEmpty", true);
            		component.set("v.cValidationFailed", false);
        		}else if(fres.length == 0 && serverResult.length > 0){
                    component.set("v.openDropDown", true);
                    component.set("v.isResultEmpty", true);
                    component.set("v.cValidationFailed", true);
                }

            } else{
                           component.set("v.cloading", false);
                var toastEvent = $A.get("e.force:showToast");
                if(toastEvent){
                    toastEvent.setParams({
                        "title": "ERROR",
                        "type": "error",
                        "message": "Something went wrong!! Check server logs!!"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})