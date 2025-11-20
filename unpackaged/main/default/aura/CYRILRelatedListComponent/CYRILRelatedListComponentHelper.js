({
    fetchDataHelper : function(component, event, helper) {
        
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
		var enc = component.get("v.cEncoded");
        var hlist = component.get("v.cHideList");
        var hfpass = component.get("v.cFieldPass");
        var dist = component.get("v.cDistinct");
        var dfield = component.get("v.cDistinctField");
        
        hsoql = hsoql.replace(/%20/g, ' ');
        //console.log("SOQL", sdsd);
        
        // get columns
        var action2 = component.get("c.getColumns");
        action2.setParams({
            "obj" : hobj,
            "fields": hfields,
        });
        action2.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            //console.log(err, "ERROR Data Table");
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
                if(gCol !== undefined){
                	ccols.splice(gCol-1, gCol);
                }
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
            "fields": hfields,
            "soq": hsoql,
            "mfield": humf,
            "cid": hcid,
            "grp": gCol,
            "enc": enc,
            "fpass": hfpass,
            "dist": dist,
            "dfield": dfield
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            //console.log(err, "ERROR Data Table");
            console.log(response.getReturnValue(),"ITEMS");
            var result = [];
            if (state === "SUCCESS") {
                
                var dat = response.getReturnValue();
                var dlen = Object.keys(dat).length;
                //console.log("dat",dat);
                var score = 0;
                if(hDT == "Table"){
                    if(gCol.length !== 0){
                        //console.log(response.getReturnValue(),"ITEMS");
                        var i = 0;
                        var grps = [];
                        // get groups                       
                        for (var key in dat) {
                            //if (dat.hasOwnProperty(key)) {
                            if(grps.includes(dat[key][gCol-1]) == false){
                            	grps.push(dat[key][gCol-1]);
                        	}
                        }
                        var i;
                        for (i = 0; i < grps.length; i++) {
                            var j = 0;
                            var rows = [];
                            var grp = new Object();
                            grp.group = grps[i];
                            var rowscore = 0;
                            for (var key in dat) {
                                if (dat[key][gCol-1] == grps[i]) {
                                    var da = new Object(); 
                                    var ida = [];
                                    da.id = key;
                                    //var ddata = delete dat[key][gCol];
                                    if(calcol !== undefined){
                                       score += parseInt(dat[key][calcol-1]);
                                       rowscore += parseInt(dat[key][calcol-1]);
                                    }
                                    
                                    var dd = dat[key];
                                    dd.splice(gCol-1, gCol);
                                    da.data = [dd];
                                    
                                    //da.data.splice(gCol, 1);
                                    rows.push(da);
                                    j++;
                                }
                            }
                            if(calmet == 'Average'){
                                grp.score = (rowscore/j).toFixed(1);
                            }else{
                                grp.score = rowscore;
                            }
                            
                            grp.data = rows;
                            result.push(grp);
                        } 

                    }else{
                        for (var key in dat) {
                            //if (dat.hasOwnProperty(key)) {
                            var da = new Object(); 
                            var ida = [];
                            da.id = key;
                            da.data = [dat[key]];
                            
                                    if(calcol !== undefined){
                                       score += parseInt(dat[key][calcol-1]);
                                    }
                            
                            result.push(da);
                            //}
                        } 
                    }
					
                }else{
                    for (var key in dat) {
                        //if (dat.hasOwnProperty(key)) {
                        var da = new Object(); 
                        var ida = [];
                        da.id = key;
                        da.name = dat[key][1];
                        if(calcol !== undefined){
                            score += parseInt(dat[key][calcol-1]);
                        }
                        //console.log(dat[key].splice(0,1),"SPLICE");
                        da.data = [dat[key]];
                        result.push(da);
                        //}
                	}
                }
                if(calmet == 'Average'){
                    score = (score/dlen).toFixed(1);
                    console.log("DLEN",dlen);
                }
                //console.log(gCol.length,"COL GROUP?");
                console.log("RESULTS",result);
                component.set("v.score", score);
                component.set("v.items", result);
                component.set("v.iCount", result.length);
                component.set("v.cloading", false);
                
                if(hlist == true && result.length < 1){
                    component.set("v.cAccess", true);
                }else{
                    var dtb = component.get('c.initDtable');$A.enqueueAction(dtb);
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
    searchRecords : function(component, searchString) {
		var rUID = component.get("v.cUID");
        component.set("v.schString", searchString);
        console.log("SEARCH THIS",searchString);
        component.set("v.items", []);
        
        var hobj = component.get("v.cObj");
        var hfields = component.get("v.cFields");
        var hsoql = component.get("v.cSoql");
        var humf = component.get("v.cMField");
        var hcid = component.get("v.cID");
        var hDT = component.get("v.cDType");
        var gCol = component.get("v.cGroupRowColumn");
        var calcol = component.get("v.cCalCol");
        var calmet = component.get("v.cCalMethod");
        var enc = component.get("v.cEncoded");
        var hfpass = component.get("v.cFieldPass");
        var dist = component.get("v.cDistinct");
        var dfield = component.get("v.cDistinctField");
        
        var action = component.get("c.getItems");
        action.setParams({
            "obj" : hobj,
            "fields": hfields,
            "soq": hsoql,
            "mfield": humf,
            "cid": hcid,
            "grp": gCol,
            "sch" : searchString,
            "enc": enc,
            "fpass": hfpass,
            "dist": dist,
            "dfield": dfield
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            //console.log(err, "ERROR Data Table");
            //console.log(response.getReturnValue(),"SEARCH ITEMS");
            var result = [];
            if (state === "SUCCESS") {
                
                var dat = response.getReturnValue();
                var dlen = Object.keys(dat).length;
                //console.log("dat",dat);
                var score = 0;
                if(hDT == "Table"){
                    if(gCol.length !== 0){
                        //console.log(response.getReturnValue(),"ITEMS");
                        var i = 0;
                        var grps = [];
                        // get groups                       
                        for (var key in dat) {
                            //if (dat.hasOwnProperty(key)) {
                            if(grps.includes(dat[key][gCol-1]) == false){
                            	grps.push(dat[key][gCol-1]);
                        	}
                        }
                        var i;
                        for (i = 0; i < grps.length; i++) {
                            var j = 0;
                            var rows = [];
                            var grp = new Object();
                            grp.group = grps[i];
                            var rowscore = 0;
                            for (var key in dat) {
                                if (dat[key][gCol-1] == grps[i]) {
                                    var da = new Object(); 
                                    var ida = [];
                                    da.id = key;
                                    //var ddata = delete dat[key][gCol];
                                    if(calcol !== undefined){
                                       score += parseInt(dat[key][calcol-1]);
                                       rowscore += parseInt(dat[key][calcol-1]);
                                    }
                                    
                                    var dd = dat[key];
                                    dd.splice(gCol-1, gCol);
                                    da.data = [dd];
                                    
                                    //da.data.splice(gCol, 1);
                                    rows.push(da);
                                    j++;
                                }
                            }
                            if(calmet == 'Average'){
                                grp.score = (rowscore/j).toFixed(1);
                            }else{
                                grp.score = rowscore;
                            }
                            
                            grp.data = rows;
                            result.push(grp);
                        } 

                    }else{
                        for (var key in dat) {
                            //if (dat.hasOwnProperty(key)) {
                            var da = new Object(); 
                            var ida = [];
                            da.id = key;
                            da.data = [dat[key]];
                            
                                    if(calcol !== undefined){
                                       score += parseInt(dat[key][calcol-1]);
                                    }
                            
                            result.push(da);
                            //}
                        } 
                    }
					
                }else{
                    for (var key in dat) {
                        //if (dat.hasOwnProperty(key)) {
                        var da = new Object(); 
                        var ida = [];
                        da.id = key;
                        da.name = dat[key][1];
                        if(calcol !== undefined){
                            score += parseInt(dat[key][calcol-1]);
                        }
                        //console.log(dat[key].splice(0,1),"SPLICE");
                        da.data = [dat[key]];
                        result.push(da);
                        //}
                	}
                }
                if(calmet == 'Average'){
                    score = (score/dlen).toFixed(1);
                    console.log("DLEN",dlen);
                }
                //console.log(gCol.length,"COL GROUP?");
                //console.log("RESULTS",result);
                component.set("v.iCount", result.length);
                component.set("v.score", score);
                component.set("v.items", result);
                component.set("v.cloading", false);
                //var dtb = component.get('c.initDtable');$A.enqueueAction(dtb);
            }else{
                component.set("v.cloading", false);
                component.set("v.cerror", true);
                component.set("v.cerrormsg", err[0].message);
                console.log(err,"ERRROR Items");
            }
        });
        $A.enqueueAction(action);
    }
})