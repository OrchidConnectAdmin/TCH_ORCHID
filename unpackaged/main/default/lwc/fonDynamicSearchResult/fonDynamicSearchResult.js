import { LightningElement, api } from 'lwc';

export default class FonDynamicSearchResult extends LightningElement {
    @api iconName;
    @api record;
    @api displayFields;

    handleClick = () => {
        console.log('FonDynamicSearchResult handleClick');
        let payload = {
            detail: { record: this.record }
        };
        let searchResultSelected = new CustomEvent('searchresultselected', payload);
        this.dispatchEvent(searchResultSelected);
    }

    get fieldNameResults() {
        if(!this.record) {
            return null;
        }

        let foundResult = false;
        let result = [];

        let displayFields = this.displayFields.split(',');

        for(let fieldName in this.record) {
            if(
                fieldName !== 'Id' && 
                fieldName !== 'Name' && 
                Object.prototype.hasOwnProperty.call(this.record, fieldName) &&
                displayFields.includes(fieldName)
            ) {
                result.push({ name: fieldName, value: this.record[fieldName]});
                foundResult = true;
            }
        }

        return foundResult ? result : null;
    }
}