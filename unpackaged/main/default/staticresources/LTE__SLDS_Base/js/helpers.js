function validateForm(inputObj,component) {
    var isFormValid;
    for (var property in inputObj) {
        if (inputObj.hasOwnProperty(property)) {
            if (!component.find(property).validate()) {
                isFormValid = false;
            }
        }
    }
    if (isFormValid == undefined) {
        isFormValid = true;
    }
    return isFormValid;
}


;(function (root, factory) {

  if (typeof define === 'function' && define.amd) {
    define(factory);
  } else if (typeof exports === 'object') {
    module.exports = factory();
  } else {
    root.FontevaHelper = factory();
  }

}(this, function () {
  return {
       cacheItem : function(key,value,ttl) {
        if ($A.util.isEmpty(ttl)) {
            ttl = 100000;
        }
        sessionStorage.setItem(this.cachePrefix + '.' + key, JSON.stringify({
            cachedObj: value,
            insertDate: new Date(),
            ttl: ttl
        }));
    }
  };
}));
