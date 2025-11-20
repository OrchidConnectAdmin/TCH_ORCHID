(function (root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        if (root.FH) { //don't overwrite LTE.FontevaHelper
            return;
        }
        root.FH = root.FontevaHelper = factory();

        function AuraPromise(executor) {
            if (executor) {
                this.innerPromise = new Promise(executor);
            }
        }

        AuraPromise.all = function (promises) {
            var auraPromise = new AuraPromise();
            auraPromise.innerPromise = Promise.all(promises);
            return auraPromise;
        };

        AuraPromise.prototype.catch = function (onError) {
            this.innerPromise = this.innerPromise.catch($A.getCallback(onError));
            return this;
        };

        AuraPromise.prototype.finally = function (onFinally) {
            this.innerPromise = this.innerPromise.finally($A.getCallback(onFinally));
            return this;
        };

        AuraPromise.prototype.then = function (resolve, reject) {
            this.innerPromise = this.innerPromise.then(resolve ? $A.getCallback(resolve) : null, reject ? $A.getCallback(reject) : null);
            return this;
        };
        root.AuraPromise = AuraPromise;

        Array.prototype.last = function() {
            return this.length > 0 ? this[this.length-1] : undefined;
        };

        Array.prototype.excludes = function(valueToFind, fromIndex) {
            return !this.includes(valueToFind, fromIndex);
        };

        Array.prototype.zipWith = function(otherArray, callback) {
            let otherCopy = otherArray instanceof Array
                ? JSON.parse(JSON.stringify(otherArray))
                : Array(this.length).fill(otherArray);

            return this.map(function(item) {
                return callback(item, otherCopy.shift());
            })
        }
    }

}(this, function () {
    return {
        cachePrefix: 'fonteva',
        showToastFor: 'fonteva',
        _portalData: null,
        ROUTINGPATH: {
            getCurrentWindowHash: function () {
                return window.location.hash.substr(1);
            },
            EVENTREG: {
                OVERVIEW: '/Overview',
                TICKETS: '/reg/tickets',
                TICKETASSIGNMENT: '/reg/ticketAssignment',
                NEWATTENDEE: '/reg/newAttendee',
                SELECTATTENDEE: '/reg/selectAttendee',
                SEATING: '/reg/seating',
                AGENDA: '/reg/agenda',
                NEWSESSION: '/reg/newSession',
                RECOMMENDED: '/reg/recommended',
                CHECKOUT: '/reg/checkout'

            }
        },
        notEmpty: function (value) {
            return !$A.util.isEmpty(value);
        },
        getCookie: function (cname) {
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
        setCookie: function (cname, value, days) {
            var expires = '';
            if (days) {
                var date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                expires = "; expires=" + date.toGMTString();
            }
            document.cookie = cname + "=" + value + expires + "; path=/;secure";
        },
        cacheItem: function (key, value, ttl) {
            if ($A.util.isEmpty(ttl)) {
                ttl = 100000;
            }
            sessionStorage.setItem(this.cachePrefix + '.' + key, JSON.stringify({
                cachedObj: value,
                insertDate: new Date(),
                ttl: ttl
            }));
        },
        clearCacheItem: function (key) {
            sessionStorage.removeItem(this.cachePrefix + '.' + key);
        },
        getCacheItem: function (key) {
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
        flushExpired: function () {
            for (var key in sessionStorage) {
                if (key.indexOf(this.cachePrefix) > -1 && (new Date() - Date.parse(cachedObj.insertDate)) > cachedObj.ttl) {
                    sessionStorage.removeItem(key);
                }
            }
        },
        flushAll: function () {
            for (var key in sessionStorage) {
                if (key.indexOf(this.cachePrefix) > -1) {
                    sessionStorage.removeItem(key);
                }
            }
        },
        getHashParam: function () {
            var sPageURL = decodeURIComponent(window.location.search.substring(1));
            sHashVariable = sPageURL.split('#');
            if (sHashVariable.length > 1) {
                return sHashVariable[1];
            }
        },
        setQueryParamsAndHash: function (queryParams, hash) {
            return window.location.protocol + '//' + window.location.host + window.location.pathname + '?'
                + Object.keys(queryParams).map(function (k) {
                    return k + '=' + queryParams[k]
                }).join('&') + '#' + hash;
        },
        getQueryParams: function () {
            var params = {};
            window.location.search.split('&').forEach(function (keyval) {
                var parts = (keyval[0] === '?' ? keyval.substr(1) : keyval).split('=');
                params[parts[0]] = parts.length > 1 ? parts[1] : null;
            });
            return params;
        },
        getQueryParam: function (paramName) {
            const urlParameter = FH.getUrlParameter(paramName);
            return urlParameter === "" ? true : urlParameter;
        },
        getUrlParameter: function (paramName) {
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
        getUrlVars: function () {
            var vars = {}, hash;
            var query_string = window.location.search;

            if (query_string) {
                var hashes = query_string.slice(1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars[hash[0]] = hash[1];
                }

                return vars;
            } else {
                return false;
            }
        },
        showErrorMessage: function (message, type, title) {
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
        showMainData: function () {
            var loader = document.getElementById('mainLoader');
            if (loader)
                loader.classList.add('slds-hide');

            var content = document.getElementById('mainContent');
            if (content)
                content.classList.remove('slds-hide');
        },
        showLoadedData: function (component) {
            $A.util.addClass(component.find('loading-span-stencil'), 'stencil-hidden');
            setTimeout($A.getCallback(function () {
                $A.util.removeClass(component.find('mainData'), 'stencil-hidden');
                $A.util.addClass(component.find('mainData'), 'stencil-visible');
                $A.util.removeClass(component.find('buttons'), 'stencil-hidden');
                $A.util.addClass(component.find('buttons'), 'stencil-visible');
            }), 100);
        },
        showComponent: function (component, componentName, params, divId, scrollToTop) {
            $A.createComponent(componentName, params,
                function (cmp, status, message) {
                    if (status !== 'SUCCESS') {
                        console.log(status, message);
                        console.log('Name', componentName);
                        console.log('Params', params);
                    }
                    var divComponent = component.find(divId);
                    divComponent.set("v.body", [cmp]);
                    if (!$A.util.isEmpty(scrollToTop)) {
                        document.body.scrollTop = document.documentElement.scrollTop = 0;
                    }
                });
        },
        disableBodyScroll: function () {
            document.body.classList.add('noscroll');
        },
        enableBodyScroll: function () {
            document.body.classList.remove('noscroll');
        },
        getSalesOrderId: function (orgId) {
            var soCookie = FontevaHelper.getCookie('apex__' + orgId + '-fonteva-lightning-shopping-cart');
            return soCookie ? JSON.parse(soCookie).salesOrderId : null;
        },
        setSalesOrderId: function (orgId, soId) {
            if (soId === undefined) return; //blank out via null
            var soCookieStr = FontevaHelper.getCookie('apex__' + orgId + '-fonteva-lightning-shopping-cart');
            var soCookie = soCookieStr ? JSON.parse(soCookieStr) : {};
            soCookie.salesOrderId = soId;
            FontevaHelper.setCookie('apex__' + orgId + '-fonteva-lightning-shopping-cart',
                JSON.stringify(soCookie), 1);
        },
        nullPromise: function () {
            return new AuraPromise(function (resolve) {
                resolve();
            });
        },
        fireComponentLoaded: function (cmp) {
            $A.get('e.LTE:ComponentLoadedEvent').fire({id: cmp.getLocalId(), name: cmp.getType().split(':')[1]})
        },
        createComponent: function (cmpName, params) {
            var debug = sessionStorage.getItem('fon.log');
            var verbose = debug === "debug";

            if (verbose) console.log('FontevaHelper creating: ' + cmpName);

            var self = this;

            return new AuraPromise(function (resolve, reject) {
                $A.createComponent(cmpName, params, function (cmp, status, message) {
                    if (status !== 'SUCCESS') {
                        self.showErrorMessage('Unable to create ' + cmpName + ' -- ' + message);
                        reject(message);
                    }
                    resolve(cmp);
                });
            })
        },
        createComponents: function (params) {
            var debug = sessionStorage.getItem('fon.log');
            var verbose = debug === "debug";

            let cmpNames = params.map(function(createArray) {return createArray[0]; }).join(',');
            if (verbose) {
                console.log('FontevaHelper creating comps: ' + cmpNames);
            }

            var self = this;

            return new AuraPromise(function (resolve, reject) {
                $A.createComponents(params, function (cmp, status, message) {
                    if (status !== 'SUCCESS') {
                        self.showErrorMessage('Unable to create ' + cmpNames + ' -- ' + message);
                        reject(message);
                    }
                    resolve(cmp);
                });
            })
        },
        waitForComponent: function (cmp, auraId) {
            var foundCmp = cmp.find(auraId);
            if (foundCmp) {
                return new AuraPromise(function (resolve) {
                    resolve(foundCmp);
                })
            }

            return new AuraPromise(function (resolve) {
                var interval = setInterval($A.getCallback(function () {
                    var foundCmp = cmp.find(auraId);
                    if (foundCmp) {
                        clearInterval(interval);
                        resolve(foundCmp);
                    }
                }), 50);
            })
        },
        find: function (cmp, auraId) {
            var cmps = cmp.find(auraId);
            if (!cmps) {
                FH.debug("No components found with aura:id " + auraId);
                return [];
            }
            if (!(cmps instanceof Array)) {
                cmps = [cmps];
            }

            return cmps;
        },
        addClass: function (ele, clazz) {
            $A.util.addClass(ele, clazz);
        },
        removeClass: function (ele, clazz) {
            $A.util.removeClass(ele, clazz);
        },
        toggleClass: function (ele, clazz) {
            $A.util.toggleClass(ele, clazz);
        },
        hasClass: function (ele, clazz) {
            return $A.util.hasClass(ele, clazz);
        },
        setPortalData: function (portalData) {
            FH._portalData = portalData;
        },
        clone: function(data) {
            return JSON.parse(JSON.stringify(data));
        },
        waitForDataPromise: function (portalDataField) {
            if (FH._portalData) {
                return new AuraPromise(function (resolve) {
                    FH._portalData.getPromise(portalDataField)
                        .then($A.getCallback(function (value) {
                            resolve(value);
                        }))
                });
            }

            return new AuraPromise(function (resolve) {
                var interval = setInterval($A.getCallback(function () {
                    if (FH._portalData) {
                        clearInterval(interval);
                        FH._portalData.getPromise(portalDataField)
                            .then($A.getCallback(function (value) {
                                resolve(value);
                            }))
                    }
                }), 50);
            })
        },
        waitForData: function (cmp, fieldName) {
            fieldName = fieldName || 'v.data';

            var data = cmp.get(fieldName);
            if (data) {
                return new AuraPromise(function (resolve) {
                    resolve(data);
                });
            }

            return new AuraPromise(function (resolve) {
                var interval = setInterval($A.getCallback(function () {
                    var data = cmp.get(fieldName);
                    if (data) {
                        clearInterval(interval);
                        resolve(data);
                    }
                }), 50);
            })
        },
        error: function (message) {
            // eslint-disable-next-line no-console
            console.log(message);
        },
        verbose: function (message) {
            var logLevel = sessionStorage.getItem('fon.log');
            if (logLevel === 'verbose' || logLevel === 'v' || logLevel === 'vv' || logLevel === 'vvv') {
                // eslint-disable-next-line no-console
                console.log(message);
            }
        },
        debug: function (message) {
            var logLevel = sessionStorage.getItem('fon.log');
            if (logLevel === 'debug' || logLevel === 'verbose' || logLevel === 'v' || logLevel === 'vv' || logLevel === 'vvv') {
                // eslint-disable-next-line no-console
                console.log(message);
            }
        },
        safely: function(callback) {
             var trace = Error().stack;
            try {
                callback();
            }
            catch (err) {
                FH.error('Caught Exception: ' + err);
                FH.error(trace);
            }
        },
        waitForDomUpdate: function(callback) {
            setTimeout($A.getCallback(function() { //allow the DOM to update
                callback();
            }), 1);
        },
        Login: {
            buildFieldsetInputs: function(fields, divComponent, valueObj) {
                fields.forEach(function(field) {
                    if (field.fieldId === 'LastName' || field.fieldId === 'FirstName' ||
                        field.fieldId === 'Email') {
                        return;
                    }
                    var otherAttributes = {};
                    if (field.fieldType.toLowerCase() === 'picklist') {
                        otherAttributes.objectName = 'Contact';
                        if (field.isDependentField) {
                            otherAttributes.dependentField = field.fieldId;
                            otherAttributes.parentControllingFieldKey = field.controllingField;
                        }
                        else {
                            otherAttributes.field = field.fieldId;
                            otherAttributes.controllingFieldKey = field.fieldId;
                        }
                    }
                    FH.createComponent('markup://Framework:InputFields', {
                            group: 'guestForm',
                            fieldType: field.fieldType,
                            'aura:id': field.fieldId,
                            isRequired: field.isRequired,
                            label: field.fieldLabel,
                            value: valueObj,
                            otherAttributes: otherAttributes
                        })
                        .then(function(newCmp) {
                            newCmp.set('v.value', valueObj);
                            divComponent.set('v.body', divComponent.get('v.body').concat(newCmp));
                        });
                });
            }
        },
        Events: {
            initializeContactLookupField: function(cmp, soLine, label,isDisabled, contactIdsOnThisOrder, lookupIndex, onCreateCallback) {
                var event = cmp.get('v.eventObj');
                var filter = 'Id ';
                if (event.enableContactSearch) {
                    filter += '!= null AND OrderApi__Privacy_Settings__c ';
                    if (cmp.get('v.isAuthenticated') && !cmp.get('v.isGuest')) {
                        filter += '!= \'unlisted\' ';
                    }
                    else {
                        filter += '= \'public\' ';
                    }
                    if (!event.searchAllContacts && !$A.util.isEmpty(cmp.get('v.accountId'))) {
                        filter += ' AND accountId = \'' + cmp.get('v.accountId') + '\' ';
                    }

                    if (cmp.get('v.eventObj.enableContactRestriction')) {
                        var existingAttendeeContactIds = _.cloneDeep(cmp.get('v.eventObj.existingAttendeeContactIds'));
                        if (contactIdsOnThisOrder) {
                            existingAttendeeContactIds = existingAttendeeContactIds.concat(contactIdsOnThisOrder); //concat does not change the original array. We should assign it back.
                        }
                        else {
                            if (cmp.get('v.salesOrderObj') && !$A.util.isEmpty(cmp.get('v.salesOrderObj').lines)) {
                                _.forEach(cmp.get('v.salesOrderObj').lines, function(line) {
                                    _.forEach(line.assignments, function(assignment) {
                                        if (!$A.util.isEmpty(assignment.contactId) && existingAttendeeContactIds.indexOf(assignment.contactId) <= -1) {
                                            existingAttendeeContactIds.push(assignment.contactId);
                                        }
                                    })
                                })
                            }
                        }
                        filter += ' AND Id NOT IN (\'' + existingAttendeeContactIds.join('\',\'') + '\')';
                    }
                }
                else {
                    filter += '= null';
                }
                var allowCreate = true;
                if (cmp.get('v.eventObj.enableContactRestriction') && !cmp.get('v.eventObj.createContactForAttendees')) {
                    allowCreate = false;
                }
                var fields = event.contactSearchFields;
                var fieldList = ['Name'];
                if (!$A.util.isEmpty(fields)) {
                    var fldList = fields.split(',');
                    fldList.forEach(function(element) {
                        if (element.trim().toLowerCase() !== 'name') {
                            fieldList.push(element.trim());
                        }
                    });
                }

                var otherAttributes = {
                    advanced: true,
                    enforceSharingRules: false,
                    concatenateLabel: true,
                    disabled : isDisabled,
                    types: {
                        Contact: {
                            fieldNames: fieldList,
                            filter: filter,
                            initialLoadFilter: filter + ' Order By LastModifiedDate ASC LIMIT 100'
                        },
                        OrderApi__Assignment__c: {
                            fieldNames: ['OrderApi__Full_Name__c', 'OrderApi__email__c'],
                            filter: 'Id = null',
                            initialLoadFilter: 'Id = null'
                        },
                        EventApi__Waitlist_Entry__c: {
                            fieldNames: ['EventApi__Full_Name__c', 'EventApi__Email__c'],
                            filter: 'Id = null',
                            initialLoadFilter: 'Id = null'
                        }
                    },
                    otherMethods: {
                        searchField: ['sObjectLabel', 'Name', 'Email', 'OrderApi__Preferred_Email__c'],
                        create: allowCreate,
                        render: {
                            option: function(item, escape) {
                                if (item.type === 'OrderApi__Assignment__c') {
                                    return '';
                                }
                                if (item.type === 'EventApi_Waitlist_Entry__c') {
                                    return '';
                                }
                                var lowerText = '';
                                if (!$A.util.isEmpty(fields)) {
                                    fieldList.forEach(function(element) {
                                        if (item.sObj.hasOwnProperty(element) &&
                                            !$A.util.isEmpty(item.sObj[element]) &&
                                            element.toLowerCase() !== 'name') {
                                            var elementToDisplay = item.sObj[element];
                                            if (lowerText === '') {
                                                if ($A.util.isObject(elementToDisplay)) {
                                                    lowerText = Object.values(elementToDisplay).join(', ');
                                                }
                                                else {
                                                    lowerText = elementToDisplay;
                                                }
                                            }
                                            else {
                                                if ($A.util.isObject(elementToDisplay)) {
                                                    lowerText += '&nbsp;&nbsp;' + '&bull;' + '&nbsp;&nbsp;' + escape(Object.values(elementToDisplay).join(', '));
                                                }
                                                else {
                                                    lowerText += '&nbsp;&nbsp;' + '&bull;' + '&nbsp;&nbsp;' + escape(elementToDisplay);
                                                }
                                            }
                                        }
                                    });
                                }
                                return '<div class="slds-grid">' +
                                    '<div class="slds-p-right--xx-small slds-shrink-none" style="height: 0;">' +
                                    '<img src="' + $A.get('$Resource.Framework__SLDS_Icons') +
                                    '/icons/utility/user_60.png" width="12"/>' +
                                    '</div>' +
                                    '<div class="slds-grid slds-wrap slds-size--1-of-1">' +
                                    '<div class="slds-col slds-size--1-of-1 slds-align-middle">' +
                                    '<strong style="line-height: 1.4;">' + escape(item.sObj.Name) + '</strong>' +
                                    '</div>' +
                                    '<div class="slds-col slds-size--1-of-1 slds-text-body--small">' +
                                    lowerText +
                                    '</div>' +
                                    '</div>' +
                                    '</div>';
                            },
                            item: function(item, escape) {
                                var returnHTML = '<div class="slds-position--absolute">' +
                                    '<img src="' + $A.get('$Resource.Framework__SLDS_Icons') +
                                    '/icons/utility/user_60.png" width="12" class="slds-m-right--xx-small"/>' +
                                    '<span class="slds-align-middle">';
                                if (item.type === 'OrderApi__Assignment__c') {
                                    returnHTML += escape(item.sObj.OrderApi__Full_Name__c);
                                }
                                else if (item.type === 'EventApi__Waitlist_Entry__c') {
                                    returnHTML += escape(item.sObj.EventApi__Full_Name__c);
                                }
                                else {
                                    returnHTML += escape(item.sObj.Name);
                                }
                                returnHTML += '</span>' +
                                    '</div>';
                                return returnHTML;
                            }
                        }
                    }
                };

                if (allowCreate) {
                    otherAttributes.otherMethods.render.option_create = function(data, escape) {
                        return '<div class="slds-grid slds-grid_vertical create" data-selectable="true">' +
                            '<div class="slds-m-bottom_xx-small">' + escape(data.input) + ' is not in our system.</div>' +
                            '<div><a href="javascript:void(0)">+ Add ' + escape(data.input) + '</a></div>' +
                            '</div>';
                    };

                    otherAttributes.otherMethods.create = function(input, fn, fromPaste) {
                        if (fromPaste) {
                            fn(); //need to callback or else control becomes unresponsive
                            return;
                        }
                        var firstName = input.substr(0, input.indexOf(' '));
                        var lastName = input.substr(input.indexOf(' ') + 1);
                        onCreateCallback(firstName, lastName, lookupIndex);
                        return {
                            id: cmp.getLocalId(),
                            text: function() {
                                input = firstName + ' ' + lastName;
                                return input;
                            }
                        }
                    }
                }
                if (cmp.get('v.isTransfer') && !cmp.get('v.eventObj.createContactForAttendees')) {
                    otherAttributes.otherMethods.create = false;
                }

                if (FH.notEmpty(soLine) &&
                    FH.notEmpty(soLine.contactId) &&
                    FH.notEmpty(soLine.contactName) &&
                    soLine.contactName.toLowerCase() !== 'undefined') {
                    otherAttributes.preloadObj = {
                        sObj: {
                            Name: soLine.contactName
                        },
                        sObjectId: soLine.contactId,
                        sObjectLabel: soLine.contactName
                    }
                }
                var disableInput = false;
                if (cmp.get('v.eventObj.isInvitationOnly') && cmp.get('v.index') === 0 && cmp.get('v.isSalesOrderLine')) {
                    cmp.set('v.primaryRegistrationInvitation', true);
                    disableInput = true;
                }
                if (cmp.get('v.eventObj.isInvitationOnly') && cmp.get('v.eventObj.disableAttendeeAssignment')) {
                    disableInput = true;
                }
                if (cmp.get('v.disableLookUp')) {
                    disableInput = true;
                }

                return FH.createComponent('markup://Framework:InputFields', {
                    'value': soLine,
                    'fieldType': 'lookup',
                    'aura:id': 'contactId',
                    'labelStyleClasses': cmp.get('v.labelStyleClasses'),
                    'label': label,
                    'isRequired': true,
                    'fireChangeEvent': true,
                    disabled: disableInput,
                    'group': soLine.id,
                    otherAttributes: otherAttributes
                }).then(function(newCmp) {
                    newCmp.set('v.value', soLine);
                    cmp.set('v.contactGlobalId', newCmp.getGlobalId());
                    // find the first matching div that doesn't have anything in it
                    var divComponent = FH.find(cmp, "lookupDiv").find(function(div) { return div.get('v.body').length === 0;});
                    var divBody = divComponent.get("v.body");
                    divBody.push(newCmp);
                    divComponent.set("v.body", divBody);
                    return newCmp;
                });
            },
            navToFirstRegistrationStep: function(cmp, isRSVP, eventObj) {
                let regPath = FH.ROUTINGPATH.EVENTREG;
                let salesOrder = cmp.get('v.salesOrderObj');
                let isSimpleRegistration = cmp.get('v.eventBase').checkIfSimpleRegistration(cmp, salesOrder);
                let checkIfSimpleRegistrationWithEnabledSessionOnly = cmp.get('v.eventBase').checkIfSimpleRegistrationWithEnabledSessionOnly(cmp, salesOrder);
                let windowsLocationHash = FH.ROUTINGPATH.getCurrentWindowHash();
                let skipAssignment = eventObj.disableAttendeeAssignment || eventObj.isSingleTicketEvent;
                if (!skipAssignment) {
                    skipAssignment = _.filter(salesOrder.lines, {assignmentComplete: false}) <= 0;
                }

                if (!skipAssignment && _.indexOf([regPath.TICKETASSIGNMENT, regPath.TICKETS, regPath.OVERVIEW], windowsLocationHash) === -1) {
                    window.location.hash = regPath.TICKETASSIGNMENT;
                }
                else if (salesOrder.hasTicketsWithSeating) {
                    window.location.hash = regPath.SEATING;
                }
                else if (checkIfSimpleRegistrationWithEnabledSessionOnly && eventObj.sessionsEnabled && salesOrder.hasAtleastOneActiveAgenda) {
                    window.location.hash = regPath.AGENDA;
                }
                //if it's single ticket, we can skip the form step
                else if (eventObj.isSingleTicketEvent && eventObj.sessionsEnabled && salesOrder.hasAtleastOneActiveAgenda) {
                    window.location.hash = '/reg/agenda';
                }
                else if (salesOrder.hasAvailablePackageItems) {
                    window.location.hash = regPath.RECOMMENDED;
                }
                else if ((isSimpleRegistration && eventObj.disableAttendeeAssignment) || eventObj.isSingleTicketEvent) {
                    if (eventObj.registrationStyle === 'Community Event') {
                        window.onbeforeunload = null;
                        window.onunload = null;
                        FH.waitForDataPromise('currentSite')
                            .then(function(site) {
                                window.onbeforeunload = null;
                                window.onunload = null;
                                window.location = site.siteUrl + '/store#/store/cart/' + salesOrder.id;
                            })
                    }
                    else {
                        window.location.hash = regPath.CHECKOUT;
                    }
                }
                //unsure about these branches
                else if (isRSVP) {
                    window.location.hash = regPath.SELECTATTENDEE;
                }
                else if (windowsLocationHash === regPath.TICKETASSIGNMENT || windowsLocationHash === regPath.TICKETS) {
                    window.location.hash = regPath.CHECKOUT;
                }
                else if (isRSVP) {
                    window.location.hash = regPath.SELECTATTENDEE;
                } else if (windowsLocationHash === regPath.TICKETASSIGNMENT || windowsLocationHash === regPath.TICKETS) {
                    window.location.hash = regPath.CHECKOUT;
                } else {
                    window.location.hash = regPath.TICKETASSIGNMENT;
                }
        },
        salesOrderHelpers: {
            getBlankSalesOrder: function () {
                return {
                    lines: [],
                    waitlistEntries: [],
                    subTotal: 0
                };
            },
            addSalesOrderToCart: function (newSalesOrder) {
                let self = this;
                _.forEach(newSalesOrder.lines, function (newSoLine) {
                    self.updateLineProperties(newSoLine, null, true);

                    _.forEach(newSoLine.assignments, function (newAssignment) {
                        self.updateLineProperties(newAssignment, null, true);
                    });
                });
                _.forEach(newSalesOrder.waitlistEntries, function (newWaitlistEntry) {
                    self.updateLineProperties(newWaitlistEntry, null, true);
                });
            },
            setSalesOrder: function (component, salesOrderAttributeName, newSalesOrder) {
                let self = this;
                let compAttributeName = 'v.' + salesOrderAttributeName;
                let oldSalesOrder = component.get(compAttributeName);
                self.updateNewSalesOrder(newSalesOrder, oldSalesOrder);
                component.set(compAttributeName, newSalesOrder);
            },
            updateNewSalesOrder: function (newSalesOrder, oldSalesOrder) {
                let self = this;
                let oldSalesOrderHasLines = oldSalesOrder && oldSalesOrder.lines && oldSalesOrder.lines.length > 0;
                let oldSalesOrderHasWaitlist = oldSalesOrder && oldSalesOrder.waitlistEntries && oldSalesOrder.waitlistEntries.length > 0;
                _.forEach(newSalesOrder.lines, function (newSoLine) {
                    let oldSoLine = null;
                    if (oldSalesOrderHasLines) {
                        oldSoLine = _.find(oldSalesOrder.lines, {id: newSoLine.id});
                    }
                    self.updateLineProperties(newSoLine, oldSoLine, false);

                    _.forEach(newSoLine.assignments, function (newAssignment) {
                        let oldAssignment = null;
                        if (oldSoLine) {
                            oldAssignment = _.find(oldSoLine.assignments, {id: newAssignment.id});
                        }
                        self.updateLineProperties(newAssignment, oldAssignment, false);
                    });
                });
                _.forEach(newSalesOrder.waitlistEntries, function (newWaitlistEntry) {
                    let oldWaitlistEntry = null;

                    if (oldSalesOrderHasWaitlist) {
                        oldWaitlistEntry = _.find(oldSalesOrder.waitlistEntries, {id: newWaitlistEntry.id});
                    }
                    self.updateLineProperties(newWaitlistEntry, oldWaitlistEntry, false);
                });
            },
            updateLineProperties: function (newSoLine, oldSoLine, defaultValue) {
                let self = this;
                if (defaultValue === undefined) {
                    defaultValue = false;
                }
                self.updateNewObjectProperty(newSoLine, 'addedInCart', defaultValue, oldSoLine);
                self.updateNewObjectProperty(newSoLine, 'assignmentComplete', defaultValue, oldSoLine);
            },
            updateNewObjectProperty: function (newObject, propertyName, defaultValue, oldObject) {
                if (!newObject.hasOwnProperty(propertyName)) {
                    let propertyValue = defaultValue;
                    if (oldObject) {
                        if (oldObject.hasOwnProperty(propertyName)) {
                            propertyValue = oldObject[propertyName];
                        }
                    }
                    newObject[propertyName] = propertyValue;
                }
            }
        }
    }
    }
}));
