({
    initDataTable : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.bURL", baseURL);
        
        let url = document.URL;
        
        if(url.indexOf('sitepreview') > 0 
            || url.indexOf('livepreview') > 0
            || url.indexOf('live-preview') > 0 
            || url.indexOf('live.') > 0
           || url.indexOf('.builder.') > 0){
            component.set("v.isPreview", true);
        }
        
        
        // get id

        helper.fetchDataHelper(component, event, helper);

        
    }
})