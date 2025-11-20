(function(root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.UIApi = factory();
    }

}(this, function() {
    'use strict';
    return {
        getFieldsFromLayout: function(sessionId,objectName) {
            var url = "/services/data/v42.0/ui-api/layout/"+objectName;
            if (typeof UrlUtil !== 'undefined') {
                url = UrlUtil.addSitePrefix("/services/data/v42.0/ui-api/layout/"+objectName);
            }
            var request = new XMLHttpRequest();
            request.open("GET", url);
            request.setRequestHeader('Authorization', 'Bearer '+sessionId);
            request.send(null);
            return new Promise(function (resolve, reject) {
                request.onload = function (event) {
                    if (request.status !== 200) {
                        reject('Status Code '+request.status+' '+request.responseText);
                    }
                    else {
                        var layoutObjWrapper = {};
                        layoutObjWrapper.sObjectName = objectName;
                        layoutObjWrapper.layoutObjs = [];
                        try {
                            var layoutObj = JSON.parse(request.responseText);
                            if (layoutObj && layoutObj.sections) {
                                layoutObj.sections.forEach(function (section) {
                                    var objectLayoutObj = {
                                        heading: section.heading,
                                        fields: []
                                    };
                                    section.layoutRows.forEach(function (layoutRow) {
                                        layoutRow.layoutItems.forEach(function (layoutItem) {
                                            if (layoutItem.layoutComponents && layoutItem.layoutComponents.length > 0 &&
                                                layoutItem.layoutComponents[0].apiName && layoutItem.layoutComponents[0].apiName !== 'CreatedById'
                                                && layoutItem.layoutComponents[0].apiName !== 'LastModifiedById') {
                                                var apiName = layoutItem.layoutComponents[0].apiName;
                                                objectLayoutObj.fields.push({
                                                    objectName: objectName,
                                                    isEditable : layoutItem.editableForUpdate,
                                                    apiName: apiName,
                                                    required : layoutItem.required
                                                });
                                            }
                                        });
                                    });
                                    if (objectLayoutObj.fields && objectLayoutObj.fields.length > 0) {
                                        layoutObjWrapper.layoutObjs.push(objectLayoutObj);
                                    }
                                });
                            }
                            resolve(layoutObjWrapper);
                        }
                        catch (err) {
                            reject(err);
                        }
                    }
                }
            });
        }
    }
}));
