({
    initDataTable : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.bURL", baseURL);
        
        // get id
        var getCID = component.get("v.cID");
        if(getCID.includes("[url")){
            var idParams = getCID.replace("[", "").replace("]", "").split(":");
            console.log(idParams);
            var idArr = urlString.split(idParams[1]);
            if(idParams[2] === "last"){
                var lIndex = idArr.length - 1;
                component.set("v.cID", idArr[lIndex]);
            }else{
                component.set("v.cID", idArr[idParams[2]]);
            }
            
        }
        //var idArr = urlString.split("/");
        //console.log(idArr);
        
        var numpage = component.get("v.cNumItems");
        var rID = component.get("v.cID");
        var rObj = component.get("v.cObj");
        var gCol = component.get("v.cGroupRowColumn") - 1;
        
        helper.fetchDataHelper(component, event, helper);
        /*setTimeout(function(){ 
            console.log("init datatable");
            if (gCol){
                console.log("group rows", gCol);
                jQuery('#resultTable-'+rID+rObj).DataTable( {
                    "pageLength": numpage,
                    "ordering": true,
                    "order": [[gCol, 'asc']],
                }); 
           }else{
               jQuery('#resultTable-'+rID+rObj).DataTable( {
                   "pageLength": numpage,
                    "ordering": true,
                    "order": [[0, 'asc']],
                   
               }); 
           }
            
            var uninitialized = jQuery('.should_be_datatable').filter(function() {
                return !jQuery.fn.DataTable.fnIsDataTable(this);
            });
            console.log(uninitialized);
        }, 8000);
        */
        var acc = component.get("v.cAccess");
        
        if(acc==true){var acs = component.get('c.getAccess');$A.enqueueAction(acs);}
        
    },
    initDtable: function(component, event, helper) {
        var numpage = component.get("v.cNumItems");
        var rID = component.get("v.cID");
        var rObj = component.get("v.cObj");
        var gCol = component.get("v.cGroupRowColumn") - 1;

        console.log("init datatable");
        if (gCol){
            console.log("group rows", gCol);
            jQuery('#resultTable-'+rID+rObj).DataTable( {
                "pageLength": numpage,
                "ordering": true,
                "order": [[gCol, 'asc']],
            }); 
        }else{
            jQuery('#resultTable-'+rID+rObj).DataTable( {
                "pageLength": numpage,
                "ordering": true,
                "order": [[0, 'asc']],
                
            }); 
        }
        
        var uninitialized = jQuery('#resultTable-'+rID+rObj).filter(function() {
            return !jQuery.fn.DataTable.fnIsDataTable(this);
        });
        console.log("UNINIT TABLE",uninitialized);
    },
    getAccess: function(component, event, helper) {
        // get data
        // get configs
        var crid = component.get("v.cID");
        var mfield = component.get("v.cUserMatchingField");
        var ucid = component.get("v.cUseContactId");
        
        console.log("get access");
        var action = component.get("c.getAccessPermission");
        action.setParams({
            "rid" : crid,
            "mfield": mfield,
            "ucid": ucid
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            console.log(err,"ERRROR Table Access");
            if (state === "SUCCESS") {
                console.log("ACCESS",data);
                if(data.length < 1){
                    component.set("v.cAccess",true);
                }else{
                    component.set("v.cAccess",false);
                }
                
            }else{
                console.log(err,"ERRROR Access");
            }
        });
        $A.enqueueAction(action);
    },
    
})