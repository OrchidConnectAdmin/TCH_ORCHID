import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class FonSponsoringRelationshipListItem extends NavigationMixin(LightningElement) {
    @api buttonLabel = 'Edit';
    @api sponsoringRelationship;
    url;

    handleClick(event) {
        event.preventDefault();
        event.stopPropagation();
        this.navigateToRecordViewPage(this.sponsoringRelationship.Id);
    }

    navigateToRecordViewPage(recordId) {
        let sponsoringRelationshipPageReference = {
            type: 'standard__webPage',
            attributes: {
                url: '/sponsoring-relationships/' + recordId
            }
        }
        
        this[NavigationMixin.Navigate](sponsoringRelationshipPageReference);
    }
}