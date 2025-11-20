/* eslint-disable no-debugger */
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import SPONSORING_RELATIONSHIPS_OBJECT from '@salesforce/schema/Sponsoring_Relationships__c';
import USER_OBJECT from '@salesforce/schema/User';
import CONTACT_FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import CONTACT_LAST_NAME from '@salesforce/schema/Contact.LastName';
import CONTACT_EMAIL from '@salesforce/schema/Contact.Email';
import getSponsoringOrganization from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.getSponsoringOrganization';
import getSponsoredOrganization from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.getSponsoredOrganization';
import getPrimaryContact from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.getPrimaryContact';
import createSponsoringRelationship from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.createSponsoringRelationship';

export default class FonOnboardingCreateSponsoringRelationship extends NavigationMixin(LightningElement) {
    @api objectApiName = SPONSORING_RELATIONSHIPS_OBJECT;
    @api sponsoringOrganizationId
    @api sponsoredOrganizationId
    @api primaryContactId
    @track sameAsPrimaryContact = true;
    @track sameAsMailingAddress = true;
    @track selectedMailingCountry = 'US';
    @track selectedFutureNotificationCountry = 'US';
    @track countryOptions = [];
    @track mailingProvinceOptions = [];
    @track futureNotificationProvinceOptions = [];
    @track error;
    
    sponsoringOrganization;
    sponsoredOrganization;
    primaryContact;
    affiliationType;
    controllerValues;
    allAvailableProvinces = [];

    mailingAddress = {
        country: 'US',
        province: '',
        street: '',
        city: '',
        postalCode: ''
    };

    futureNotificationAddress = {
        country: 'US',
        province: '',
        street: '',
        city: '',
        postalCode: ''
    };

    @wire(getObjectInfo, { objectApiName: SPONSORING_RELATIONSHIPS_OBJECT })
    objectInfo;

    @wire(getPicklistValuesByRecordType, { 
        recordTypeId: '$objectInfo.data.defaultRecordTypeId', 
        objectApiName: USER_OBJECT
    })
    countryProvincePicklistValues({error, data}) {
        if(data) {
            this.error = null;

            let countryOptions = [];

            // Country Control Field Picklist values
            data.picklistFieldValues.CountryCode.values.forEach(key => {
                countryOptions.push({
                    label: key.label,
                    value: key.value
                })
            });

            this.countryOptions = countryOptions;
            this.controllerValues = data.picklistFieldValues.StateCode.controllerValues;
            this.allAvailableProvinces = data.picklistFieldValues.StateCode.values;

            let mailingProvinceOptions = [{label:'--None--', value:''}];
            let futureNotificationProvinceOptions = [{label:'--None--', value:''}];

            this.allAvailableProvinces.forEach(key => {
                mailingProvinceOptions.push({
                    label: key.label,
                    value: key.value
                });
                futureNotificationProvinceOptions.push({
                    label: key.label,
                    value: key.value
                });
            });
            
            this.mailingProvinceOptions = mailingProvinceOptions;
            this.futureNotificationProvinceOptions = futureNotificationProvinceOptions;

        } else if(error) {
            console.log('countryProvincePicklistValues error');
            this.error = JSON.stringify(error);
        }
    }

    get getCountryOptions() {
        return this.countryOptions.length > 0 ? this.countryOptions : 'US';
    }

    get getMailingProvinceOptions() {
        let provinceOptions = [];

        // filter the total dependent values based on selected country value 
        this.allAvailableProvinces.forEach(controllerValue => {
            if(controllerValue.validFor[0] === this.controllerValues[this.mailingAddress.country]) {
                provinceOptions.push({
                    label: controllerValue.label,
                    value: controllerValue.value
                })
            }
        })

        this.mailingProvinceOptions = provinceOptions;

        return this.mailingProvinceOptions.length > 0 ? this.mailingProvinceOptions : 'CA';
    }

    get getFutureNotificationProvinceOptions() {
        let provinceOptions = [];

        // filter the total dependent values based on selected country value 
        this.allAvailableProvinces.forEach(controllerValue => {
            if(controllerValue.validFor[0] === this.controllerValues[this.futureNotificationAddress.country]) {
                provinceOptions.push({
                    label: controllerValue.label,
                    value: controllerValue.value
                })
            }
        })

        this.futureNotificationProvinceOptions = provinceOptions;

        return this.futureNotificationProvinceOptions.length > 0 ? this.futureNotificationProvinceOptions : 'CA';
    }

    get dataLoadedComplete() {
        return this.sponsoringOrganization && this.sponsoredOrganization && this.primaryContact;
    }

    connectedCallback() {
        getSponsoringOrganization({Id: this.sponsoringOrganizationId})
            .then(result => {
                this.sponsoringOrganization = result;
                console.log('sponsoringOrganization ' + JSON.stringify(this.sponsoringOrganization));
                this.affiliationType = this.getAffiliationType(
                    this.sponsoringOrganization.Parent_Type__c, this.sponsoringOrganization.TCH_Membership_Type__c
                );
            })
            .catch(error => {
                console.log('getSponsoringOrganization error ' + JSON.stringify(error));
            })

        getSponsoredOrganization({Id: this.sponsoredOrganizationId})
            .then(result => {
                this.sponsoredOrganization = result;
                console.log('sponsoredOrganization ' + JSON.stringify(this.sponsoredOrganization));

                this.updateAddresses(this.sponsoredOrganization);
            })
            .catch(error => {
                console.log('getSponsoredOrganization error ' + JSON.stringify(error));
            })

        getPrimaryContact({Id: this.primaryContactId})
            .then(result => {
                this.primaryContact = result;
                console.log('primaryContact ' + JSON.stringify(this.primaryContact));
            })
            .catch(error => {
                console.log('getPrimaryContact error ' + JSON.stringify(error));
            })
    }


    handleCheckboxChange(event) {
        if(event.target.name === 'same-as-primary-contact') {
            this.sameAsPrimaryContact = event.target.checked;
        } else if(event.target.name === 'same-as-mailing-address') {
            this.sameAsMailingAddress = event.target.checked;
        }
    }

    handleMailingAddressChange(event) {
        this.mailingAddress = event.detail;
    }

    handleFutureNotificationAddressChange(event) {
        this.futureNotificationAddress = event.detail;
    }

    handleSubmit(event) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;

        let isValid = true;
        const addresses = this.template.querySelectorAll('lightning-input-address');
        addresses.forEach(address => {
            if(!address.checkValidity) {
                isValid = false;
            }
        });

        if(isValid) {
            fields.sobjectType = SPONSORING_RELATIONSHIPS_OBJECT;
            console.log('fields ' + JSON.stringify(fields));
            console.log('mailingAddress ' + JSON.stringify(this.mailingAddress));
            console.log('futureNotificationAddress ' + JSON.stringify(this.futureNotificationAddress));

            let contact = null;

            if(!this.sameAsPrimaryContact) {
                contact = {};
                contact.sobjectType = 'Contact';
                contact[CONTACT_FIRST_NAME.fieldApiName]= fields.Executed_By_First_Name__c;
                contact[CONTACT_LAST_NAME.fieldApiName] = fields.Executed_By_Last_Name__c;
                contact[CONTACT_EMAIL.fieldApiName] = fields.Executed_By_Email__c;
            }

            createSponsoringRelationship({sponsoringRelationship: fields, contact: contact})
                .then(result => {
                    console.log('createSponsoringRelationship result ' + JSON.stringify(result));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Sponsoring Relationship',
                            message: 'Record updated successfully.',
                            variant: 'success'
                        }),
                    );
                })
                .catch(error => {
                    console.log('createSponsoringRelationship error ' + JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Sponsoring Relationship',
                            message: 'Error updating record.',
                            variant: 'error'
                        }),
                    );
                })
        }
    }

    handleSuccess(event) {
        this.navigateToRecordViewPage(event.detail.id);
    }

    navigateToRecordViewPage(recordId) {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Sponsoring_Relationships__c', // objectApiName is optional
                actionName: 'view'
            }
        });
    }

    getAffiliationType(parentType, membershipType) {
        console.log('getAffiliationType');
        let affiliationType = 'Sponsored Member';

        if(parentType === 'Licensing Organization') {
            affiliationType = 'Licensing Participant';
        } else if(
            (parentType === null || parentType === undefined) &&
            (membershipType === 'Full Member' || membershipType === 'Participating Member')
        ) {
            affiliationType = 'Affiliate Participant';
        }

        console.log('getAffiliationType finished');

        return affiliationType;
    }

    updateAddresses(sponsoredOrganization) {
        this.mailingAddress.country = sponsoredOrganization.BillingCountryCode;
        this.mailingAddress.province = sponsoredOrganization.BillingStateCode;
        this.mailingAddress.street = sponsoredOrganization.BillingStreet;
        this.mailingAddress.city = sponsoredOrganization.BillingCity;
        this.mailingAddress.postalCode = sponsoredOrganization.BillingPostalCode;

        this.futureNotificationAddress.country = sponsoredOrganization.BillingCountryCode;
        this.futureNotificationAddress.province = sponsoredOrganization.BillingStateCode;
        this.futureNotificationAddress.street = sponsoredOrganization.BillingStreet;
        this.futureNotificationAddress.city = sponsoredOrganization.BillingCity;
        this.futureNotificationAddress.postalCode = sponsoredOrganization.BillingPostalCode;
    }
}