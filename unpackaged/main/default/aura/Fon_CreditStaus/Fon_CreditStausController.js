({
	doInit : function(component, event, helper) {
        //alert('a');
        component.set("v.displaySpinner",true);
        helper.fetchUserdetails(component, event, helper);
    },
})