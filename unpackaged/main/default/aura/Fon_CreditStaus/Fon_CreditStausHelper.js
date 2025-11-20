({
    fetchUserdetails : function(component, event, helper) {
        var action = component.get("c.fetchonLoadWrapper");    
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displaySpinner",false);
            if (state === "SUCCESS") {    
                console.log("LASTES ", response.getReturnValue().lastestProgProfile);
                component.set("v.userDetails",response.getReturnValue().userDetails);
                component.set("v.progProfile",response.getReturnValue().lastestProgProfile);
                 component.set("v.progProfileDetails",response.getReturnValue());
                console.log("PROG DETAILS ", response.getReturnValue());
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
    }
})