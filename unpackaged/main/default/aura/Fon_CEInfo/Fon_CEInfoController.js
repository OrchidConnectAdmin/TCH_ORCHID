({
    doInit : function(component, event, helper) {
        debugger;        
        helper.doInitHelper(component, event, helper);
    },
    
    /*call dateUpdate function on onchange event on date field*/ 
    dateUpdate : function(component, event, helper) {
        debugger;
        var selectedDate = component.get("v.ncPCreditRec").sessionDate;        
        component.set("v.disableSave",false);
        component.set("v.dateErrorMessage","");
        
        // split dates
        var dateParts = selectedDate.split('-');
        if(dateParts.length == 3){
            
            var d = new Date();
            var n = d.getFullYear(); 
            
            console.log('***'+d);
            
            // allowed selection
            var allowedSelection = 'previous_currentyear';
            
            // today is greate then 1 july the set variable to current year else previous year
            if(d.getMonth() <= 6){
                allowedSelection = 'previous_currentyear';
            }
            else{
                allowedSelection = 'currentyear';
            }
           
            
            /**
            // checking if the date selected is 1st of july
            if(parseInt(dateParts[1]) >= 7
              	&& parseInt(dateParts[2]) >= 1){
                allowedSelection = 'currentyear';
            }
            **/
            
            if(allowedSelection == ''){
                if(dateParts[0] != n){
                    component.set("v.disableSave",true);
                    component.set("v.dateErrorMessage","Credits may only be entered for current year")
                }
            }
            else{
                if(dateParts[0] == n
                   || dateParts[0] == (n -1 )){
                    // valid selected
                }
                else{
                    //show error
                    component.set("v.disableSave",true);
                    component.set("v.dateErrorMessage","Credits may only be entered for current or previous year")
                }
            }
            
            
        }
        
           	
    },
    
    openNCPsessioPOPUP : function(component, event, helper) {
        helper.openNCPsessioPOPUPHelper(component, event, helper);
    },
    
    closeNCPsessioPOPUP : function(component, event, helper) {
        component.set("v.displayNCPSessionModal",false);
        component.set("v.disableSave",false);
        component.set("v.dateErrorMessage","");
        helper.assignNullValue(component, event, helper);
    },
    
    providerValChng : function(component, event, helper) {
        helper.providerValChngHelper(component, event, helper);
    },
    
    findCreditVal : function(component, event, helper) {
        helper.findCreditValHelper(component, event, helper);
    },
    
    saveNCPCreditRec : function(component, event, helper) {        
        //debugger;
        var allValid = component.find('myinput').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        
        if(allValid){
            helper.saveNCPCreditRecHelper(component, event, helper);
        }
    },
    
    openNCPCreditPOPUP : function(component, event, helper) {
        helper.openNCPCreditPOPUPHelper(component, event, helper);
    },
    
    closeNCPCreditPOPUP : function(component, event, helper) {
        component.set("v.displayNCPCreditModal",false);
        component.set("v.disableSave",false);
        component.set("v.dateErrorMessage","");
    },
    
    saveNCPCreditMannaulRec : function(component, event, helper) {
        helper.saveNCPCreditMannaulRecHelper(component, event, helper);
    },
    
    handleClick : function(component, event, helper) {
        debugger;
        var recId = event.target.name;
        console.log('my selected rec : '+ JSON.stringify(recId));
        var dataList = component.get("v.NCPCreditDetail.lstNonApprovedNCPCredits");
        for(var ele in dataList){
            if(recId == dataList[ele].Id){
                component.set("v.nonApprovencpRecSel",dataList[ele]);
                component.set("v.nonApprovencpRecSelmodal",true);
                break;
            }
        }
        component.set("v.nonapprovededit",true);
    },
    
    approvalRecEdit : function(component, event, helper) {
        debugger;
        var recId = event.target.name;
        console.log('my selected rec : '+ JSON.stringify(recId));
        var dataList = component.get("v.NCPCreditDetail.lstApprovedNCPCredits");
        for(var ele in dataList){
            if(recId == dataList[ele].Id){
                component.set("v.nonApprovencpRecSel",dataList[ele]);
                component.set("v.nonApprovencpRecSelmodal",true);
                break;
            }
        }
        component.set("v.nonapprovededit",false);
    },
    
    updatenonappModal : function(component, event, helper) {
        debugger;
        helper.updatenonappRec(component, event, helper);        
    },
    
    closenonappModal : function(component, event, helper) {
        component.set("v.nonApprovencpRecSelmodal",false);
        component.set("v.disableSave",false);
        component.set("v.dateErrorMessage","");
    },
    
    displaydelApproveModal : function(component, event, helper) {
        debugger;
        var recId = event.target.name;
        console.log('my selected rec : '+ JSON.stringify(recId));
        var dataList = component.get("v.NCPCreditDetail.lstApprovedNCPCredits");
        for(var ele in dataList){
            if(recId == dataList[ele].Id){
                component.set("v.deletedRec",dataList[ele].Id);
                component.set("v.deleteModal",true);
                break;
            }
        }
    },
    
    displaydelNonApproveModal : function(component, event, helper) {
        debugger;
        var recId = event.target.name;
        console.log('my selected rec : '+ JSON.stringify(recId));
        var dataList = component.get("v.NCPCreditDetail.lstNonApprovedNCPCredits");
        for(var ele in dataList){
            if(recId == dataList[ele].Id){
                component.set("v.deletedRec",dataList[ele].Id);
                component.set("v.deleteModal",true);
                break;
            }
        }
    },
    
    deleteSelRec : function(component,event,helper){
        helper.deleteRecHelper(component,event,helper);
    },
    
    closedelModal : function(component, event, helper) {
        component.set("v.deleteModal",false);
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    displayNotesModal : function(component,event,helper){
        component.set("v.notesTitle"," ");
        component.set("v.notesDes"," ");
        component.set("v.displayNotesModal",true);
    },
    
    createNotesRec : function(component,event,helper){
        debugger;
        if(component.get("v.notesTitle").trim().length == 0 
           ||component.get("v.notesTitle") == null 
           || component.get("v.notesTitle") == undefined
           || component.get("v.notesTitle") == " "){
            alert('Title value can not be null or blank.');
        }else{
            helper.createNotesHelper(component, event, helper);
        }
    },
    
    
    closeNotesModal : function(component, event, helper) {
        component.set("v.displayNotesModal",false);
    },
})