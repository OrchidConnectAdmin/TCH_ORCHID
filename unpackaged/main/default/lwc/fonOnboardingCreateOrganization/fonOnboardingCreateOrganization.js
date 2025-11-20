import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import USER_OBJECT from '@salesforce/schema/User';
import createOrganization from '@salesforce/apex/FON_CreateOrganizationController.createOrganization';

export default class FonOnboardingCreateOrganization extends LightningElement {
    @api objectApiName = ACCOUNT_OBJECT;
    @track selectedCountry = 'US';
    @track countryOptions = [];
    @track error;

    controllerValues;
    allAvailableProvinces = [];
    provinceOptions = [];

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    @wire(getPicklistValuesByRecordType, { 
        recordTypeId: '$objectInfo.data.defaultRecordTypeId', 
        objectApiName: USER_OBJECT
    })
    countryProvincePicklistValues({error, data}) {
        if(data) {
            this.error = null;

            let countryOptions = [];

            // Country Control Field Picklist values
            data.picklistFieldValues.CountryCode.values.forEach(key => {
                countryOptions.push({
                    label: key.label,
                    value: key.value
                })
            });

            this.countryOptions = countryOptions;
            this.controllerValues = data.picklistFieldValues.StateCode.controllerValues;
            this.allAvailableProvinces = data.picklistFieldValues.StateCode.values;

            let provinceOptions = [{label:'--None--', value:''}];

            this.allAvailableProvinces.forEach(key => {
                provinceOptions.push({
                    label: key.label,
                    value: key.value
                });
            });

            this.provinceOptions = provinceOptions;

        } else if(error) {
            this.error = JSON.stringify(error);
        }
    }

    get getCountryOptions() {
        return this.countryOptions.length > 0 ? this.countryOptions : 'US';
    }

    get getProvinceOptions() {
        let provinceOptions = [];

        // filter the total dependent values based on selected country value 
        this.allAvailableProvinces.forEach(controllerValue => {
            if(controllerValue.validFor[0] === this.controllerValues[this.selectedCountry]) {
                provinceOptions.push({
                    label: controllerValue.label,
                    value: controllerValue.value
                })
            }
        })

        this.provinceOptions = provinceOptions;

        return this.provinceOptions.length > 0 ? this.provinceOptions : 'CA';
    }

    handleChange(event) {
        this.selectedCountry = event.detail.country;
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;

        const address = this.template.querySelector('lightning-input-address');
        const isValid = address.checkValidity();
        if(isValid) {
            this.error = null;
            console.log('address in submit ' + JSON.stringify(address));
            console.log('address country ' + address.country);
            fields.BillingCountryCode = address.country;
            console.log('address province' + address.province);
            fields.BillingStateCode = address.province;
            console.log('address street' + address.street);
            fields.BillingStreet = address.street;
            console.log('address city ' + address.city);
            fields.BillingCity = address.city;
            console.log('address postal code ' + address.postalCode);
            fields.BillingPostalCode = address.postalCode;
            console.log('fields ' + JSON.stringify(fields));

            const body = JSON.stringify(fields);
            let params = {
                body: body
            };

            createOrganization(params)
                .then(result => this.setResult(result, fields))
                .catch(error => this.handleError(error));
        } else {
            this.error = 'Fill in all address fields.';
        }
    }

    handleFlowChange(event){
        console.log("event details",JSON.stringify(event.detail),event.detail.status);
        if (event.detail.status === 'FINISHED') {

            //console.log("flow red processing", red);
            var res;
            var outputVariables = event.detail.outputVariables;
            var outputVar;
            for (var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                // Pass the values to the component's attributes
                console.log(outputVar.value, "outputvar")
                if (outputVar.name === "accountRecord") {
                    res = outputVar.value;
                }
            }
            //setFlowResult(res);
            console.log(res,"flow res",res.Name);
            //console.log(oid,"flow oid");

            this.setFlowResult(res);

        }
    }

    setFlowResult(newResult) {
        console.log('newResult ' + newResult.Name);
        this.showSpinner = false;
        if(newResult) {
            this.message = newResult.Name;
            this.account = newResult;

            let selectedRecord = {};
            //selectedRecord.Id = newResult.id;
            
            this.selectedRecord = newResult;
            this.dispatchRecordSelectedEvent(newResult);
            
        } else {
            this.message = 'No Results Found.';
            this.account = null;
        }

    }

    setResult(newResults, fields) {
        console.log('newResults ' + JSON.stringify(newResults));
        this.showSpinner = false;
        let newResult = Array.isArray(newResults) ? newResults[0] : newResults;
        if(newResult.success) {
            this.error = null;

            let selectedRecord = {};
            selectedRecord.Id = newResult.id;
            
            for(let fieldName in fields) {
                if(Object.prototype.hasOwnProperty.call(fields, fieldName)) {
                    selectedRecord[fieldName] = fields[fieldName];
                }
            }
    
            console.log('setResult selectedRecord ' + JSON.stringify(selectedRecord));
    
            this.selectedRecord = selectedRecord;
        } else {
            console.log('setResult errors ' + JSON.stringify(newResult));
            this.error = newResult.message ? newResult.message : 'An error occured.';
            this.selectedRecord = null;
        }

        this.dispatchRecordSelectedEvent();
    }

    handleError(error) {
        this.showSpinner = false;
        this.error = JSON.stringify(error);
        let errorEvent = new CustomEvent('error', {detail: error});
        this.dispatchEvent(errorEvent);
    }

    handleSuccess(event) {
        let selectedRecord = {};
        selectedRecord.Id = event.detail.id;
        const fields = event.detail.fields;
        console.log('handleSuccess fields ' + JSON.stringify(fields));
        for(let fieldName in fields) {
            if(Object.prototype.hasOwnProperty.call(fields, fieldName)) {
                selectedRecord[fieldName] = fields[fieldName];
            }
        }

        console.log('handleSuccess selectedRecord ' + JSON.stringify(selectedRecord));

        this.selectedRecord = selectedRecord;

        this.dispatchRecordSelectedEvent();
    }

    dispatchRecordSelectedEvent() {
        let eventName = this.fieldName ? 'valuechanged': 'recordselected';
        let payload = {
            canceled: this.selectedRecord ? false : true,
            recordId: this.selectedRecord ? this.selectedRecord.Id : null,
            value: this.selectedRecord,
            name: this.fieldName
        };

        let recordSelectedEvent = new CustomEvent(eventName, {
            detail: payload,
            bubbles: true,
            cancelable: true
        });

        console.log("DISPATCH",eventName,payload,recordSelectedEvent);
        this.dispatchEvent(recordSelectedEvent);
    }
}