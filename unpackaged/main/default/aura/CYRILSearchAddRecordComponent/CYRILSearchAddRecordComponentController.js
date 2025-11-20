({
    initValidator : function(component, event, helper) {
        console.log("Validator init");
        var cmpTarget = component.find('modal-validate');
        var cmpBack = component.find('modal-validate-back'); 
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        var val = component.get("v.cValid");
        var par = component.get("v.cParam");
        var parID = component.get("v.cParamAppendID");
        
        console.log(par, parID);
        
        // set preview fields
        var fieldsString = component.get("v.cPreviewFields");
        console.log("fields",fieldsString);
        // Check if fieldsString has a value
        if(!$A.util.isEmpty(fieldsString)) {
            // Split the string by comma and trim any whitespace
            var fieldsList = fieldsString.split(',').map(function(field) {
                return field.trim();
            });
            console.log("fields list",fieldsList);
            // Set the list to prevfields
            component.set("v.prevfields", fieldsList);
        } else {
            // Optionally, handle the case when fieldsString is empty
            console.log("cPreviewFields is empty or undefined.");
            // Set prevfields to an empty list or a default list if desired
            component.set("v.prevfields", []);
        }
        
    },
    handleKeyUp: function (cmp, evt) {
        var queryTerm = evt.target.value;
        console.log("SEARCH",queryTerm);
        var action = component.get("c.searchList");
        action.setParams({ 
            "searchKey" : queryTerm,
            "sObj" : component.get("v.cObj"),
            "sFields": component.get("v.cLField")+","+component.get("v.cVField")+","+component.get("v.cPField"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(response.getError(),"ERRROR");
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //console.log(storeResponse,"Results");
                
            }else{
                alert('There was a problem : ',response.getError());
            } 
        });
        setTimeout(function(){ 
            $A.enqueueAction(action);               
        }, 2000);
        
    },
    clickHandler : function (component, event, helper) {
        var cuID = component.get("v.cUID");
        component.set("v.isResultEmpty",false);
        console.log("clicked to search");
		var inputElement = document.querySelector('#combobox-id-21-'+cuID);
        console.log("search element",inputElement);
        const searchString = inputElement.value;
        console.log("search value",searchString);
        
        var eAdd = component.get("v.cEnableAdd");
        var eAddFlow = component.get("v.cFlowAction");
        var autosearch = component.get("v.cDisableAutoSearch");
		var ifunc = component.get("v.inputSearchFunction");
        console.log("IFUNC",autosearch);
        
        if (searchString.length >= 3 && autosearch != true) {
            //Ensure that not many function execution happens if user keeps typing
            if (component.get("v.inputSearchFunction")) {
                clearTimeout(component.get("v.inputSearchFunction"));
            }
            component.set("v.cloading", true);
            var inputTimer = setTimeout($A.getCallback(function () {
                helper.searchRecords(component, searchString);
            }), 1000);
            component.set("v.inputSearchFunction", inputTimer);
        }else if (autosearch == true) {
            console.log("Manual Search");
            //Ensure that not many function execution happens if user keeps typing
            //if (component.get("v.inputSearchFunction")) {
            //    clearTimeout(component.get("v.inputSearchFunction"));
            //}
            component.set("v.cloading", true);
            //var inputTimer = setTimeout($A.getCallback(function () {
             helper.searchRecords(component, searchString);
            //}), 1000);
            //component.set("v.inputSearchFunction", inputTimer);
        } else{
            console.log("NO RESULT");
            component.set("v.results", []);
            if(eAdd == true || eAddFlow == true){
                component.set("v.openDropDown", true);
            }else{
                component.set("v.openDropDown", false);
            }
            
        }
    },
    searchHandler : function (component, event, helper) {
        const searchString = event.target.value;
        var eAdd = component.get("v.cEnableAdd");
        var eAddFlow = component.get("v.cFlowAction");
        
        
        
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
            component.set("v.results", []);
            if(eAdd == true || eAddFlow == true){
                component.set("v.openDropDown", true);
            }else{
                component.set("v.openDropDown", false);
            }
            
        }
    },
    
    optionClickHandler : function (component, event, helper) {
        const selectedId = event.target.closest('li').dataset.id;
        const selectedValue = event.target.closest('li').dataset.value;
        
        var eValidation = component.get("v.cEnableResultValidator");
        
        if(eValidation){
            
            var action = component.get("c.validateRecord");
            action.setParams({ 
                "rId" : selectedId,
                "fields" : component.get("v.cValidationFields"),
                "obj" : component.get("v.cObj"),
                "filter": component.get("v.cValidationSOQL"),
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(response.getError(),"ERRROR");
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    console.log("validate record",storeResponse);
                    if(storeResponse.length > 0){
                        component.set("v.cValidationFailed", false);
                        component.set("v.eContactName", selectedValue);
                        component.set("v.openDropDown", false);
                        component.set("v.eContactId", selectedId);
                        component.set("v.selected", true);
                    }else{
                        component.set("v.cValidationFailed", true);
                        component.set("v.eContactName", selectedValue);
                        component.set("v.openDropDown", false);
                        component.set("v.eContactId", selectedId);
                        component.set("v.selected", true);
                    }
                }else{
                    component.set("v.cValidationFailed", true);
                    component.set("v.eContactName", selectedValue);
                    component.set("v.openDropDown", false);
                    component.set("v.eContactId", selectedId);
                    component.set("v.selected", true);
                } 
            });
			$A.enqueueAction(action);               
            
        }else{
            component.set("v.eContactName", selectedValue);
            component.set("v.openDropDown", false);
            component.set("v.eContactId", selectedId);
            component.set("v.selected", true);
        }

    },
    
    clearOption : function (component, event, helper) {
        component.set("v.results", []);
        component.set("v.openDropDown", false);
        component.set("v.eContactId", "");
        component.set("v.eContactName", "");
        component.set("v.newRec", "");
        component.set("v.selected", false);
    },
    /*clearOption : function (component, event, helper) {
        component.set("v.results", []);
        component.set("v.openDropDown", false);
        component.set("v.eContactId", "");
        component.set("v.eContactName", "");
    },*/
    goProceed : function (component, event, helper) {
        var eid = component.get("v.eContactId");
        var pth = component.get("v.cPath");
        var app = component.get("v.cAppendID");
        var enc = component.get("v.cEncloseID");
        var val = component.get("v.cValid");
        var par = component.get("v.cParam");
        var parID = component.get("v.cParamAppendID");
        
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        var rURL = '';
        if (app){
            if(enc){
                rURL = baseURL + pth +'%27'+eid+'%27&aid='+eid;
            }else{
                rURL = baseURL + pth +eid;
            }
        }else{
            rURL = baseURL + pth;
        }
        if(par){
            if(parID){
                rURL += par + eid;
            }else{
                rURL += par;
            }
        }
        //console.log(rURL);
        window.location = rURL;
        
    },
    addNewItem: function (component, event, helper) {
        var cOpt = component.get('c.clearOption');
        $A.enqueueAction(cOpt);
        component.set("v.addMode",true);
        console.log("ADD ITEM NOW");
        var addNew = component.get("v.cEnableAdd");
        var addForm = component.get("v.cEnableAddForm");
        var addFlow = component.get("v.cFlowAction");
        
        if(addNew){
            console.log("ADD NEW");
            var cf = component.get("v.cFields");
            if(cf){
                var gfields = component.get('c.getFields');
                $A.enqueueAction(gfields);
            }
        }else if(addForm){
            console.log("ADD NEW FORM");
            var gfields = component.get('c.getForm');
            $A.enqueueAction(gfields);
        }
		else if(addFlow){
            console.log("ADD NEW FLOW");
            var gfields = component.get('c.launchMe');
            $A.enqueueAction(gfields);
        }
        
        
    },
    goBack: function (component, event, helper) {
        window.history.back();
    },
    getFields: function(component, event, helper) {
        // get data
        // get configs
        var vrobj = component.get("v.cObj");
        var v1fields = component.get("v.cFields");
        
        var action = component.get("c.getEntryFields");
        action.setParams({
            "obj" : vrobj,
            "c1": v1fields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log("DATA",data);
                
                var result = [];
                var i = 0;
                for(var key in data){
                    //custs.push({value:conts[key], key:key});
                    var fs = new Object(); 
                    fs.label = key;
                    
                    //build rows
                    var fields = [];
                    var fls = data[key];
                    for(var f in fls){
                        fields.push(fls[f]);
                    }
                    fs.data = fields;
                    result.push(fs);
                    i++;
                }
                component.set("v.fields", result);
                component.set("v.addMode",true);
            }else{                
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action);
    },   
    getForm: function(component, event, helper) {
        console.log("call form");
        var fparams = component.get("v.cFormParams");
        //var urlString = window.location.href;
        //var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        console.log("form",fparams);
        component.set("v.cFormURL", fparams);
        component.set("v.addMode",true);
        var cmpTarget = component.find('modal-form');
        var cmpBack = component.find('modal-form-back'); 
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        
    },
    addSuccess : function(component, event, helper) {
        var record = event.getParams().response;
        console.log(record.id,"Record");
        var eid = record.id;
        var pth = component.get("v.cPath");
        var app = component.get("v.cAppendID");
        var enc = component.get("v.cEncloseID");
        var val = component.get("v.cValid");
        
        /*var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        if (app){
            if(enc){
                window.location = baseURL + pth +'%27'+eid+'%27';
            }else{
                window.location = baseURL + pth +eid;
            }
        }else{
            window.location = baseURL + pth;
        }*/
        var par = component.get("v.cParam");
        var parID = component.get("v.cParamAppendID");
        
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        var rURL = '';
        if (app){
            if(enc){
                rURL = baseURL + pth +'%27'+eid+'%27';
            }else{
                rURL = baseURL + pth +eid;
            }
        }else{
            rURL = baseURL + pth;
        }
        if(par){
            if(parID){
                rURL += par + eid;
            }else{
                rURL += par;
            }
        }
        //console.log(rURL);
        window.location = rURL;
        
        
        
        
        
    },
    formError: function(component, event, helper) {
        var record = event.getParam("response");
        console.log("FORM ERROR ", record);
    },
    skipMe: function(component, event, helper) {
        var eid = '';
        var pth = component.get("v.cPath");
        var app = component.get("v.cAppendID");
        var enc = component.get("v.cEncloseID");
        var val = component.get("v.cValid");
        
        var dval = component.get("v.cDefaultId");
        console.log("Default: ",dval);
        
        /*var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        if (app){
            if(enc){
                window.location = baseURL + pth +'%27'+eid+'%27';
            }else{
                window.location = baseURL + pth +eid;
            }
        }else{
            window.location = baseURL + pth;
        }*/
        var par = component.get("v.cParam");
        var parID = component.get("v.cParamAppendID");
        
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        var rURL = '';
        
        if(dval){
            if(enc){
                rURL = baseURL + pth +'%27'+dval+'%27&aid='+dval;
            }else{
                rURL = baseURL + pth;
            }
        }else{
            if (app){
                if(enc){
                    rURL = baseURL + pth +'%27'+eid+'%27';
                }else{
                    rURL = baseURL + pth +eid;
                }
            }else{
                rURL = baseURL + pth;
            }
        }
        

        if(par){
            if(parID){
                rURL += par + dval;
            }else{
                rURL += par + dval;
            }
        }
        //console.log(rURL);
        window.location = rURL;
    },
    launchMe: function(component, event, helper){
        
        var cmpTarget = component.find('modal-flow');
        var cmpBack = component.find('modal-flow-back'); 
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        var cname = component.get("v.cFlowName");
        const flow = component.find("flowData");
        
        //var cID = event.currentTarget.dataset.item;
        var currentID = component.get("v.cCID");
        console.log("CID", currentID);
        if(currentID){
            var inputVariables = [{ name : "recordId", type : "String", value: cID }];
            /*if(currentID){
                var occid = { name: "recordId", type : "String", value: currentID };
                inputVariables.push(occid);
            }*/
            console.log("flow vars",inputVariables);
            flow.startFlow(cname,inputVariables);
        }else{
            flow.startFlow(cname);
        }
        
        //flow.startFlow(cname);
    },
    closeMe: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        var cmpTarget = component.find('modal-flow');
        var cmpBack = component.find('modal-flow-back'); 
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open'); 
        component.set("v.addMode",false);
    },
    closeMeForm: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        var cmpTarget = component.find('modal-form');
        var cmpBack = component.find('modal-form-back'); 
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open'); 
        //component.set("v.addMode",true);
        //window.location.reload();
        $A.get('e.force:refreshView').fire();
        component.set("v.addMode",false);
    },
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        var cmpTarget = component.find('modal-flow');
        var cmpBack = component.find('modal-flow-back'); 
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open'); 
        $A.get('e.force:refreshView').fire();
        component.set("v.addMode",false);
        //window.location.reload();
    },
    handleStatusChange : function (component, event) {
        /*var red = component.get("v.cRedirect");
        if(event.getParam("status") === "FINISHED") {
            var cmpTarget = component.find('modal-flow');
            var cmpBack = component.find('modal-flow-back'); 
            $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
            $A.util.removeClass(cmpBack, 'slds-backdrop--open'); 
            $A.get('e.force:refreshView').fire();
            //window.location.reload();
                   
        }*/
        
        var oid;
        var rme = false;
        if(event.getParam("status") === "FINISHED") {
            var cmpTarget = component.find('modal-add');
            var cmpBack = component.find('modal-add-back'); 
            $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
            $A.util.removeClass(cmpBack, 'slds-backdrop--open'); 
            //$A.get('e.force:refreshView').fire();
            //console.log("flow red", red);

            //console.log("flow red processing", red);
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                // Pass the values to the component's attributes
                //console.log(outputVar.name, "flow")
                if(outputVar.name === "outputRecordId") {
                    oid = outputVar.value;
                }
                if(outputVar.name === "redirectMe") {
                    rme = outputVar.value;
                }
            }
            //console.log(rme,"flow rme");
            console.log(oid,"flow oid");
            if(oid){
                component.set("v.eContactId",oid);
                
                var pth = component.get("v.cPath");
                var app = component.get("v.cAppendID");
                var enc = component.get("v.cEncloseID");
                var val = component.get("v.cValid");
                var par = component.get("v.cParam");
                var parID = component.get("v.cParamAppendID");
                
                var urlString = window.location.href;
                var baseURL = urlString.substring(0, urlString.indexOf("/s"));
                
                var rURL = '';
                if (app){
                    if(enc){
                        rURL = baseURL + pth +'%27'+oid+'%27&aid='+oid;
                    }else{
                        rURL = baseURL + pth +oid;
                    }
                }else{
                    rURL = baseURL + pth;
                }
                if(par){
                    if(parID){
                        rURL += par + oid;
                    }else{
                        rURL += par;
                    }
                }
                console.log(rURL);
                
                component.get("v.cloading",true);
            
                var cme = component.get('c.closeMe');
            	$A.enqueueAction(cme);
                
                window.location = rURL;
                
                
                
            }
            
            
        }
    }
})