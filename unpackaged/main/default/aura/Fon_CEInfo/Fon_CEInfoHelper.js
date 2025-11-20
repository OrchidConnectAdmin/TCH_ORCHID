({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb 
    
    doInitHelper : function(component, event, helper) {
        var action = component.get("c.fetchNCPCredit");    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                
                
                component.set("v.NCPCreditDetail",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();                    
                    if (errors) {
                        var errorMsg = JSON.stringify(errors);
                        alert(errorMsg);
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    openNCPsessioPOPUPHelper : function(component, event, helper) {
        debugger;
        
        var action = component.get("c.fecthApprovedSession");
        //  action.setParams({// parameter});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.ncpSessionList",response.getReturnValue());
                component.set("v.displayNCPSessionModal",true);
                var ssList = component.get("v.ncpSessionList");
                var providerSet = new Set();
                var providerlistval = [];
                for(var ele in ssList){
                    if(!providerSet.has(ssList[ele].Provider_Name__c)){
                        providerSet.add(ssList[ele].Provider_Name__c);
                        providerlistval.push(ssList[ele].Provider_Name__c);
                    }
                }
                component.set("v.providerList",providerlistval);
                console.log( JSON.stringify(component.get("v.providerList")));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();                    
                    if (errors) {
                        var errorMsg = JSON.stringify(errors);
                        alert(errorMsg);
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    providerValChngHelper : function(component, event, helper) {
        debugger;
        var sessionList = component.get("v.ncpSessionList");
        var selectedProvider = component.get("v.selecteProvider");
        var selectedproviderSessionList = [];
        for(var ele in sessionList){
            if(sessionList[ele].Provider_Name__c == selectedProvider){
                if(sessionList[ele].Session_ID__c.indexOf('EWK') == -1){
                    selectedproviderSessionList.push(sessionList[ele]);
                }
            }
        }
        component.set("v.sessionProviderList",selectedproviderSessionList);
        console.log( JSON.stringify(component.get("v.sessionProviderList")));
    },
    
    findCreditValHelper : function(component, event, helper) {
        var sessionList = component.get("v.ncpSessionList");
        var selectedProvider = component.get("v.selectsessionname");
        for(var ele in sessionList){
            if(sessionList[ele].Id == selectedProvider){
                component.set("v.creditValue",sessionList[ele].Credit_Val__c);
            }
        }
    },
    
    saveNCPCreditRecHelper : function(component, event, helper) {
        component.set("v.displaySpinner",true);
        debugger;
        var action = component.get("c.createNCP_CreditRec");
        console.log('1111'+ component.get("v.selectsessionname"));
        console.log('1111'+ JSON.stringify(component.get("v.selectsessionname")));
        console.log( '2222'+JSON.stringify(component.get("v.creditSeriesName")));
        console.log('333'+ JSON.stringify(component.get("v.creditsessionDate")));
        console.log( '444'+JSON.stringify(component.get("v.creditsessionpreiod")));
        console.log( '55'+JSON.stringify(component.get("v.speakercheckbox")));
        console.log( '55'+JSON.stringify(component.get("v.selecteProvider")));
        var speakerval = component.find("speakercheck").get("v.checked");
        action.setParams({
            "seccionRecId":component.get("v.selectsessionname"),
            "seriesNameVal":component.get("v.creditSeriesName"),
            //"creditsessionDateVal":component.get("v.creditsessionDate"),
            "creditsessionpreiodval":component.get("v.creditsessionpreiod"),
            "speakercheckboxval":speakerval,
            "providerName":component.get("v.selecteProvider"),
            "watchedDate":component.get("v.watchedDate"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displayNCPSessionModal",false);
            if (state === "SUCCESS") {
                
                //response.getReturnValue();
                component.set("v.displaySpinner",false);
                // alert('create');
                helper.doInitHelper(component, event, helper);
                //helper.showToastSuccess(component, event, helper,'NCP Credit Record is Create successfully.');
                //component.set("v.displayNCPSessionModal",false);
                helper.assignNullValue(component, event, helper);
                
                var ExAppEvent = $A.get("e.c:RefreshCreditTabs");
                // Set here event attribute value
                ExAppEvent.setParams({"tabName" : "creditstatus"});
                ExAppEvent.fire();
                
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    var errorMsg = JSON.stringify(errors);
                    alert(errors[0].message)                    
                    if (errors) {                        
                        var errorMsg = JSON.stringify(errors);                        
                        if (errors[0] && errors[0].message) {
                            component.set("v.displaySpinner",false);
                            component.find('toastMessage').showMessage('',errors[0].message,false,'error','top-center');                                                        
                            //helper.showToastSuccess(component, event, helper,errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    
    
    openNCPCreditPOPUPHelper : function(component, event, helper) {
        component.set("v.displaySpinner",true);
        debugger;
        var creditRec = {};
        creditRec.entryDate = '';
        creditRec.sessionDate = '';
        //creditRec.sessionPeriod = '';
        creditRec.providerName = '';
        creditRec.proiderphORemail = '';
        creditRec.sessiontype = '';
        creditRec.audityear = '';
        creditRec.speakerCheckbox = false;
        creditRec.sessiontitle = '';
        creditRec.sessionDes = '';
        creditRec.instructor = '';
        creditRec.instructortitle = '';
        creditRec.creditvalue = 0;
        creditRec.minuteofEDU = 0;
        component.set("v.ncPCreditRec",creditRec);
        //By this apex call get session type pickist vaue 
        var action = component.get("c.getPickListValuesIntoList");
        action.setParams({
            "objectName" : "NCP_Credits__c",
            "fieldName":"Session_Type__c"
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.sessintypelist",response.getReturnValue());
                component.set("v.displayNCPCreditModal",true);
                component.set("v.displaySpinner",false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();                    
                    if (errors) {
                        var errorMsg = JSON.stringify(errors);
                        alert(errorMsg);
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            component.set("v.displaySpinner",false);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            component.set("v.displaySpinner",false);
        });
        $A.enqueueAction(action);
        
    },
    
    
    saveNCPCreditMannaulRecHelper : function(component, event, helper) {
        debugger;
        var allValid = component.find('myinput').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        
        if(allValid){
            
            var speaker = component.find('speaker').get("v.checked");
            var credit = component.get("v.ncPCreditRec");
            credit.speakerCheckbox = speaker;
            component.set("v.ncPCreditRec",credit);
            component.set("v.displaySpinner",true);            
            console.log('ncPCreditRec :- '+JSON.stringify(component.get("v.ncPCreditRec")));
            var action = component.get("c.createNCPCreditManaulRec");
            action.setParams({
                "creditRecDetails" : component.get("v.ncPCreditRec")
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.displaySpinner",false);
                    //alert(response.getReturnValue());
                    helper.doInitHelper(component, event, helper);
                    component.set("v.displayNCPCreditModal",false);
                    component.set("v.crmanuualyrecId",response.getReturnValue());
                    
                    var ExAppEvent = $A.get("e.c:RefreshCreditTabs");
                    // Set here event attribute value
                    ExAppEvent.setParams({"tabName" : "creditstatus"});
                    ExAppEvent.fire();
                    
                    helper.uploadHelper(component, event);
                    component.set("v.fileName",'');
                    //helper.showToastSuccess(component, event, helper,'NCP Credit Record is Create successfully.');
                    
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            var errorMsg = JSON.stringify(errors);
                            alert(errors[0].message)
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                            component.set("v.displaySpinner",false);
                            component.set("v.displayNCPCreditModal",false);
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
    },
    
    
    updatenonappRec : function(component, event, helper) {
        debugger;
        component.set("v.displaySpinner",true);
        var action = component.get("c.updateNCPRecords");
        var rec = component.get("v.nonApprovencpRecSel");
        console.log("edit record",JSON.stringify(rec));
        action.setParams({
            "strRecVal" : JSON.stringify(rec)
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                helper.doInitHelper(component, event, helper);
                component.set("v.crmanuualyrecId",component.get("v.nonApprovencpRecSel").Id);
                //alert(component.get("v.nonApprovencpRecSel").Id);
                helper.uploadHelper(component, event);
                component.set("v.fileName",'');
                //helper.showToastSuccess(component, event, helper,'Record update Successfully.');
                component.set("v.nonApprovencpRecSelmodal",false);
                component.set("v.displaySpinner",false);
                var ExAppEvent = $A.get("e.c:RefreshCreditTabs");
                // Set here event attribute value
                ExAppEvent.setParams({"tabName" : "creditstatus"});
                ExAppEvent.fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    var errorMsg = JSON.stringify(errors);
                    alert(errorMsg);
                    if (errors) {
                        //helper.showToastError(component, event, helper,JSON.stringify(errors[0].message));                        
                    } else {
                        console.log("Unknown error");
                    }
                }
            component.set("v.nonApprovencpRecSelmodal",false);
            component.set("v.displaySpinner",false);
        });
        $A.enqueueAction(action);
    },
    
    deleteRecHelper : function(component, event, helper) {
        debugger;
        component.set("v.displaySpinner",false);
        console.log("my rec val : ",component.get("v.deletedRec"));
        var action = component.get("c.deleteNCPRec");
        action.setParams({
            "RecId" : component.get("v.deletedRec")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.doInitHelper(component, event, helper);
                component.set("v.displaySpinner",false);
                //helper.showToastSuccess(component, event, helper,'Record delete Successfully.');
                component.set("v.deleteModal",false);
                var ExAppEvent = $A.get("e.c:RefreshCreditTabs");
                // Set here event attribute value
                ExAppEvent.setParams({"tabName" : "creditstatus"});
                ExAppEvent.fire();
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();                    
                    if (errors) {
                        var errorMsg = JSON.stringify(errors);
                        alert(errorMsg);
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            //helper.showToastError(component, event, helper,errors[0].message);
                            component.set("v.deleteModal",false);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            component.set("v.deleteModal",false);
            component.set("v.displaySpinner",false);
        });
        $A.enqueueAction(action);
    },
    
    assignNullValue : function(component, event, helper) {
        debugger;
        component.set("v.selectsessionname",''),
            component.set("v.creditSeriesName",''),
            component.set("v.creditsessionDate",null),
            component.set("v.creditsessionpreiod",null),
            component.set("v.speakercheckbox",''),
            component.set("v.selecteProvider",''),
            component.set("v.creditValue",0);
        component.set("v.fileName",'');
        
    },
    
    createNotesHelper : function(component, event, helper) {
        component.set("v.displaySpinner",true);
        debugger;
        var action = component.get("c.createNotes");
        action.setParams({
            "ttyl" :  component.get("v.notesTitle"),
            "descp" :  component.get("v.notesDes")
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displayNCPSessionModal",false);
            if (state === "SUCCESS") {
                component.set("v.displaySpinner",false);
                alert('notes create');
            }
            // handel the response errors        
            else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();                
                if (errors) {
                    var errorMsg = JSON.stringify(errors);
                    alert(errorMsg);
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        component.set("v.displaySpinner",false);
        component.set("v.displayNotesModal",false);
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    /**
    showToastSuccess : function(component, event, helper,msg) {
        debugger;
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Success',
                message: msg,
                duration:'5000',
                type: 'success'
            });
            toastEvent.fire();
        }catch(err){
            alert(msg);
        }
        
    },
    
    showToastError : function(component, event, helper,msg) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }catch(err){
            alert(msg);
        }
        
    },
    **/
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.Loading", true);
        
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
       	debugger; 
        if(fileInput){            
            
            // get the first file using array index[0]  
            var file = fileInput[0];
            var self = this;        
            
            // create a FileReader object 
            var objFileReader = new FileReader();
            
            // set onload function of FileReader object   
            objFileReader.onload = $A.getCallback(function() {
                var fileContents = objFileReader.result;
                var base64 = 'base64,';
                var dataStart = fileContents.indexOf(base64) + base64.length;
                
                fileContents = fileContents.substring(dataStart);
                // call the uploadProcess method 
                self.uploadProcess(component, file, fileContents);
            });
            
            objFileReader.readAsDataURL(file);
        }
    },
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.crmanuualyrecId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            component.set("v.displayNCPSessionModal",false);
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    alert('your File is uploaded successfully');
                    component.set("v.Loading", false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();                
                if (errors) {
                    var errorMsg = JSON.stringify(errors);
                    alert(errorMsg);
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }
})