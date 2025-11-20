import { LightningElement, api } from 'lwc';

export default class FonDynamicSearchInput extends LightningElement {
    @api label = 'Lookup';
    @api delay = 300;
    @api value;
    @api fieldName = null;

    constructor() {
        super();
        this.timeout = null;
    }

    /* Bubbles change event up after debouncing */
    handleChange(event) {
        event.stopPropagation();
        window.clearTimeout(this.timeout);
        let searchTerm = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.timeout = window.setTimeout(() => {
            this.fireChange(searchTerm);
        }, this.delay);
    }

    fireChange(changedValue) {
        let eventName = this.fieldName ? 'valuechanged' : 'change';
        let payload = this.fieldName
            ? { name: this.fieldName, value: this.changedValue }
            : changedValue;
        let searchInputChangeEvent = new CustomEvent(eventName, {
            detail: payload,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(searchInputChangeEvent);
    }
}