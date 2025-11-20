({
    initDataTable : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.bURL", baseURL);
        helper.fetchDataHelper(component, event, helper);    
    }
})