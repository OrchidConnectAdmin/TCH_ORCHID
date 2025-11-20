({
    doInit : function(component,event,helper){
        var selectedRecord = component.get("v.selectedRecord");
        if(!$A.util.isUndefinedOrNull(selectedRecord)){
            var pillTarget = component.find("lookup-pill");
            var lookUpTarget = component.find("lookupField"); 
            
            $A.util.removeClass(pillTarget, 'slds-hide');
            $A.util.addClass(pillTarget, 'slds-show');
            
            $A.util.removeClass(lookUpTarget, 'slds-show');
            $A.util.addClass(lookUpTarget, 'slds-hide');
        }
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
        //debugger;
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    keyReleaseController : function(component,event,helper){
        //debugger;
        var getInputkeyWord = component.get("v.SearchKeyWord");
        var obj = {};
        obj.JB_Email__c = getInputkeyWord;
        obj.Id = null;
        
        component.set("v.selectedRecord", obj);
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,helper){
         helper.clearHelper(component,event,helper);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
       // debugger;
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent');
        console.log(JSON.stringify(selectedAccountGetFromEvent));
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
        //Added on 02-12-2019
        if (!$A.util.isUndefinedOrNull(selectedAccountGetFromEvent)) {
            if(component.get("v.displayField") == 'JB_Email__c'){
                console.log("selectedAccountGetFromEvent.JB_Email__c :: "+selectedAccountGetFromEvent.JB_Email__c);
                component.set("v.SearchKeyWord", selectedAccountGetFromEvent.JB_Email__c);
            }
            if(component.get("v.displayField") == 'Domestic_Account_Name_Number__c'){
                component.set("v.SearchKeyWord", selectedAccountGetFromEvent.Domestic_Account_Name_Number__c);
            }
            if(component.get("v.displayField") == 'International_Account_Name_Number__c'){
                component.set("v.SearchKeyWord", selectedAccountGetFromEvent.International_Account_Name_Number__c);
            }
        }
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
    
    
    // This function call when the end User Select any record from the result list.   
    setSelectedValue : function(component, event, helper) {
       // debugger;
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
        /*** new Changes ***/
       var selObj = component.get("v.selectedRecord");
        console.log("==> "+JSON.stringify(selObj));
        console.log("selObj.JB_Email__c :: "+selObj.JB_Email__c);
        
        console.log('displayField ==>> '+component.get("v.displayField"));
        
        if(component.get("v.displayField") == 'JB_Email__c' && $A.util.isUndefinedOrNull(selObj.JB_Email__c)) {
            helper.clearHelper(component,event,helper);
        }else if(component.get("v.displayField") == 'Domestic_Account_Name_Number__c' && $A.util.isUndefinedOrNull(selObj.Domestic_Account_Name_Number__c)) {
            helper.clearHelper(component,event,helper);
        }else if(component.get("v.displayField") == 'Domestic_Account_Name_Number__c' && !$A.util.isUndefinedOrNull(selObj.Domestic_Account_Name_Number__c)) {
            component.set("v.SearchKeyWord", selObj.Domestic_Account_Name_Number__c);
        }else if(component.get("v.displayField") == 'International_Account_Name_Number__c' && $A.util.isUndefinedOrNull(selObj.International_Account_Name_Number__c)) {
            helper.clearHelper(component,event,helper);
        }else if(component.get("v.displayField") == 'International_Account_Name_Number__c' && !$A.util.isUndefinedOrNull(selObj.International_Account_Name_Number__c)) {
            component.set("v.SearchKeyWord", selObj.International_Account_Name_Number__c);
        }else{
            component.set("v.SearchKeyWord",selObj.JB_Email__c);
        }
        
    },
    
    validateEmailField : function(component, event, helper) {
       // debugger;
        
        
        var allValid = true;
        //validate Email Field for required fields
        if(component.get("v.required")){
            var inputCmp = component.find("inputEmail");
            var value = inputCmp.get("v.value");
            // is input valid text?
            if (!$A.util.isUndefinedOrNull(value) && value.trim() != "") {
                inputCmp.setCustomValidity(""); // if there was a custom error before, reset it
                allValid = true;
            } else {
                inputCmp.setCustomValidity("Complete this field.");
                allValid = false;
            }
            
        	inputCmp.reportValidity();
            
        }
        
		return allValid;
		
	},
    
    setdisplayVal  : function(component, event, helper) {
    //	debugger;
        var selVal = component.get("v.selectedRecord");
        var displayField = component.get("v.displayField");
        
        // getting value of display fields
        if(selVal != null){
            var displayVal = selVal[displayField];
            component.set("v.displayval",displayVal);
        }
    }
    
    
})