({
    initDataTable : function(component, event, helper) {
         console.log("is this initiating?");
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.bURL", baseURL);
        component.set("v.schString", component.get("v.cSearchStringSource"));
       	//console.log("SEARCHME",component.get("v.schString"));
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
        console.log("SEARCHME",component.get("v.cID"));
        
        var rsoq = component.get("v.rSoql");
        if(rsoq.length > 0){var dis = component.get('c.checkDisplay');$A.enqueueAction(dis);}
        
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
        var gCol = component.get("v.cGroupRowColumn");
        var hScroll = component.get("v.cEnableHScroll");
        

        var rUID = component.get("v.cUID");
        var showAll = component.get("v.cDisablePagination");
        var paging = true;
        if(showAll == true){
            paging = false;
        }
       

        console.log("init datatable");
        component.set("v.cIDTemp",rID.replace(/[^a-z0-9\s]/gi, ''));
        var rIDT = component.get("v.cIDTemp");
        
            console.log('#resultTable-',numpage);
            setTimeout(function(){ 
                console.log("initialize this");
                if (gCol){
                    console.log("group rows", gCol);
                    //jQuery('#resultTable-'+rIDT+rObj+rUID).DataTable();
                    gCol = gCol - 1;
                    jQuery('#resultTable-'+rIDT+rObj+rUID).DataTable({
                        /*"pageLength": parseInt(numpage),
                        "ordering": true,
                        "order": [[gCol, 'asc']],
                        "paging": paging*/
                        pageLength: parseInt(numpage),
                        filter: true,
                        deferRender: true,
                        ordering: true,
                        order: [[gCol, 'asc']],
                        "scrollX": hScroll,
                    }); 
               }else{
                   jQuery('#resultTable-'+rIDT+rObj+rUID).DataTable( {
                       /*"pageLength": parseInt(numpage),
                        "ordering": true,
                        "order": [[0, 'asc']],
                       "paging": paging*/
                        pageLength: parseInt(numpage),
                        filter: true,
                        deferRender: true,
                        ordering: true,
                        order: [[0, 'asc']],
                       	paging: paging,
                       "scrollX": hScroll
                       	// buttons
                        /*dom: 'Bfrtip',
                       	
                        buttons: [
                            'excelHtml5',
                            'csvHtml5'
                        ]*/
                   }); 
               }
                if ( ! jQuery.fn.DataTable.isDataTable( '#resultTable-'+rID+rObj+rUID ) ) {
                  //jQuery('#resultTable-'+rID+rObj+rUID).dataTable();
                    console.log("not table");
                }
                
                /*var uninitialized = jQuery('.cdtable').filter(function() {
                    return !jQuery.fn.DataTable.fnIsDataTable(this);
                });
                console.log("UNINIT",uninitialized);*/
            }, 2000);
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
    exportCSV: function(component, event, helper) {
        // get configs
        var hobj = component.get("v.cObj");
        var hfields = component.get("v.cFields");
        var hsoql = component.get("v.cSoql");
        var humf = component.get("v.cMField");
        var hcid = component.get("v.cID");
        var hDT = component.get("v.cDType");
        var gCol = component.get("v.cGroupRowColumn");
        var calcol = component.get("v.cCalCol");
        var calmet = component.get("v.cCalMethod");
        var title = component.get("v.cTitle");
        var searchString = component.get("v.schString");
        var dist = component.get("v.cDistinct");
        var dfield = component.get("v.cDistinctField");
        
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        var action = component.get("c.getQuery");
        action.setParams({
            "obj" : hobj,
            "fields": hfields,
            "soq": hsoql,
            "mfield": humf,
            "cid": hcid,
            "grp": gCol,
            "sch":searchString
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            //console.log(err, "ERROR Data Table");
            console.log(response.getReturnValue(),"QUERY");
            var result = [];
            if (state === "SUCCESS") {
                
                //component.set("v.cloading", false);
                //window.location = baseURL + '/apex/CYRILExportDataCSV?title='title+'&'+response.getReturnValue();
                if(dist==true || dist == 'true'){
                    window.open(baseURL + '/apex/CYRILExportDataCSV?title='+title+'&dfield='+dfield+'&'+response.getReturnValue());
                }else{
                    window.open(baseURL + '/apex/CYRILExportDataCSV?title='+title+'&'+response.getReturnValue());
                }
				 
            }else{
                component.set("v.cloading", false);
                component.set("v.cerror", true);
                component.set("v.cerrormsg", err[0].message);
                console.log(err,"ERRROR Items");
            }
        });
        $A.enqueueAction(action);
    },
    
    searchHandler : function (component, event, helper) {
        const searchString = event.target.value;
        
        console.log("SEARCH ME",searchString);
        
        if (searchString.length >= 3) {
            //Ensure that not many function execution happens if user keeps typing
            if (component.get("v.inputSearchFunction")) {
                clearTimeout(component.get("v.inputSearchFunction"));
            }
			component.set("v.cloading", true);
            var inputTimer = setTimeout($A.getCallback(function () {
                helper.searchRecords(component, searchString);
            }), 1000);
            component.set("v.inputSearchFunction", inputTimer);
        } else{
            //component.set("v.items", []);

        }
    },
    
    checkDisplay : function (component, event, helper) {
        var hobj = component.get("v.cObj");
        var hcid = component.get("v.cID");
        var rsoql = component.get("v.rSoql");
        var humf = component.get("v.cMField");
        var enc = component.get("v.cEncoded");
        
        var action = component.get("c.getDisplay");
        action.setParams({
            "obj" : hobj,
            "soq": rsoql,
            "mfield": humf,
            "cid": hcid,
            "enc": enc
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            //console.log(err, "ERROR Data Table");
            //console.log(response.getReturnValue(),"ITEMS");
            if (state === "SUCCESS") {
				var disp = response.getReturnValue();
                console.log("disp",disp);
                component.set("v.cAccess", disp);
				                
            }else{
                component.set("v.cerror", true);
                component.set("v.cerrormsg", err[0].message);
                console.log(err,"ERRROR Items");
            }
        });
        $A.enqueueAction(action);
    }
})