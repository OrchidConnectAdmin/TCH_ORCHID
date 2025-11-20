({
	init : function(component, event, helper) {
		var rurl = component.get("v.rURL");
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        var regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
   		
        var durl = decodeURIComponent(rurl);
        var isURL = regexp.test(durl);
        
        console.log("IS URL", isURL, durl);
        location.replace(durl);
        
	}
})