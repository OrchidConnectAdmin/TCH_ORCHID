({
    fetchDataHelper : function(component, event, helper) {
        
        // get configs
        var hobj = component.get("v.cObj");
        var hcid = component.get("v.cID");
        var htype = component.get("v.cInvoiceType");
        
        // get columns
        var action2 = component.get("c.getColumns");
        action2.setParams({
            "obj" : hobj,
            "cid" : hcid,
            "itype": htype,
            "enc": 'true'
        });
        action2.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            console.log("ERROR Data Column",err,response.getReturnValue());
            if (state === "SUCCESS") {
                /*var cols = [];
                var colns = response.getReturnValue();
                var fds = hfields.split(",");
                var i;
                for (i = 0; i < colns.length; i++) {
                  var labs = new Object();
                  labs.label = 
                    
                } */
                var ccols = response.getReturnValue();
 
				//console.log(response.getReturnValue().length, "COLS");
                component.set("v.columns", ccols);
                component.set("v.iLength", ccols.length);
                
            }else{
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action2);

        var action = component.get("c.getItems");
        action.setParams({
            "obj" : hobj,
            "cid" : hcid,
            "itype": htype,
            "enc": 'true'
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            //console.log(err, "ERROR Data Table");
            console.log("ERROR data",response.getReturnValue());
            var result = [];
            if (state === "SUCCESS") {
                
                var dat = response.getReturnValue();
 
                        for (var key in dat) {
                            //if (dat.hasOwnProperty(key)) {
                            var da = new Object(); 
                            var ida = [];
                            da.id = key;
                            da.data = [dat[key]];
                            
                            result.push(da);
                            //}
                        } 
 
                //console.log(gCol.length,"COL GROUP?");
                console.log("RESULTS",result);

                component.set("v.items", result);                

                
            }else{
                console.log(err,"ERRROR Items");
            }
        });
        $A.enqueueAction(action);
    },

})