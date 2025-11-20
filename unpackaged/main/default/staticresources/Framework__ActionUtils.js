(function(root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.AU = root.ActionUtils = factory();
    }

}(this, function() {
    'use strict';

    //utility class to wrap calls with $A.getCallback
    function AuraPromise(executor) {
        this.innerPromise = new Promise(executor);
    }

    AuraPromise.prototype.catch = function (onError) {
        this.innerPromise = this.innerPromise.catch($A.getCallback(onError));
        return this;
    };

    AuraPromise.prototype.finally = function (onFinally) {
        // polyfill for IE11 .finally()
        const IE11PolyfillFinally = function(callback) {
            // ensure that the callback is a function, else create an empty function
            callback = callback instanceof Function ? callback: function(){}

            const lastPromiseInChain = function() {
                // get a reference to the last Promise/thenable right before having called .finally()
                return this;
            }.bind(this) //ensure the original calling context is bound

            const decoratedCallback = function() {
                // run the callback passed into .finally()
                // then return the reference to the last Promise/thenable right before having called .finally() to preserve the resolved value or rejected reason
                return AuraPromise.resolve(callback()).then(lastPromiseInChain);
            }

            // run .finally() as a .then() that invokes the decorated callback for both its resolve and reject functions
            // and return a Promise
            return this.then(decoratedCallback,decoratedCallback);
        };

        // if .finally() does not natively exist, then polyfill it using the above IE11 polyfill
        if(!Promise.prototype.hasOwnProperty('finally')) {
            Promise.prototype.finally = IE11PolyfillFinally;
        }

        this.innerPromise = this.innerPromise.finally($A.getCallback(onFinally));
        return this;
    };

    AuraPromise.prototype.then = function (resolve, reject) {
        this.innerPromise = this.innerPromise.then(resolve ? $A.getCallback(resolve) : null, reject ? $A.getCallback(reject) : null);
        return this;
    };

    return {
        executeAction: function (self, cmp, action, params, forceBase) {
            params = params || {};
            //check cookie or whatever to see if caching enabled
            var useCanned = sessionStorage.getItem('mock');
            var scenario = sessionStorage.getItem('scenario');
            if (scenario === 'false' || scenario == null) scenario = false; //sessionStorage returns Strings
            if (useCanned) {
                return new AuraPromise(function (resolve, reject) {
                    var xhr = new XMLHttpRequest();

                    var onload = $A.getCallback(function (oEvent) {
                        if (parseInt(xhr.status / 100) === 2 || xhr.response === 304) {
                            return resolve(JSON.parse(xhr.response));
                        }
                        else if (scenario || !forceBase) { //scenario failed. Recurse w/ base case
                            return AU.executeAction(self, cmp, action, params, true).then(resolve, reject);
                        }
                        else { //All mock data failed. Call the server action.
                            return AU._executeAction(self, cmp, action, params).then(resolve, reject);
                        }
                    });

                    if (scenario && !forceBase) {
                        scenario = '.' + scenario;
                    }
                    else {
                        scenario = '';
                    }
                    xhr.open("GET", "https://fonteva.github.io/mockData/2018-R2/" + action.substring(2) + scenario + ".json?cachebuster=" + Date.now());
                    xhr.onload = onload;
                    xhr.send();
                }.bind(self));
            }

            //otherwise delegate to action utils
            return AU._executeAction(self, cmp, action, params);
        },
        _executeAction : function(self,cmp,actionName,params) {
            //caching!!
            var debug = sessionStorage.getItem('fon.log');
            var verbose = debug === "debug";

            var cacheKey = params.cacheKey;
            var invalidateKey = params.invalidateKey;
            delete params.cacheKey;
            delete params.invalidateKey;

            if (invalidateKey) {
                if (verbose) console.log('Invalidating cacheKey: ' + invalidateKey);
                sessionStorage.removeItem(invalidateKey);
            }

            if (cacheKey && sessionStorage.getItem(cacheKey)) {
                if (debug) console.groupCollapsed(actionName + " <" + cmp.getName() + "/> cache hit");
                if (verbose) console.log(JSON.stringify(sessionStorage.getItem(cacheKey), null, "  "));
                if (debug) console.groupEnd();
                return new AuraPromise(function (resolve) {
                    resolve(JSON.parse(sessionStorage.getItem(cacheKey)));
                })
            }

            //test to see if we're in pure mock mode and the code hasn't been written
            //and fail gracefully if we are. This means we will run .catch() and .finally() blocks
            //old code was just throwing
            var action;
            try {
                action = cmp.get(actionName);
            }
            catch (error) {
                return new AuraPromise(function (resolve, reject) {
                    reject(error);
                });
            }

            var trace = Error().stack;
            return new AuraPromise(function (resolve, reject) {
                //find all params that are actually promises
                var paramPromises = Object.keys(params)
                    .filter(function(k){ return params[k] instanceof Promise || params[k] instanceof AuraPromise; })
                    .map(function(k) { return params[k]; });
                //resolve all the promises
                Promise.all(paramPromises).then(function (values) {

                    //update `params` object with resolved values
                    Object.keys(params)
                        .filter(function (k) { return params[k] instanceof Promise || params[k] instanceof AuraPromise; })
                        .forEach(function(k) { params[k] = values.shift(); });
                    const customError = params.customError || false;
                    delete params.customError;
                    const retryOnLockError = params.retryOnLockError || false;
                    delete params.retryOnLockError;
                    const retryOnLockCount = params.retryOnLockCount || 4;
                    delete params.retryOnLockCount;
                    const retryOnLockDelay = params.retryOnLockDelay || 3000;
                    delete params.retryOnLockDelay;

                    let retryOnLockAttempts = 0;

                    delete params.retryOnLockDelay;

                    action.setParams(params);
                    action.setCallback(self, function (response) {

                        const state = response.getState();
                        const retVal = response.getReturnValue();
                        if (state === "SUCCESS" && (!retVal || !retVal.sysLog)) { //Aura call can succeed, but we have a structured error obj. See classes/AuraBase.clss
                            if (debug) console.groupCollapsed(actionName + " <" + cmp.getName() + "/>");

                            if (verbose) console.groupCollapsed("stack trace");
                            if (verbose) console.log(trace);
                            if (verbose) console.groupEnd();

                            if (verbose) console.groupCollapsed("action parameters");
                            if (verbose) console.log(JSON.stringify(params, null, "  "));
                            if (verbose) console.groupEnd();


                            if (verbose) console.groupCollapsed("return value");
                            if (verbose) console.log(JSON.stringify(retVal, null, "  "));
                            if (verbose) console.groupEnd();

                            if (cacheKey) {
                                if (verbose) console.log("Caching value as '" + cacheKey + "'");
                                sessionStorage.setItem(cacheKey, JSON.stringify(retVal));
                            }

                            if (debug) console.groupEnd();
                            resolve(retVal);
                        }
                        else if (state === "ERROR" || (state === "SUCCESS" && retVal && retVal.sysLog)) {
                            // everything here is to abstract away any difference between
                            // * an Aura call that threw an exception
                            // * an Aura call that succeeded, but returned a SyslogException
                            // callers will see them identically
                            if (debug) console.groupCollapsed(actionName + " <" + cmp.getName() + "/> Failed!");

                            const errors = response.getError();
                            let errMsg = '';
                            let errObj = {};
                            if (state === "SUCCESS") {
                                errObj = retVal;
                                errMsg = retVal.message;
                            }
                            if (errors[0] && errors[0].message) {
                                errObj = AU.safeParse(errors[0].message);
                                if (errObj) {
                                    errMsg = errObj.message;
                                }
                                else {
                                    errMsg = errors[0].message;
                                    errObj = { message: errors[0].message };
                                }
                            }
                            if (!customError && (errObj || errMsg)) {
                                AU.showErrorMessage(cmp, errObj || errMsg);
                            }
                            console.log("Error calling `" + actionName + "`: " + errMsg);
                            console.log(errObj);

                            if (errObj.isLockError && retryOnLockError && retryOnLockAttempts < retryOnLockCount) {
                                retryOnLockAttempts++;
                                setTimeout($A.getCallback(function() {
                                    $A.enqueueAction(action);
                                }), retryOnLockDelay);
                                return;
                            }

                            reject(customError
                                ? errObj
                                : "Error calling `" + actionName + "`: " + errMsg);

                            if (verbose) console.groupCollapsed("action parameters");
                            if (verbose) console.log(JSON.stringify(params, null, "  "));
                            if (verbose) console.groupEnd();

                            if (debug) console.groupEnd();
                        }
                        else {
                            const message = "Unknown error calling `" + actionName + "`";
                            reject(customError
                                ? { message: message}
                                : message);
                            console.log(message);
                        }
                    });
                    $A.enqueueAction(action);
                });
            });
        },
        // executeStorableAction : function(self,cmp, action,params,callback) {
        //     var action = cmp.get(action);
        //     action.setParams(params);
        //     action.setCallback(this, function(response) {
        //         var state = response.getState();
        //         if (state === "SUCCESS") {
        //             var retVal = response.getReturnValue();
        //             resolve(retVal);
        //         }
        //         else if (state === "ERROR") {
        //             var errors = response.getError();
        //             if (errors) {
        //                 if (errors[0] && errors[0].message) {
        //                     this.showErrorMessage(cmp,errors[0].message);
        //                     reject(Error("Error message: " + errors[0].message));
        //                 }
        //             }
        //             else {
        //                 reject(Error("Unknown error"));
        //             }
        //         }
        //     });
        //     action.setStorable();
        //     $A.enqueueAction(action);
        // },
        safeParse: function(messageOrJSON) {
            try {
                return JSON.parse(messageOrJSON);
            }
            catch (err) {
                return null;
            }
        },
        showErrorMessage: function (cmp, messageOrErrorObject) {
            var type = 'error';
            var title = 'Error';
            var message = messageOrErrorObject.message ? messageOrErrorObject.message : messageOrErrorObject;
            var sysLog = messageOrErrorObject.sysLog;

            var toastEvent = $A.get("e.force:showToast");
            if (toastEvent) {
                toastEvent.setParams({
                    title: title,
                    message: message,
                    type: type
                });
                toastEvent.fire();
            }
            else {
                // var cmps = cmp.find('{instancesOf: "c:Toast"}');
                var cmps = cmp.find('toast') || cmp.find('toastMessages');
                var targetCmp = cmps instanceof Array
                    ? cmps.length > 0 ? cmps[0] : null
                    : cmps;
                if (targetCmp) {
                    targetCmp.showMessage(title, message, false, type);
                } else {
                    console.log(title, message);
                }
            }
        },
        generateId : function (len) {
            var text = "";
            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

            for( var i=0; i < len; i++ ) {
                text += possible.charAt(Math.floor(Math.random() * possible.length));
            }

            return text;
        }
    }
}));
