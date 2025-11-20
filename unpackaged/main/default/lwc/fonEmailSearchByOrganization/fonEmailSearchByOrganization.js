import { LightningElement, api, track } from 'lwc';
import getSearchResults from '@salesforce/apex/FON_EmailSearchByOrganizationController.getSearchResults';

export default class FonEmailSearchByOrganization extends LightningElement {
    @api accountId;
    @api inputLabel = 'Contact Search By Email';
    @api buttonLabel = 'Search';
    @track contact = null;
    @track email = null;
    @track message = null;
    @track showSpinner = false;

    handleChange(event) {
        this.email = event.target.value;
    }

    handleClick(event) {
        console.log('FonEmailSearchByOrganization handleClick');
        console.log('this.email ' + this.email);
        event.preventDefault();

        if(this.email) {
            let params = {
                accountId: this.accountId,
                email: this.email
            };

            getSearchResults(params)
                .then(result => this.setResult(result))
                .catch(error => this.handleError(error));

        } else {
            this.message = null;
            this.showSpinner = false;
            this.contact = null;

            this.dispatchRecordSelectedEvent();
        }
    }

    setResult(newResult) {
        console.log('newResult ' + JSON.stringify(newResult));
        this.showSpinner = false;
        if(newResult) {
            this.message = null;
            this.contact = newResult;
        } else {
            this.message = 'No Results Found. Please create new contact below';
            this.contact = null;
        }

        this.dispatchRecordSelectedEvent();
    }

    handleError(error) {
        this.showSpinner = false;
        this.message = 'Error attempting to search.';
        let errorEvent = new CustomEvent('error', {detail: error});
        this.dispatchEvent(errorEvent);
    }

    dispatchRecordSelectedEvent() {
        let eventName = this.fieldName ? 'valuechanged': 'recordselected';
        let payload = {
            canceled: this.contact ? false : true,
            recordId: this.contact ? this.contact.Id : null,
            value: this.contact,
            name: this.fieldName
        };

        let recordSelectedEvent = new CustomEvent(eventName, {
            detail: payload,
            bubbles: true,
            cancelable: true
        });

        this.dispatchEvent(recordSelectedEvent);
    }
}