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
            "grp": gCol
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var err = response.getError();
            //console.log(err, "ERROR Data Table");
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
                component.set("v.score", score);
                component.set("v.items", result);
                var dtb = component.get('c.initDtable');$A.enqueueAction(dtb);
            }else{
                console.log(err,"ERRROR Items");
            }
        });
        $A.enqueueAction(action);
    }
})