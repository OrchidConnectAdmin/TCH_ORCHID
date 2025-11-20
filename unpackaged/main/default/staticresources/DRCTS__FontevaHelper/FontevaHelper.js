(function(root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.FontevaHelper = factory();
    }

}(this, function() {
    return {
        getCookie: function(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        },
        setCookie : function(cname,value,days) {
            var expires = '';
            if (days) {
                var date = new Date();
                date.setTime(date.getTime()+(days*24*60*60*1000));
                expires = "; expires="+date.toGMTString();
            }
            document.cookie = cname+"="+value+expires+"; path=/;secure";
        },
        cacheItem: function(key, value, ttl) {
            if ($A.util.isEmpty(ttl)) {
                ttl = 100000;
            }
            sessionStorage.setItem(this.cachePrefix + '.' + key, JSON.stringify({
                cachedObj: value,
                insertDate: new Date(),
                ttl: ttl
            }));
        },
        clearCacheItem: function(key) {
            sessionStorage.removeItem(this.cachePrefix + '.' + key);
        },
        getCacheItem: function(key) {
            var cachedObj = sessionStorage.getItem(this.cachePrefix + '.' + key);
            if (!$A.util.isEmpty(cachedObj)) {
                cachedObj = JSON.parse(cachedObj);
            }
            if (!$A.util.isEmpty(cachedObj) && (new Date() - Date.parse(cachedObj.insertDate)) < cachedObj.ttl) {
                return cachedObj.cachedObj;
            } else {
                this.clearCacheItem(key);
            }
            return null;
        },
        flushExpired: function() {
            for (var key in sessionStorage) {
                if (key.indexOf(this.cachePrefix) > -1 && (new Date() - Date.parse(cachedObj.insertDate)) > cachedObj.ttl) {
                    this.clearCacheItem(key);
                }
            }
        },
        flushAll: function() {
            for (var key in sessionStorage) {
                if (key.indexOf(this.cachePrefix) > -1) {
                    this.clearCacheItem(key);
                }
            }
        },
        getHashParam: function() {
            var sPageURL = decodeURIComponent(window.location.search.substring(1));
            sHashVariable = sPageURL.split('#');
            if (sHashVariable.length > 1) {
                return sHashVariable[1];
            }
        },
        getUrlParameter: function(paramName) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('#')[0].split('&'),
                sParameterName,
                i;
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');

                if (sParameterName[0] === paramName) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        },
        showErrorMessage: function(message,type,title) {
            if ($A.util.isEmpty(type)) {
                type = 'error';
            }
            if ($A.util.isEmpty(title)) {
                title = 'Error!';
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: title,
                message: message,
                type: type
            });
            toastEvent.fire();
        },
        showLoadedData : function(component) {
            $A.util.addClass(component.find('loading-span-stencil'),'stencil-hidden');
            setTimeout($A.getCallback(function(){
                $A.util.removeClass(component.find('mainData'),'stencil-hidden');
                $A.util.addClass(component.find('mainData'),'stencil-visible');
                $A.util.removeClass(component.find('buttons'),'stencil-hidden');
                $A.util.addClass(component.find('buttons'),'stencil-visible');
            }),100);
        },
        showComponent: function(component, componentName, params, divId,scrollToTop) {
            delete params['identifier'];
            $A.createComponent(componentName, params,
                function(cmp,status,message) {
                    if (status !== 'SUCCESS') {
                        console.log(status,message);
                        console.log('Name',componentName);
                        console.log('Params',params);
                    }
                    var divComponent = component.find(divId);
                    divComponent.set("v.body", [cmp]);
                    if (!$A.util.isEmpty(scrollToTop)) {
                        document.body.scrollTop = document.documentElement.scrollTop = 0;
                    }
                });
        },
        disableBodyScroll : function() {
            document.body.classList.add('noscroll');
        },
        enableBodyScroll : function() {
            document.body.classList.remove('noscroll');
        }
    }
}));
