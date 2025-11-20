({
	initDetails : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.bURL", baseURL);
        var cc1 = component.get("v.c1Fields");
        var cc2 = component.get("v.c2Fields");
        var cc3 = component.get("v.c3Fields");
        var cc4 = component.get("v.c4Fields");
        
        
        var heads = component.get('c.getHeader');
        $A.enqueueAction(heads);
        
        if(cc1){var gcol1 = component.get('c.getCol1');$A.enqueueAction(gcol1);}
        if(cc2){var gcol2 = component.get('c.getCol2');$A.enqueueAction(gcol2);}
        if(cc3){var gcol3 = component.get('c.getCol3');$A.enqueueAction(gcol3);}
        if(cc4){var gcol4 = component.get('c.getCol4');$A.enqueueAction(gcol4);}
        
        var vrobj = component.get("v.cRID");
        var action = component.get("c.getObject");
        action.setParams({
            "rid" : vrobj
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                // build columns
                component.set("v.cObj", data);
            }else{
                console.log(err,"ERRROR DATA");
            }
        });
        $A.enqueueAction(action);

    },
    
    getHeader : function(component, event, helper) {
        // get data
        // get configs
        var vrobj = component.get("v.cRID");
        var v1fields = component.get("v.cHeaderMain");
    	var v2fields = component.get("v.cHeaderSub");
        var action = component.get("c.getPageHeader");
        action.setParams({
            "rid" : vrobj,
            "c1": v1fields,
            "c2": v2fields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {

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
                component.set("v.header", result);
                
            }else{
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action);
    },
    getCol1 : function(component, event, helper) {
        // get data
        // get configs
        var vrobj = component.get("v.cRID");
        var v1fields = component.get("v.c1Fields");
        var vhide = component.get("v.c1Hide");

        var action = component.get("c.getColumnData1");
        action.setParams({
            "rid" : vrobj,
            "c1": v1fields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                
                var result = [];
                var i = 0;
                var wval = 0;
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
                    
                    var flds = fs.data;
                    fs.hide = true;
                    for(var fl in flds){
                        var ans = flds[fl].answer;
                        if(ans === 'NULL' || ans === undefined){
                        }else{
                            fs.hide = false;
                        }
                    }
                    result.push(fs);
                    i++;
                }
                component.set("v.column1", result);
                component.set("v.loaded1", true);
                
            }else{
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action);
    },
    getCol2 : function(component, event, helper) {
        // get data
        // get configs
        var vrobj = component.get("v.cRID");
        var v1fields = component.get("v.c2Fields");

        var action = component.get("c.getColumnData2");
        action.setParams({
            "rid" : vrobj,
            "c1": v1fields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                
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

                    var flds = fs.data;
                    fs.hide = true;
                    for(var fl in flds){
                        var ans = flds[fl].answer;
                        if(ans === 'NULL' || ans === undefined){
							console.log("IT IS NULL",ans);
                        }else{
                            fs.hide = false;
                            console.log("ANS",ans);
                        }
                    }
                    
                    result.push(fs);
                    i++;
                }
                console.log("FS",result);
                component.set("v.column2", result);
                component.set("v.loaded2", true);
                
            }else{
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action);
    },
    getCol3 : function(component, event, helper) {
        // get data
        // get configs
        var vrobj = component.get("v.cRID");
        var v1fields = component.get("v.c3Fields");

        var action = component.get("c.getColumnData3");
        action.setParams({
            "rid" : vrobj,
            "c1": v1fields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                
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
                    
                    var flds = fs.data;
                    fs.hide = true;
                    for(var fl in flds){
                        var ans = flds[fl].answer;
                        if(ans === 'NULL' || ans === undefined){
							console.log("IT IS NULL",ans);
                        }else{
                            fs.hide = false;
                            console.log("ANS",ans);
                        }
                    }
                    
                    result.push(fs);
                    i++;
                }
                component.set("v.column3", result);
                component.set("v.loaded3", true);
                
            }else{
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action);
    },
    getCol4 : function(component, event, helper) {
        // get data
        // get configs
        var vrobj = component.get("v.cRID");
        var v1fields = component.get("v.c4Fields");

        var action = component.get("c.getColumnData4");
        action.setParams({
            "rid" : vrobj,
            "c1": v1fields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                
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
                    
                    var flds = fs.data;
                    fs.hide = true;
                    for(var fl in flds){
                        var ans = flds[fl].answer;
                        if(ans === 'NULL' || ans === undefined){
							console.log("IT IS NULL",ans);
                        }else{
                            fs.hide = false;
                            console.log("ANS",ans);
                        }
                    }
                    
                    result.push(fs);
                    i++;
                }
                component.set("v.column4", result);
                component.set("v.loaded4", true);
                
            }else{
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action);
    },
    getColsData : function(component, event, helper) {
        // get data
        // get configs
        var vrobj = component.get("v.cRID");
        var v1fields = component.get("v.c1Fields");
        var v2fields = component.get("v.c2Fields");
        var v3fields = component.get("v.c3Fields");
        var v4fields = component.get("v.c4Fields");

        var action = component.get("c.getColumnData");
        action.setParams({
            "rid" : vrobj,
            "c1": v1fields,
            "c2": v2fields,
            "c3": v3fields,
            "c4": v4fields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                // build columns
                console.log("DATA---", data);
                component.set("v.fields", data);
                
            }else{
                console.log(err,"ERRROR DATA");
            }
        });
        $A.enqueueAction(action);
    },
	getRID : function(component, event, helper) {
        
        // get configs
        var vrobj = component.get("v.cRObj");
        var v1fields = component.get("v.c1Fields");
        var v2fields = component.get("v.c2Fields");
        var v3fields = component.get("v.c3Fields");
        var v4fields = component.get("v.c4Fields");
        var v1title = component.get("v.c1Title");
        var v2title = component.get("v.c2Title");
        var v3title = component.get("v.c3Title");
        var v4title = component.get("v.c4Title");
        var vsoql = component.get("v.cSoql");
        var vusermatch = component.get("v.cUserMatchingField");
        var vusecid = component.get("v.cUseContactId");
        
        var action = component.get("c.getRecordID");
        action.setParams({
            "obj" : vrobj,
            "fields1": v1fields,
            "fields2": v2fields,
            "fields3": v3fields,
            "fields4": v4fields,
            "soq": vsoql,
            "userfield": vusermatch,
            "usecid": vusecid
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            var data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.editId", data);
                
                var cols = 0;
                var titles = [];
                var fields = [];
                var cfs = new Object(); 
                if(v1fields){
                    cfs.title = v1title;
                    cfs.data = v1fields.split(",");
                    fields.push(cfs);
                }
                if(v2fields){
                    cfs.title = v2title;
                    cfs.data = v2fields.split(",");
                    fields.push(cfs);
                }
                if(v3fields){
                    cfs.title = v3title;
                    cfs.data = v3fields.split(",");
                    fields.push(cfs);
                }
                if(v4fields){
                    cfs.title = v4title;
                    cfs.data = v4fields.split(",");
                    fields.push(cfs);
                }
                console.log("FIELDS",fields);
				component.set("v.cfields", fields);          
                
            }else{
                console.log(err,"ERRROR Columns");
            }
        });
        $A.enqueueAction(action);

    },
    editRecord: function(component, event, helper){
        var openMe = component.get('c.openModal');
        $A.enqueueAction(openMe);

    },
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        // slds-fade-in-open
        var cmpTarget = component.find('modal-add');
        var cmpBack = component.find('modal-add-back'); 
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    openNewModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        // slds-fade-in-open
        var cmpTarget = component.find('modal-add');
        var cmpBack = component.find('modal-add-back'); 
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        var cmpTarget = component.find('modal-add');
        var cmpBack = component.find('modal-add-back'); 
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open'); 
    },
    
    addSuccess : function(component, event, helper) {
        var record = event.getParams().response;
        //console.log(record.id,"Record");
        var closeMe = component.get('c.closeModal');
        $A.enqueueAction(closeMe);
        $A.get('e.force:refreshView').fire(); 

        /*var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        component.find('notifLib').showNotice({
            "variant": "success",
            "title": "Success",
            "message": "New Resident Added #" + myRecordId
        });*/
        
    },
    cancelCol1: function(component, event, helper) {
        component.set("v.c1EditNow", false);  
    },
    editCol1: function(component, event, helper) {
        component.set("v.c1EditNow", true);  
    },
    cancelCol2: function(component, event, helper) {
        component.set("v.c2EditNow", false);  
    },
    editCol2: function(component, event, helper) {
        component.set("v.c2EditNow", true);  
    },
    cancelCol3: function(component, event, helper) {
        component.set("v.c3EditNow", false);  
    },
    editCol3: function(component, event, helper) {
        component.set("v.c3EditNow", true);  
    },
    cancelCol4: function(component, event, helper) {
        component.set("v.c4EditNow", false);  
    },
    editCol4: function(component, event, helper) {
        component.set("v.c4EditNow", true);  
    },
})