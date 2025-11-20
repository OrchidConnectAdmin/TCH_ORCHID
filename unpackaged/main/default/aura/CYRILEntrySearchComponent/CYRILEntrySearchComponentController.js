({
	initValidator : function(component, event, helper) {
		console.log("Validator init");
        var cmpTarget = component.find('modal-validate');
        var cmpBack = component.find('modal-validate-back'); 
        var val = component.get("v.cValid");
        var par = component.get("v.cParam");
        var parID = component.get("v.cParamAppendID");
        var vtbutton = component.get("v.cEnableTButton");
        if(vtbutton==false){
            console.log("vt",vtbutton);
            component.set("v.popit",true);
        	$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        	$A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        }
        
        

	},
    popMe: function (component, evt) {
        var cmpTarget = component.find('modal-validate');
        var cmpBack = component.find('modal-validate-back'); 
        component.set("v.popit",true);
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    closeMe: function (component, evt) {
        var cmpTarget = component.find('modal-validate');
        var cmpBack = component.find('modal-validate-back'); 
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open'); 
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
    searchHandler : function (component, event, helper) {
        const searchString = event.target.value;
        var eAdd = component.get("v.cEnableAdd");
        if (searchString.length >= 3) {
            //Ensure that not many function execution happens if user keeps typing
            if (component.get("v.inputSearchFunction")) {
                clearTimeout(component.get("v.inputSearchFunction"));
            }

            var inputTimer = setTimeout($A.getCallback(function () {
                helper.searchRecords(component, searchString);
            }), 1000);
            component.set("v.inputSearchFunction", inputTimer);
        } else{
            component.set("v.results", []);
            if(eAdd == true){
                component.set("v.openDropDown", true);
            }else{
                component.set("v.openDropDown", false);
            }
            
        }
    },

    optionClickHandler : function (component, event, helper) {
        const selectedId = event.target.closest('li').dataset.id;
        const selectedValue = event.target.closest('li').dataset.value;
        component.set("v.eContactName", selectedValue);
        component.set("v.openDropDown", false);
        component.set("v.eContactId", selectedId);
        component.set("v.selected", true);
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
    addNewItem: function (component, event, helper) {
        var cOpt = component.get('c.clearOption');
        $A.enqueueAction(cOpt);
        
        var cf = component.get("v.cFields");
		if(cf){var gfields = component.get('c.getFields');$A.enqueueAction(gfields);}
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
})