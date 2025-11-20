({
	doInit : function(component, event, helper) {
		var action = component.get("c.retrieveFields");
        // the function that reads the url parameters
            console.log('record1 ' + component.get("v.recordId"));
            var getUrlParameter = function getUrlParameter(sParam) {
                var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                    sURLVariables = sPageURL.split('&')[0],
                    sParameterName,
                    i;

                for (i = 0; i < sURLVariables.length; i++) {
                    console.log('spage url ' + sURLVariables );
                    if(sURLVariables.includes('id=')){
                        return sURLVariables.replace(/\id=/g,"");
                    }
                       
                   
                    
                }
            };
        
        var pageRef =  getUrlParameter('id');
       
        if(typeof pageRef === 'undefined'){
            pageRef = component.get("v.recordId");
            component.set("v.isRecordIdFoundVar", true);
        }else{
            component.set("v.isRecordIdFoundVar", false);
            
        }
         
        console.log('pf4 = ' + pageRef);
        
        console.log('isRecordIdFound = ' + component.get("v.isRecordIdFoundVar"));
		action.setParams({ 
            fieldsetName : component.get("v.fieldSetVar"),
            ObjectName : component.get("v.recordPageObjectvar"),
            apiLookupFieldName : component.get("v.lookupFieldAPIVar"),
            currentRecordId : pageRef,
            isRecordFound	: component.get("v.isRecordIdFoundVar")
        });
        
        action.setCallback(this, function( response ) {
            var state = response.getState();
            console.log('state1 = ' + state);
            if ( state === "SUCCESS") {
                var fieldsList = response.getReturnValue();
                component.set( "v.soRecordId",fieldsList.sfRecordId);
                console.log('test ',JSON.stringify(response.getReturnValue()));
                component.set( "v.objFieldSet",fieldsList.allFields);
            }
            else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
	},
    handleOnSuccess : function(component, event, helper) {
        alert('record saved successfully');
       /* 
        * does not work, so used alert
        * var toastEvent = $A.get("e.force:showToast");
        console.log('test', toastEvent);
        toastEvent.setParams({
            "title": "Record status",
            "type": 'Success',
            "message": 'message'
        });
        toastEvent.fire();*/
        
	}
})