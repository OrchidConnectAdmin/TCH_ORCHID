import { api, LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendInvitation from '@salesforce/apex/FON_CreateSponsoringRelationshipCtl.sendInvitation';
import sponsoringAgreementFormURL from '@salesforce/label/c.Sponsoring_Agreement_Form_URL';

export default class FonOnboardingSendInvitation extends LightningElement {
    @api joinAs;
    @api nameOfLoggedInUser;
    @api primaryRTNumber;
    @api executedById;
    @api sponsoringRelationshipId;
    @api secondaryEmail;
    @api accountName;
    @api recordId;

    placeholder = 'You have been invited to join ECCHO as a Sponsored Member. ' +
        //'Please visit <a href="' + sponsoringAgreementFormURL + '?id='+this.sponsoringRelationshipId+'">' + sponsoringAgreementFormURL + '?id=' +this.sponsoringRelationshipId +'</a> to complete the online agreement process.' +
        'Please visit [formURL] to complete the online agreement process.' +
        '<br>' +
        '<br>' +
        'Immediately after login, you will be requested to complete sign-up process and submit your information to ECCHO. ' +
        'Once your contract is reviewed and accepted by ECCHO, a separate email confirmation will be sent. ' +
        '<br>' +
        '<br>' +
        'Completing this process constitutes a Legal Agreement on behalf of your organization. ' +
        'You must be an Authorized Representative of your organization to complete. ' +
        'If this invitation should be forwarded to another person in your organization, please contact your Sponsor or ECCHO.' + 
        '<br>';

    @track message = this.placeholder;
    
    buttonLabel = 'Send';

    handleMessageChange(event) {
        this.message = event.detail.value;
    }

    handleReset() {
        this.message = this.placeholder;
    }
    
    handleSendInvitation() {
        console.log('Send Invitation called.');
        console.log('excutedById', this.executedById);
        console.log('sponsoringRelationshipId', this.sponsoringRelationshipId);
        console.log('message', this.message);

        sendInvitation({
            executedByContactId: this.executedById,
            sponsoringRelationshipId: this.sponsoringRelationshipId,
            message: this.message
        }).then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Send Invitation',
                    message: 'Invitation sent successfully to ' + result + '.',
                    variant: 'success',
                    mode: 'pester'
                }),

            );
            console.log("email", result);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Send Invitation',
                    message: 'Error sending invitation.',
                    variant: 'error'
                }),
            );
            console.log('handleSendInvitation error ' + JSON.stringify(error));
        })
    }
}