({
    doinit : function(component, event, helper){      
    	
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRecord");
    	
        var primaryField = component.get("v.PrimaryField");
        var secField = component.get("v.secondayFields");
        
        var secDisplayText = [];
        
        if(getSelectRecord != null){
            //debugger;
            // for each element in sec obj
            for(var ele in secField){
                
                // getting values form object
                if(getSelectRecord[[secField[ele].Name]] != null){
                    secDisplayText.push('<b>'+secField[ele].Label+'</b>: '+getSelectRecord[secField[ele].Name]);
                }
            }
            
            var finalDisplayText = getSelectRecord[primaryField]+'<br/>'+secDisplayText.join('<br/>');
            component.set("v.displayString",finalDisplayText);
        }
       console.log('getSelectRecord');
       console.log(getSelectRecord);
    },
   selectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
       console.log('getSelectRecord.Name');
       console.log(getSelectRecord.Name);
       console.log('getSelectRecord');
       console.log(getSelectRecord);
    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
       compEvent.setParams({"recordByEvent" : getSelectRecord });  
    // fire the event  
         compEvent.fire();
    }
})