({
    doInit : function(component, event, helper) {
        var compEvent = $A.get('e.FDService:SparkPlugLoadedEvent');
        compEvent.setParams({extensionPoint : component.get('v.extensionPoint')});
        compEvent.fire();
        
		let data = component.get('v.data');
        let dType = data.type.toLowerCase();
        component.set("v.amountPaid",data.total);
        console.log("type",dType);
        
        // get url
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        // get Sales Order
        var action = component.get("c.getSalesOrder");
        action.setParams({
            "orderNumber" : data.name
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var res = response.getReturnValue();
            if (state === "SUCCESS") {
                //console.log("SO Data",res);
                var eId;
                if(dType == 'receipt'){
                	var details = res.receipt[0];
                    //console.log(details);
                    eId = details.OrderApi__Encrypted_Id__c;
                }else{
					var details = res.order[0];
                    //console.log(details);
                    eId = details.OrderApi__Encrypted_Id__c;
                }
                
                var pURL = baseURL+'/s/receipt?generatePDF=true&language=en_US&id='+eId;
                var rURL = 'https://fonteva-io.herokuapp.com/generateSinglePDF/dev/?doc='+encodeURIComponent(pURL);
                console.log(rURL);
                component.set("v.receiptURL",rURL);
                
                //check if NCP
                var lines = res.lines;
                console.log("lines",lines);
                for (var key in lines) {
                        //if (dat.hasOwnProperty(key)) {
                        /*var da = new Object(); 
                        var ida = [];
                        da.id = key;
                        da.name = dat[key][1];
                        da.data = [dat[key]];
                        result.push(da);
                        //}*/
                        var itemName = lines[key].OrderApi__Item__r.Name;
                    	var itemEvent = lines[key].OrderApi__Item__r.OrderApi__Is_Event__c;
                    	console.log("key",itemName, itemEvent);
                        if(itemName.indexOf("NCP Exam") > -1 && itemEvent == true ){
                            console.log("WITH NCP");
                            component.set("v.isNCP",true);
                        }
                        
               	}
                
                
            }else{
                console.log("ERRROR Sparkplug",err);
                component.set("v.cerror", true);
                component.set("v.cerrormsg", err[0].message);
            }
        });
        $A.enqueueAction(action);
        
    }
})