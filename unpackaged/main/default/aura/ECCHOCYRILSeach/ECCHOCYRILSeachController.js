({
	init : function(component, event, helper) {
		var url = new URL(window.location.href);
       	var sparam = url.searchParams.get("search");
        var skey = decodeURIComponent(sparam);
        if(skey.length > 0 && skey !== 'null'){
            console.log("SKEY",skey,skey.length);
            component.set("v.sstring",skey);
        }
	},
	Refresh : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
		var sstr = component.find("data-search").get("v.value");
        location.replace(baseURL + '/s/memberships?search='+sstr);
	}

})