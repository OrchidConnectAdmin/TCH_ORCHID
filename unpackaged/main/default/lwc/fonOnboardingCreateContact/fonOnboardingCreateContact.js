import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import ID_FIELD from '@salesforce/schema/Account.Id';
import PRIMARY_CONTACT_FIELD from '@salesforce/schema/Account.OrderApi__Primary_Contact__c';
import createCommunityUser from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.createCommunityUser';

const FIELDS = [PRIMARY_CONTACT_FIELD];

export default class FonOnboardingCreateContact extends LightningElement {
    @api objectApiName = CONTACT_OBJECT;
    @api recordId;
    @api accountId;

    @wire(getRecord, { recordId: '$accountId', fields: FIELDS})
    wiredAccount

    get primaryContact() {
        return getFieldValue(this.wiredAccount.data, PRIMARY_CONTACT_FIELD);
    }

    handleSubmit(event) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;

        fields.AccountId = this.accountId;
        fields.OwnerId = '0056g000000UNgIAAW';

        console.log('handleSubmit fields ' + JSON.stringify(fields));

        console.log('primaryContact ' + this.primaryContact);

        this.template.querySelector('lightning-record-edit-form').submit(fields);
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

        if(!this.primaryContact) {
            const accountFields = {};
            accountFields[ID_FIELD.fieldApiName] = this.accountId;
            accountFields[PRIMARY_CONTACT_FIELD.fieldApiName] = selectedRecord.Id;
            const recordInput = { fields: accountFields };

            updateRecord(recordInput)
                .then(() => {
                    console.log('record updated');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Updated Organization Primary Contact',
                            variant: 'success'
                        })
                    );
                })
                .catch(error => {
                    console.log('error updating record ' + JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error updating Organization Primary Contact',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        }

        createCommunityUser({Id: this.selectedRecord.Id})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Create Community User',
                        message: 'User created successfully.',
                        variant: 'success'
                    }),
                );
            })
            .catch(error => {
                console.log('createCommunityUser error ' + JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Create Community User',
                        message: 'Error creating user.',
                        variant: 'error'
                    }),
                );
            })

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

        console.log('FonOnboardingCreateContact dispatchRecordSelectedEvent ' + JSON.stringify(recordSelectedEvent));
        this.dispatchEvent(recordSelectedEvent);
        //window.location.reload();
    }
}