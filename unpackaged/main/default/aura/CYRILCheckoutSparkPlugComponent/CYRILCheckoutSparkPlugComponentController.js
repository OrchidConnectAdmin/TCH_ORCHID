({
    doInit : function(component, event, helper) {
        var compEvent = $A.get('e.FDService:SparkPlugLoadedEvent');
        compEvent.setParams({extensionPoint : component.get('v.extensionPoint')});
        compEvent.fire();
        
		let data = component.get('v.data');
        console.log("data",data);
        

        
    }
})