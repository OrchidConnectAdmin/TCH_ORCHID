({
    fetchDataHelper : function(component, event, helper) {
        
        // get configs
        var hcid = component.get("v.cID");
        var htype = component.get("v.cInvoiceType");
        
        var action = component.get("c.getItems");
        action.setParams({
            "obj" : "OrderApi__Sales_Order__c",
            "cid" : hcid,
            "gid": htype,
            "enc": 'true'
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var result = [];
            if (state === "SUCCESS") {
                var dat = response.getReturnValue();
                console.log("data",dat);
                for (var key in dat) {
                    var da = new Object(); 
                    var ida = [];
                    da.id = key;
                    da.span = dat[key]['span'];
                    delete dat[key]['span'];
                    
                    var flds = [];
                    var its = dat[key];
                    for(const [key, value] of Object.entries(its)) {
                        
                        var fld = []; 
                        fld.push(key);
                        fld.push(Number(value));
                        flds.push(fld);
                    }
                    da.data = flds;
                    
                    result.push(da);
                }
                console.log(result);

                component.set("v.items", result);                

                
            }else{
                console.log(err,"ERRROR Items");
            }
        });
        $A.enqueueAction(action);
    },

})