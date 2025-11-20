import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id'
import SPONSORING_RELATIONSHIPS_OBJECT from '@salesforce/schema/Sponsoring_Relationships__c';
import SPONSORING_ORGANIZATION_FIELD from '@salesforce/schema/Sponsoring_Relationships__c.Sponsoring_Organization__c';
import getUserAccountId from '@salesforce/apex/FON_UserDetailsController.getUserAccountId';

export default class FonOnboarding extends NavigationMixin(LightningElement) {
    @api primaryContactCreationMessage = 
        'Creating a new Organization will require you to create a new Primary Contact on the next screen.';
    @track selectedAccount;
    @track selectedContact;
    @track isModalOpen = false;

    @wire(getUserAccountId, { userId: Id }) 
    userAccountId;

    openModal() {
        this.isModalOpen = true;
    }
    
    closeModal() {
        this.isModalOpen = false;
    }

    createSponsoringRelationship() {
        if(this.userAccountId.data) {
            const fields = {};
            fields[SPONSORING_ORGANIZATION_FIELD.fieldApiName] = this.userAccountId.data;
            const recordInput = { apiName: SPONSORING_RELATIONSHIPS_OBJECT.objectApiName, fields };
            console.log('recordInput ' + JSON.stringify(recordInput));
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

    handleAccountSelected(event) {
        console.log('FonOnboarding handleAccountSelected', event.detail);
        this.selectedAccount = event.detail;
    }

    handleContactSelected(event) {
        console.log('FonOnboarding handleContactSelected ' + JSON.stringify(event.detail));
        this.selectedContact = event.detail;
    }

    get validAccount() {
        return this.selectedAccount && this.selectedAccount.value;
    }

    get validContact() {
        return this.selectedContact && this.selectedContact.value;
    }

    get showAccountSection() {
        return !this.selectedAccount;
    }

    get showContactSection() {
        return this.validAccount && !this.validContact;
    }

    get showSponsoringRelationshipSection() {
        return this.validAccount && this.validContact && this.userAccountId.data;
    }
}