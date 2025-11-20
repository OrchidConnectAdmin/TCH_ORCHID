import { LightningElement, api, track } from 'lwc';
import getSearchResults from '@salesforce/apex/FON_RTNSearchController.getSearchResults';

export default class FonRTNSearch extends LightningElement {
    @api inputLabel = 'R/T Number Search';
    @api buttonLabel = 'Search';
    @api exactMatch = false;
    @track account = null;
    @track rtn = null;
    @track message = null;
    @track showSpinner = false;

    handleChange(event) {
        this.rtn = event.target.value;
    }

    handleClick() {
        console.log('FonRTNSearch handleClick');
        console.log('this.rtn ' + this.rtn);
        if(this.rtn) {
            let params = {
                rtn: this.rtn,
                exactMatch: this.exactMatch
            };

            getSearchResults(params)
                .then(result => this.setResult(result))
                .catch(error => this.handleError(error));

        } else {
            this.message = null;
            this.showSpinner = false;
            this.account = null;

            this.dispatchRecordSelectedEvent();
        }
    }

    setResult(newResult) {
        console.log('newResult ' + JSON.stringify(newResult));
        this.showSpinner = false;
        if(newResult) {
            this.message = newResult.Name;
            this.account = newResult;
        } else {
            this.message = 'No Results Found.';
            this.account = null;
        }

        this.dispatchRecordSelectedEvent(newResult);
    }

    handleError(error) {
        this.showSpinner = false;
        this.message = error.body.message;
        let errorEvent = new CustomEvent('error', {detail: error});
        this.dispatchEvent(errorEvent);
    }

    dispatchRecordSelectedEvent(res) {
        let eventName = this.fieldName ? 'valuechanged': 'recordselected';
        if(res==null){
            eventName = 'valuechanged';
        }
        console.log("eventname",eventName);

        let payload = {
            canceled: this.account ? false : true,
            recordId: this.account ? this.account.Id : null,
            value: this.account,
            name: this.fieldName
        };
        console.log("payload",payload);

        let recordSelectedEvent = new CustomEvent(eventName, {
            detail: payload,
            bubbles: true,
            cancelable: true
        });
        console.log("recordsel",recordSelectedEvent);

        this.dispatchEvent(recordSelectedEvent);
    }
}