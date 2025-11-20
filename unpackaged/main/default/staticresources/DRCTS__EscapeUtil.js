(function(root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.EscapeUtil = factory();
    }

}(this, function() {
    return {
        containsHtml : function(value) {
            return /<(?:a|b|br|button|col|form|i|iframe|img|input|label|li|link|p|script|select|span|strong|style|table|div|ul|ol|h[1-9])[^>]*>/gm.test(value);
        }
    }
}));
