({
    searchRecords : function(component, searchString) {
        console.log("helper",searchString);
        var eAdd = component.get("v.cEnableAdd");
        var action = component.get("c.getRecords");
        action.setParams({
            "searchString" : searchString,
            "objectApiName" : component.get("v.cObj"),
            "idFieldApiName" : component.get("v.cLField"),
            "valueFieldApiName" : component.get("v.cVField"),
            "passFieldApiName" : component.get("v.cPfield"),
            "extendedWhereClause" : component.get("v.cSOQL"),
            "maxRecords" : component.get("v.maxRecords") ,
            "xobj" : component.get("v.xObj"),
            "xfield" : component.get("v.xObjField"),
            "xmfield" : component.get("v.xObjMField"),
            "xids" : component.get("v.xObjIDS"),
            "xops": component.get("v.xOperation")
        });
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log(response.getError(),"ERRROR");
            if (state === "SUCCESS") {
                const serverResult = response.getReturnValue();
                console.log(serverResult);
                const results = [];
                serverResult.forEach(element => {
                    const result = {id : element[component.get("v.cPfield")], value : element[component.get("v.cLField")]};
                    results.push(result);
                });
                component.set("v.results", results);

                if(eAdd == true){
                    component.set("v.openDropDown", true);
                }else{
                    if(serverResult.length>0){
                        component.set("v.openDropDown", true);
                    }
                }

            } else{
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