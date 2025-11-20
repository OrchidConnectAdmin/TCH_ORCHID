(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.UrlUtil = factory();
    }

}(this, function () {
    return {
        navToSObject: function (sobjectId) {
            this.navToUrl('/' + sobjectId);
        },
        navToUrl: function (url) {
            this.navToUrl(url, null);
        },
        navToUrl: function (url, target) {
            if (!target) {
                target = '_self';
            }

            window.open(this.addSitePrefix(url), target);
        },
        addSitePrefix: function (url) {
            var systemPrefixes = ['apex', 's', 'one', 'profile','lightning'];
            var systemPrefix = false;
            var pathSegments = window.location.pathname.split('/');
            //if first element of the current path is not to be ignored, then it's a site prefix
            systemPrefixes.forEach(function (prefix) {
                if (pathSegments[1] === prefix) {
                    systemPrefix = true;
                }
            });

            if (systemPrefix) {
                return url;
            }
            else if (pathSegments.length >= 3) {
                if (pathSegments[1] !== '') {
                    return '/' + pathSegments[1] + url;
                }
                else {
                    return url;
                }
            } 
            else {
            	return url;
            }
        }
    }
}));
