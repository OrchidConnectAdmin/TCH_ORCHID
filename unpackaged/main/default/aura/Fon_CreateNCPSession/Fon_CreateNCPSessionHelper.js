({
    handleOnLoad : function(component, event, helper) {
        //debugger;
        
        var action = component.get("c.handleComponentLoad");    
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displaySpinner",false);
            if (state === "SUCCESS") {                
                component.set("v.NCPSession",response.getReturnValue().lstSession);
                component.set("v.Applciation",response.getReturnValue().applicationRecord);
                component.set("v.SO",response.getReturnValue().salesOrderRecord);
                component.set("v.contactId",response.getReturnValue().conId);
                component.set("v.AccountId",response.getReturnValue().AccountId);
                //alert(response.getReturnValue().salesOrderRecord.Id);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
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
    
    createsaleodrlineHelper : function(component, event, helper) {
        debugger;
        component.set("v.displaySpinner",true);
        var action = component.get("c.createSalesOrderLines");
        action.setParams({
            "sORec" : component.get("v.SO")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displaySpinner",false);
            if (state === "SUCCESS") { 
                component.set("v.displaySpinner",false);
                alert('Please Wait !!');
                var communityUrl = $A.get("$Label.c.Community_Url");
                var encodesUrl = encodeURIComponent(communityUrl+'ce-credits');
                var finalUrlVAl = communityUrl + '#/store/checkout/'+ component.get("v.SO.Id")+'/'+encodesUrl;
                console.log('finalUrlVAl : '+finalUrlVAl);
                window.location.href = finalUrlVAl;
            }
            else if (state === "INCOMPLETE") {
                component.set("v.displaySpinner",false);
                // do something
            }
                else if (state === "ERROR") {
                    component.set("v.displaySpinner",false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                        component.set("v.displaySpinner",false);
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    cloneRecHelper : function(component,event,helper,sessVal){
        debugger;
        var action = component.get("c.createCloneNCPSession"); 
        action.setParams({
            "sess" : sessVal
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.disableSave",false);
            component.set("v.displaySpinner",false);
            debugger;
            if (state === "SUCCESS") { 
                component.set("v.displayCreateModal",false);
                helper.handleOnLoad(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
                component.set("v.displayCreateModal",false);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            component.set("v.displayCreateModal",false);
        });
        $A.enqueueAction(action);
    },
    setMaxLength : function(component) {
        // delay until the DOM exists
        window.setTimeout($A.getCallback(function() {
            const descField = component.find("desc");
            if (!descField) { return; }

            const inp = descField.getElement().querySelector("input, textarea");
            if (inp) {
                inp.setAttribute("maxlength", component.get("v.maxLength"));
            }
        }), 0);
    },
    attachLiveCharLimiter : function(component) {
        setTimeout($A.getCallback(function () {
            const field = component.find("desc");
            if (!field) return;

            const el = field.getElement().querySelector("input, textarea");
            if (!el) return;

            const max = component.get("v.maxLength");

            // ✅ Block typing beyond 250
            el.addEventListener("keydown", function (e) {
                const allowed = ['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab'];
                const atLimit = el.value.length >= max;

                const isReplacing = el.selectionStart !== el.selectionEnd;

                if (atLimit && !isReplacing && !allowed.includes(e.key)) {
                    e.preventDefault();
                }
            });

            // ✅ Trim pasted input if too long
            el.addEventListener("input", $A.getCallback(function (e) {
                if (el.value.length > max) {
                    el.value = el.value.substring(0, max);
                }
                component.set("v.charCount", el.value.length);

                // Red border visual cue
                el.style.border = el.value.length >= max
                    ? '1px solid red'
                    : '';
            }));
        }), 0);
    },
    setupCharacterLimit : function(component) {
        window.setTimeout($A.getCallback(function () {
            const inputField = component.find("desc");
            if (!inputField) return;

            const el = inputField.getElement().querySelector("input, textarea");
            if (!el) return;

            const max = component.get("v.maxLength");

            // ✅ Live character blocking during typing
            el.addEventListener("keydown", function(e) {
                const allowedKeys = [
                    'Backspace', 'Delete', 'ArrowLeft', 'ArrowRight',
                    'ArrowUp', 'ArrowDown', 'Tab', 'Home', 'End'
                ];

                const isModifierKey = e.ctrlKey || e.metaKey || e.altKey;
                const isNavigational = allowedKeys.includes(e.key);

                const isOverLimit = el.value.length >= max;
                const hasSelection = el.selectionStart !== el.selectionEnd;

                if (isOverLimit && !hasSelection && !isNavigational && !isModifierKey) {
                    e.preventDefault();
                }
            });

            // ✅ Paste / programmatic input handling
            el.addEventListener("input", $A.getCallback(function(e) {
                if (el.value.length > max) {
                    el.value = el.value.substring(0, max);
                }

                // Update counter
                component.set("v.charCount", el.value.length);

                // Optional red border when full
                el.style.border = (el.value.length >= max)
                    ? '1px solid red'
                    : '';
            }));
        }), 0);
    },
    enforceMaxTextarea: function(component) {
        window.setTimeout($A.getCallback(function () {
            const fld = component.find("desc");
            if (!fld) return;

            const textarea = fld.getElement().querySelector("textarea");
            console.log("textarea",textarea);
            if (!textarea) return;

            const max = component.get("v.maxLength");

            // Manually block typing beyond 250
            textarea.addEventListener("keydown", function(e) {
                const allowedKeys = [
                    'Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'ArrowUp', 
                    'ArrowDown', 'Tab', 'Home', 'End'
                ];
                const isModifier = e.ctrlKey || e.metaKey || e.altKey;
                const hasSelection = textarea.selectionStart !== textarea.selectionEnd;
                const atLimit = textarea.value.length >= max;

                if (atLimit && !hasSelection && !allowedKeys.includes(e.key) && !isModifier) {
                    e.preventDefault();
                }
            });

            // Enforce trimming after paste
            textarea.addEventListener("input", $A.getCallback(function() {
                let val = textarea.value;
                if (val.length > max) {
                    val = val.substring(0, max);
                    textarea.value = val;
                }

                component.set("v.charCount", val.length);

                // Optional: red border if limit reached
                textarea.style.border = val.length >= max ? "1px solid red" : "";
            }));
        }), 0);
    }
})