import { LightningElement, api, track } from 'lwc';

export default class FonOnboardingAgreementOptions extends LightningElement {
    @api recordId;
    @api radioGroupLabel;
    @api fileUploaderLabel = '(Note: Only .doc, .docx, .pdf, .xls, and .xlsx files are allowed.)';
    @api fileUploadLabel = this.getFileUploadLabel();
    @api mailLabel = this.getMailLabel();
    @api formLabel = this.getFormLabel();
    @api initialValue;
    @api disabled = false;
    @track value;

    get options() {
        return [
            {label: this.fileUploadLabel, value: 'I Am Scanning and Attaching a PDF'},
            {label: this.mailLabel, value: 'I Am Mailing the Executed Member Agreement'},
            {label: this.formLabel, value: 'I Am Sending an Invitation to the Potential Member to Complete'}
        ];
    }

    get isFileUpload() {
        return this.value === 'I Am Scanning and Attaching a PDF';
    }

    get isMail() {
        return this.value === 'I Am Mailing the Executed Member Agreement';
    }

    get isForm() {
        return this.value === 'I Am Sending an Invitation to the Potential Member to Complete';
    }

    get acceptedFormats() {
        return ['.doc', '.docx', '.pdf', '.xls', '.xlsx'];
    }

    connectedCallback() {
        this.value = this.initialValue;
    }

    handleChange(event) {
        this.value = event.detail.value;
        console.log(`Option selected with value: ${this.value}`);

        const selectedEvent = new CustomEvent('agreementoptionselected', {
            detail: this.value
        })

        this.dispatchEvent(selectedEvent);
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        const selectedEvent = new CustomEvent('agreementuploaded', {
            detail: uploadedFiles[0].documentId
        })

        console.log("No. of files uploaded : " + uploadedFiles[0].documentId);
        this.dispatchEvent(selectedEvent);
    }

    getFileUploadLabel() {
        let fileUploadLabel = 'I am scanning and attaching a file of the member agreement in my offices ';
        fileUploadLabel += 'utilizing the Browse feature and mailing the original executed agreement to ECCHO.';

        return fileUploadLabel;
    }

    getMailLabel() {
        let mailLabel = 'I am mailing the executed original member agreement to ECCHO and they will ';
        mailLabel += 'scan and attach the file.';

        return mailLabel;
    }

    getFormLabel() {
        let formLabel = 'I am completing some information now on behalf of my potential member and ';
        formLabel += 'am emailing to the potential member the virtual or electronic Agreement for completion.';
        return formLabel;
    }
}