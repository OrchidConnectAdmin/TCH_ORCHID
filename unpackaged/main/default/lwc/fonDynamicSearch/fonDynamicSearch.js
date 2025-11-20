/* eslint-disable no-debugger */
import { LightningElement, api, track } from 'lwc';
import getSearchResults from '@salesforce/apex/FON_DynamicSearchController.getSearchResults';

export default class FonDynamicSearch extends LightningElement {
    @api objectName = 'Account';
    @api fieldName = null;
    @api label = 'Lookup';
    @api iconName = 'standard:account';
    @api searchField = 'Name';
    @api returnedFields = 'Id,Name,Primary_R_T_Number__c';
    @api displayFields = 'Name,BillingCity,BillingState';
    @api additionalWhereClause = 'AND FON_Account_is_Archived__c = false AND FON_Is_Subsidiary__c = false' + 
        ' AND Primary_R_T_Number__c != null';
    @track resultClass;
    @track selectedRecord;
    @track results = null;
    @track message = null;
    @track showSpinner = false;
    @track lastSearchValue;

    constructor() {
        super();
        this.switchResult(false);
    }

    handleSearch(event) {
        let searchValue = event.detail;

        if(searchValue) {
            this.switchResult(true);
            this.message = 'Searching...';
            this.showSpinner = true;

            let params = {
                objectName: this.objectName,
                searchValue: searchValue,
                searchField: this.searchField,
                additionalWhereClause: this.additionalWhereClause
            };

            this.addRequiredReturnFields(params);

            getSearchResults(params)
                .then(result => this.setResult(result))
                .catch(error => this.handleError(error));
        } else {
            this.switchResult(false);
            this.message = null;
            this.showSpinner = false;
            this.results = null;
        }

        this.lastSearchValue = searchValue;
    }

    addRequiredReturnFields(params) {
        let displayFields = this.displayFields.split(',');
        let returnedFields = this.returnedFields.split(',');
        let allFields =  [...displayFields, ...returnedFields];
        allFields.push('Id');
        allFields.push('Name');
        let cleanFields = this.dedupeArray(allFields).join(',');
        params.fieldsToQuery = cleanFields;
    }

    dedupeArray(values) {
        var dedupedArray = (arrayValues) => {
            return arrayValues.filter((element, position, array) => {
                return array.indexOf(element) === position;
            });
        }

        return dedupedArray(values);
    }

    setResult(newResults) {
        this.showSpinner = false;
        if(newResults && newResults.length > 0) {
            this.message = null;
            this.results = newResults;
        } else {
            this.message = 'No Results Found.';
        }
    }

    handleError(error) {
        this.showSpinner = false;
        this.message = 'Error attempting to search.';
        let errorEvent = new CustomEvent('error', {detail: error});
        this.dispatchEvent(errorEvent);
    }

    /* Shows and hides the result area */
    switchResult(on) {
        this.resultClass = on
            ? 'slds-form-element slds-lookup slds-is-open'
            : 'slds-form-element slds-lookup slds-is-close';
    }

    handleSearchResultSelected(event) {
        console.log('FonDynamicSearch handleSearchResultSelected');
        this.selectedRecord = event.detail.record;
        this.dispatchRecordSelectedEvent();
        this.switchResult(false);
    }

    handlePillRemove() {
        this.selectedRecord = null;
        this.dispatchRecordSelectedEvent();
        this.switchResult(this.lastSearchValue && this.results);
    }

    dispatchRecordSelectedEvent() {
        let eventName = this.fieldName ? 'valuechanged': 'recordselected';
        let payload = {
            canceled: this.selectedRecord ? false : true,
            recordId: this.selectedRecord ? this.selectedRecord.Id : null,
            value: this.selectedRecord,
            name: this.fieldName
        };

        console.log('dispatchRecordSelectedEvent ', JSON.stringify(payload));

        let recordSelectedEvent = new CustomEvent(eventName, {
            detail: payload,
            bubbles: true,
            cancelable: true
        });

        this.dispatchEvent(recordSelectedEvent);
    }
}