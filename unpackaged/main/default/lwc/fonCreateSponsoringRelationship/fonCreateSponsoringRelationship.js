import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SPONSORING_RELATIONSHIPS_OBJECT from '@salesforce/schema/Sponsoring_Relationships__c';
import SPONSORING_ORGANIZATION_FIELD from '@salesforce/schema/Sponsoring_Relationships__c.Sponsoring_Organization__c';
import SPONSORED_ORGANIZATION_FIELD from '@salesforce/schema/Sponsoring_Relationships__c.Sponsored_Organization__c';
import PRIMARY_RT_NUMBER_FIELD from '@salesforce/schema/Sponsoring_Relationships__c.Primary_R_T_Number__c';

export default class FonCreateSponsoringRelationship extends NavigationMixin(LightningElement) {
    @api objectApiName = SPONSORING_RELATIONSHIPS_OBJECT;
    @api sponsoringOrganizationId;
    @api buttonLabel = 'Add New Sponsored Member';
    @track selectedAccount;

    handleAccountSelected(event) {
        this.selectedAccount = event.detail;
    }

    createSponsoringRelationship() {
        if(this.sponsoringOrganizationId && this.validAccount) {
            const fields = {};
            fields[SPONSORING_ORGANIZATION_FIELD.fieldApiName] = this.sponsoringOrganizationId;
            fields[SPONSORED_ORGANIZATION_FIELD.fieldApiName] = this.selectedAccount.recordId;
            if(this.selectedAccount.value.Primary_R_T_Number__c) {
                fields[PRIMARY_RT_NUMBER_FIELD.fieldApiName] = this.selectedAccount.value.Primary_R_T_Number__c;
            }

            const recordInput = { apiName: SPONSORING_RELATIONSHIPS_OBJECT.objectApiName, fields };
            createRecord(recordInput)
                .then(record => {
                    let sponsoringRelationshipPageReference = {
                        type: 'standard__webPage',
                        attributes: {
                            url: '/sponsoring-relationships/' + record.id
                        }
                    }
                    
                    this[NavigationMixin.Navigate](sponsoringRelationshipPageReference);
                })
                .catch(error => {
                    console.log('createRecord error ' + JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record.',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });
        }
    }

    get validAccount() {
        return this.selectedAccount && this.selectedAccount.value;
    }

    get disableSave() {
        return !this.validAccount || !this.sponsoringOrganizationId;
    }
}