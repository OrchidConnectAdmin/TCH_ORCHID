(function(root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.CustomFieldUtils = factory();
    }

}(this, function() {
    'use strict';
    return {
        saveFields : function (eventReturnObj,uniqueId,showAllFields) {
            var customFields = [];
            if (!$A.util.isEmpty(eventReturnObj) && eventReturnObj.uniqueId === uniqueId) {
                if (!$A.util.isEmpty(eventReturnObj.fields) && !$A.util.isEmpty(eventReturnObj.fields.layoutObjs)) {
                    eventReturnObj.fields.layoutObjs.forEach(function(element){
                        if (!$A.util.isEmpty(element.fields)) {
                            element.fields.forEach(function(field){
                                //TODO Uncomment this to work in your dev org for a specific field
//                                if (field.apiName.toLowerCase().indexOf('Custom_Text__c'.toLowerCase()) > -1 &&
//                                    field.apiName !== 'Name') {
//                                    customFields.push(field);
//                                }
                                if (field.apiName.toLowerCase().indexOf('EventApi__'.toLowerCase()) === -1 &&
                                    field.apiName.toLowerCase().indexOf('LTE__'.toLowerCase()) === -1 &&
                                    field.apiName !== 'Name' &&
                                    field.apiName !== 'CurrencyIsoCode' &&
                                    field.apiName.indexOf('__c') > -1) {
                                    customFields.push(field);
                                }
                            });
                        }
                    });
                }
            }
            return customFields;
        },
        saveAllFields : function (eventReturnObj,uniqueId,showAllFields) {
            var customFields = [];
            if (!$A.util.isEmpty(eventReturnObj) && eventReturnObj.uniqueId === uniqueId) {
                if (!$A.util.isEmpty(eventReturnObj.fields) && !$A.util.isEmpty(eventReturnObj.fields.layoutObjs)) {
                    eventReturnObj.fields.layoutObjs.forEach(function(element){
                        if (!$A.util.isEmpty(element.fields)) {
                            element.fields.forEach(function(field){
                                //TODO Uncomment this to work/replicate issue in your dev org for a specific field
                                // if (field.apiName.toLowerCase().indexOf('customfield'.toLowerCase()) > -1 &&
                                //     field.apiName !== 'Name') {
                                //     customFields.push(field);
                                // }
                                customFields.push(field);
                            });
                        }
                    });
                }
            }
            return customFields;
        },
        validateCustomFields : function(component,fieldAuraId) {
            var validated = true;
            var fields = component.find(fieldAuraId);
            if ($A.util.isEmpty(fields)) {
                return validated;
            }
            if (!$A.util.isArray(fields)) {
                fields = [fields];
            }
            fields.forEach(function(element){
                element.validate();
                if (!element.get('v.validated')) {
                    validated = false;
                }
            });
            return validated;
        },
        cleanUpCustomFields : function (customObjType) {
            if (!$A.util.isEmpty(customObjType.customFieldValues)) {
                for (var key in customObjType.customFieldValues) {
                    if (customObjType.customFieldValues.hasOwnProperty(key)) {
                        if (!$A.util.isEmpty(customObjType.customFieldValues[key]) &&
                            $A.util.isArray(customObjType.customFieldValues[key])) {
                            customObjType.customFieldValues[key] = customObjType.customFieldValues[key].join(';');
                        }
                    }
                }
            }
            return customObjType;
        },
        preFormatCustomFieldValues : function (customFields) {
            if (!$A.util.isEmpty(customFields)) {
                for (var key in customFields) {
                    if (customFields.hasOwnProperty(key)) {
                        if (!$A.util.isEmpty(customFields[key]) && customFields[key] === 'true') {
                            customFields[key] = true;
                        }
                    }
                }
            }
            return customFields;
        },
    }
}));
