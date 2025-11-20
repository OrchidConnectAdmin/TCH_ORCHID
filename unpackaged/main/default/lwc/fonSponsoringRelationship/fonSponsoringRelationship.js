import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import Id from '@salesforce/user/Id'
import SPONSORING_RELATIONSHIPS_OBJECT from '@salesforce/schema/Sponsoring_Relationships__c';
import USER_OBJECT from '@salesforce/schema/User';
import getUserAccountId from '@salesforce/apex/FON_UserDetailsController.getUserAccountId';
import getUserDetails from '@salesforce/apex/FON_UserDetailsController.getUserDetails';
import getSponsoringRelationship from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.getSponsoringRelationship';
import getSponsoringOrganization from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.getSponsoringOrganization';
import getSponsoredOrganization from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.getSponsoredOrganization';
import updateSponsoringRelationship from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.updateSponsoringRelationship';

export default class FonSponsoringRelationship extends LightningElement {
    @api recordId;
    @api objectApiName = SPONSORING_RELATIONSHIPS_OBJECT;
    @track sameAsExecutedByContact = false;
    @track sameAsMailingAddress = true;
    @track selectedMailingCountry = 'US';
    @track selectedFutureNotificationCountry = 'US';
    @track countryOptions = [];
    @track primaryContactId;
    @track executedByContactId;
    @track primaryRTNumber;
    @track selectedAgreementOption;
    @track agreementUpload;
    @track status;
    @track error;
    
    sponsoringOrganizationId;
    sponsoredOrganizationId;
    primaryContactId;
    sponsoringOrganization;
    sponsoredOrganization;
    affiliationType;
    controllerValues;
    srstatus;
    preload;
    allAvailableProvinces = [];
    mailingProvinceOptions = [];
    futureNotificationProvinceOptions = [];
    sendInvitation = false;
    displaySendInvitation = false;
    updateContact = false;

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

    @wire(getUserAccountId, { userId: Id }) 
    userAccountId;

    @wire(getUserDetails, { userId: Id })
    user;

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
        return this.recordId && this.sponsoringOrganization && this.sponsoredOrganization;
    }

    get readOnly() {
        console.log("STATUS",this.status);
        let st = false;
        if(this.status == 'Submitted to Sponsoring Account for Final Review'){
            st = true;
        }else if(this.status == 'Active'){
            st = true;
        }else if(this.status == 'Final Review by ECCHO Staff'){
            st = true;
        }
        return st;
    }

    get disableSendInvitation() {
        //return this.selectedAgreementOption !== 'I Am Sending an Invitation to the Potential Member to Complete' ||
        //    !this.executedByContactId; 
        return this.selectedAgreementOption == '' || typeof this.selectedAgreementOption === "undefined" || !this.executedByContactId; 
    }

    connectedCallback() {
        getSponsoringRelationship({Id: this.recordId})
            .then(result => {
                this.sponsoringOrganizationId = result.Sponsoring_Organization__c;
                this.sponsoredOrganizationId = result.Sponsored_Organization__c;
                this.primaryContactId = result.Primary_Contact_Lookup__c;
                this.executedByContactId = result.Executed_By_Lookup__c;
                this.sameAsMailingAddress = result.Same_as_Mailing_Address__c;
                this.selectedAgreementOption = result.Application_Submission_Options__c;
                this.status = result.Status__c;
                if(result.Status__c == 'Final Review by ECCHO Staff' || result.Status__c == 'Active' || result.Status__c == 'Submitted to Sponsoring Account for Final Review' ) {
                    this.srstatus = false;
                }else{
                    this.srstatus = true;
                }

                if(this.sponsoringOrganizationId && this.sponsoredOrganizationId) {
                    this.getSponsoringRelationshipInfo(result);
                }
            })
            .catch(error => {
                console.log('getSponsoringRelationship error ' + JSON.stringify(error));
            })
        
    }

    handlePrimaryContactSelected(event) {
        if(event.detail.recordId) {
            this.primaryContactId = event.detail.recordId;
        }
        console.log("Primary CONTACT SELECTED",this.selectedAgreementOption);
        
        if(this.selectedAgreementOption == '' || this.selectedAgreementOption == undefined || this.selectedAgreementOption == null){
            const btn = this.template.querySelector( ".main-submit" );
            this.selectedAgreementOption = 'I Am Sending an Invitation to the Potential Member to Complete';
            this.preload = true;
            if( btn ){ 
                btn.click();
            }
        }
    }

    handleExecutedByContactSelected(event) {
        if(event.detail.recordId) {
            this.executedByContactId = event.detail.recordId;
        }
        console.log("Signator CONTACT SELECTED",this.selectedAgreementOption);
        
        if(this.selectedAgreementOption == '' || this.selectedAgreementOption == undefined || this.selectedAgreementOption == null){
            const btn = this.template.querySelector( ".main-submit" );
            this.selectedAgreementOption = 'I Am Sending an Invitation to the Potential Member to Complete';
            this.preload = true;
            if( btn ){ 
                btn.click();
            }
        }

    }

    handleCheckboxChange(event) {
        if(event.target.name === 'same-as-executed-by-contact') {
            this.sameAsExecutedByContact = event.target.checked;
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

    handleAgreementOptionSelected(event) {
        this.selectedAgreementOption = event.detail;
        console.log('this.selectedAgreementOption ' + this.selectedAgreementOption);
    }

    handleAgreementUploaded(event) {
        this.agreementUpload = event.detail;
        console.log('this.agreementUpload ' + this.agreementUpload);
    }

    handleSubmit(event) {
        console.log("PRELOAD",this.preload);
        event.preventDefault(); // stop the form from submitting
        const fields = event.detail.fields;

        let isValid = true;
        const addresses = this.template.querySelectorAll('lightning-input-address');
        addresses.forEach(address => {
            if(!address.checkValidity) {
                isValid = false;
            }
        });

        if(isValid) {
            fields.sobjectType = SPONSORING_RELATIONSHIPS_OBJECT.objectApiName;
            fields.Id = this.recordId;

            fields.Executed_By_Lookup__c = this.executedByContactId;

            if(!this.sameAsExecutedByContact) {
                fields.Primary_Contact_Lookup__c = this.primaryContactId;
            } else {
                fields.Primary_Contact_Lookup__c = this.executedByContactId;
                
            }

            if(!this.sameAsMailingAddress) {
                fields.Mailing_Country__c = this.mailingAddress.country;
                fields.Mailing_State__c = this.mailingAddress.province;
                fields.Mailing_Address_Street__c = this.mailingAddress.street;
                fields.Mailing_Address_City__c = this.mailingAddress.city;
                fields.Mailing_Address_Zip_Code_Postal_Code__c = this.mailingAddress.postalCode;

                fields.Future_Notification_Address_Country__c = this.futureNotificationAddress.country;
                fields.Future_Notification_Address_State__c = this.futureNotificationAddress.province;
                fields.Future_Notification_Address_Street__c = this.futureNotificationAddress.street;
                fields.Future_Notification_Address_City__c = this.futureNotificationAddress.city;
                fields.Future_Notification_Address_Zip_Code__c = this.futureNotificationAddress.postalCode;
            } else {
                fields.Mailing_Country__c = this.mailingAddress.country;
                fields.Mailing_State__c = this.mailingAddress.province;
                fields.Mailing_Address_Street__c = this.mailingAddress.street;
                fields.Mailing_Address_City__c = this.mailingAddress.city;
                fields.Mailing_Address_Zip_Code_Postal_Code__c = this.mailingAddress.postalCode;

                fields.Future_Notification_Address_Country__c = this.mailingAddress.country;
                fields.Future_Notification_Address_State__c = this.mailingAddress.province;
                fields.Future_Notification_Address_Street__c = this.mailingAddress.street;
                fields.Future_Notification_Address_City__c = this.mailingAddress.city;
                fields.Future_Notification_Address_Zip_Code__c = this.mailingAddress.postalCode;
            }

            fields.Same_as_Mailing_Address__c = this.sameAsMailingAddress;
            fields.Application_Submission_Options__c = this.selectedAgreementOption;

            fields.Upload_ID__c = this.agreementUpload;

            updateSponsoringRelationship({sponsoringRelationship: fields})
                .then(result => {
                    if(this.sendInvitation && result.Executed_By_Lookup__c) {
                        this.displaySendInvitation = true;
                    }
                    if(!this.preload){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Sponsoring Relationship',
                                message: 'Record updated successfully.',
                                variant: 'success'
                            }),
                        );
                    }

                })
                .catch(error => {
                    console.log('updateSponsoringRelationship error ' + JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Sponsoring Relationship',
                            message: 'Error updating record.',
                            variant: 'error'
                        }),
                    );
                })
        }
        if(this.preload){
            window.location.reload();
            //eval("$A.get('e.force:refreshView').fire();");
        }
    }

    handleSaveAndSendInvitation() {
        this.sendInvitation = true;
    }

    getSponsoringRelationshipInfo(sponsoringRelationship) {
        getSponsoringOrganization({Id: this.sponsoringOrganizationId})
            .then(result => {
                this.sponsoringOrganization = JSON.parse(JSON.stringify(result));

                this.affiliationType = this.getAffiliationType(
                    this.sponsoringOrganization.Parent_Type__c, this.sponsoringOrganization.TCH_Membership_Type__c
                );
            })
            .catch(error => {
                console.log('getSponsoringOrganization error ' + JSON.stringify(error));
            })

        getSponsoredOrganization({Id: this.sponsoredOrganizationId})
            .then(result => {
                this.sponsoredOrganization = JSON.parse(JSON.stringify(result));

                this.sponsoredOrganization.Name = 
                    sponsoringRelationship.Legal_Organization_Name__c || this.sponsoredOrganization.Name;
                this.sponsoredOrganization.FON_Charter_Number__c =
                    sponsoringRelationship.Charter_Number__c || this.sponsoredOrganization.FON_Charter_Number__c;
                this.sponsoredOrganization.Organization_URL__c =
                    sponsoringRelationship.Organization_URL__c || this.sponsoredOrganization.Organization_URL__c;
                this.primaryRTNumber = 
                    sponsoringRelationship.Primary_R_T_Number__c || this.sponsoredOrganization.Primary_R_T_Number__c;

                this.updateAddresses(this.sponsoredOrganization, sponsoringRelationship);
            })
            .catch(error => {
                console.log('getSponsoredOrganization error ' + JSON.stringify(error));
            })
    }

    getAffiliationType(parentType, membershipType) {
        let affiliationType = 'Sponsored Member';

        if(parentType === 'Licensing Organization') {
            affiliationType = 'Licensing Participant';
        } else if(
            (parentType === null || parentType === undefined) &&
            (membershipType === 'Full Member' || membershipType === 'Participating Member')
        ) {
            affiliationType = 'Sponsored Member';
        }

        return affiliationType;
    }

    updateAddresses(sponsoredOrganization, sponsoringRelationship) {
        this.mailingAddress.country = sponsoringRelationship.Mailing_Country__c || 
            sponsoredOrganization.BillingCountryCode;
        this.mailingAddress.province = sponsoringRelationship.Mailing_State__c ||
            sponsoredOrganization.BillingStateCode;
        this.mailingAddress.street = sponsoringRelationship.Mailing_Address_Street__c ||
            sponsoredOrganization.BillingStreet;
        this.mailingAddress.city = sponsoringRelationship.Mailing_Address_City__c ||
            sponsoredOrganization.BillingCity;
        this.mailingAddress.postalCode = sponsoringRelationship.Mailing_Address_Zip_Code_Postal_Code__c ||
            sponsoredOrganization.BillingPostalCode;

        this.futureNotificationAddress.country = sponsoringRelationship.Future_Notification_Address_Country__c ||
            sponsoredOrganization.BillingCountryCode;
        this.futureNotificationAddress.province = sponsoringRelationship.Future_Notification_Address_State__c ||
            sponsoredOrganization.BillingStateCode;
        this.futureNotificationAddress.street = sponsoringRelationship.Future_Notification_Address_Street__c ||
            sponsoredOrganization.BillingStreet;
        this.futureNotificationAddress.city = sponsoringRelationship.Future_Notification_Address_City__c ||
            sponsoredOrganization.BillingCity;
        this.futureNotificationAddress.postalCode = sponsoringRelationship.Future_Notification_Address_Zip_Code__c ||
            sponsoredOrganization.BillingPostalCode;
    }
}