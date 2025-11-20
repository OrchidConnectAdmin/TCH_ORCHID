({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'ObjectName' : component.get("v.objectAPIName"),
            'searchKeyWord': getInputkeyWord,            
            'wherecaluse' : component.get("v.whereclause"),
            'returnFields' : component.get("v.returnFields"),
            'filterField' : component.get("v.filterField")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var messageDisplay = 'No Result Found...';                               
                var storeResponse = response.getReturnValue();
              	// if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", messageDisplay);
                    /** new change 
                    var obj = {};
                    obj.JB_Email__c = getInputkeyWord;
                    obj.Id = null;
                    
                    component.set("v.selectedRecord", obj);**/
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    
    // function for clear the Record Selaction 
    clearHelper :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );   
    },
    
})