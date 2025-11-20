import { LightningElement, api, wire } from 'lwc';
import getSponsoringRelationshipsBySponsoringOrganizationId from '@salesforce/apex/FON_SponsoringRelationshipController.getSponsoringRelationshipsBySponsoringOrganizationId';

export default class FonSponsoringRelationshipList extends LightningElement {
    @api sponsoringOrganizationId;

    @wire(getSponsoringRelationshipsBySponsoringOrganizationId, {Id: '$sponsoringOrganizationId'})
    sponsoringRelationshipsBySponsoringOrganizationId;
}