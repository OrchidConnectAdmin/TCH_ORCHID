import { LightningElement, track } from 'lwc';
import getExemptionInfo from '@salesforce/apex/AvalaraTaxExemptionService.getExemptionInfo';
import registerAndInvite from '@salesforce/apex/AvalaraTaxExemptionService.registerAndInvite';
import requestNewExemption from '@salesforce/apex/AvalaraTaxExemptionService.requestNewExemption';

export default class AvalaraTaxExemption extends LightningElement {
    @track isLoading = true;
    @track isSubmitting = false;
    @track isSuccess = false;
    @track isRegistered = false;
    @track errorMessage;

    @track contactName;
    @track email;
    @track street;
    @track city;
    @track state;
    @track postalCode;
    @track country;

    @track addressOptions = [];
    @track selectedAddressSource;
    @track certificates = [];

    certExpressUrl;
    _optionMap = {};

    connectedCallback() {
        this.loadExemptionInfo();
    }

    get isAddressReadOnly() {
        return this.selectedAddressSource !== 'manual';
    }

    get hasCertificates() {
        return this.certificates && this.certificates.length > 0;
    }

    // ─── Data Loading ───

    loadExemptionInfo() {
        this.isLoading = true;
        getExemptionInfo()
            .then(result => {
                this.isRegistered = result.isRegistered;
                this.email = result.customerEmail;

                if (this.isRegistered) {
                    this.certificates = this.mapCertificates(result.certificates);
                }

                this.buildOptionMap(result.addressOptions);
                this.addressOptions = result.addressOptions.map(opt => ({
                    label: opt.label,
                    value: opt.value
                }));

                if (this.addressOptions.length > 0) {
                    this.selectedAddressSource = this.addressOptions[0].value;
                    this.applyOption(this.selectedAddressSource);
                }
            })
            .catch(error => {
                this.errorMessage = this.extractError(error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    mapCertificates(rawCerts) {
        if (!rawCerts) {
            return [];
        }
        return rawCerts.map(cert => ({
            id: cert.id,
            status: cert.status || 'Unknown',
            signedDate: this.formatDate(cert.signedDate),
            expirationDate: this.formatDate(cert.expirationDate),
            exposureZone: cert.exposureZone || '-',
            exemptionReason: cert.exemptionReason || '-',
            statusClass: this.resolveStatusClass(cert.status)
        }));
    }

    formatDate(dateStr) {
        if (!dateStr) {
            return '-';
        }
        const date = new Date(dateStr);
        if (isNaN(date.getTime())) {
            return dateStr;
        }
        return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
    }

    resolveStatusClass(status) {
        const normalized = (status || '').toLowerCase();
        if (normalized === 'complete' || normalized === 'approved') {
            return 'status-badge status-active';
        }
        if (normalized === 'expired' || normalized === 'revoked' || normalized === 'rejected') {
            return 'status-badge status-expired';
        }
        return 'status-badge status-pending';
    }

    buildOptionMap(options) {
        options.forEach(opt => {
            this._optionMap[opt.value] = {
                name: opt.name || '',
                email: opt.email || '',
                street: opt.street || '',
                city: opt.city || '',
                state: opt.state || '',
                postalCode: opt.postalCode || '',
                country: opt.country || ''
            };
        });
    }

    applyOption(source) {
        const opt = this._optionMap[source];
        if (opt) {
            this.contactName = opt.name;
            this.email = opt.email;
            this.street = opt.street;
            this.city = opt.city;
            this.state = opt.state;
            this.postalCode = opt.postalCode;
            this.country = opt.country;
        } else {
            this.contactName = '';
            this.email = '';
            this.street = '';
            this.city = '';
            this.state = '';
            this.postalCode = '';
            this.country = '';
        }
    }

    // ─── Event Handlers ───

    handleAddressSourceChange(event) {
        this.selectedAddressSource = event.detail.value;
        this.applyOption(this.selectedAddressSource);
    }

    handleStreetChange(event) { this.street = event.detail.value; }
    handleCityChange(event) { this.city = event.detail.value; }
    handleStateChange(event) { this.state = event.detail.value; }
    handlePostalCodeChange(event) { this.postalCode = event.detail.value; }
    handleCountryChange(event) { this.country = event.detail.value; }
    handleNameChange(event) { this.contactName = event.detail.value; }
    handleEmailChange(event) { this.email = event.detail.value; }

    handleSubmit() {
        if (!this.validateForm()) {
            return;
        }

        this.isSubmitting = true;
        this.errorMessage = undefined;

        registerAndInvite({
            name: this.contactName,
            street: this.street,
            city: this.city,
            state: this.state,
            postalCode: this.postalCode,
            country: this.country,
            email: this.email
        })
            .then(result => {
                if (result.success) {
                    this.certExpressUrl = result.certExpressUrl;
                    this.isSuccess = true;
                    window.open(this.certExpressUrl, '_blank');
                } else {
                    this.errorMessage = result.errorMessage;
                }
            })
            .catch(error => {
                this.errorMessage = this.extractError(error);
            })
            .finally(() => {
                this.isSubmitting = false;
            });
    }

    handleRequestNewExemption() {
        this.isSubmitting = true;
        this.errorMessage = undefined;

        requestNewExemption({ email: this.email })
            .then(result => {
                if (result.success) {
                    this.certExpressUrl = result.certExpressUrl;
                    window.open(this.certExpressUrl, '_blank');
                } else {
                    this.errorMessage = result.errorMessage;
                }
            })
            .catch(error => {
                this.errorMessage = this.extractError(error);
            })
            .finally(() => {
                this.isSubmitting = false;
            });
    }

    handleOpenCertExpress() {
        if (this.certExpressUrl) {
            window.open(this.certExpressUrl, '_blank');
        }
    }

    // ─── Helpers ───

    validateForm() {
        const inputs = this.template.querySelectorAll('lightning-input');
        let isValid = true;

        inputs.forEach(input => {
            if (!input.reportValidity()) {
                isValid = false;
            }
        });

        return isValid;
    }

    extractError(error) {
        if (error && error.body && error.body.message) {
            return error.body.message;
        }
        if (error && error.message) {
            return error.message;
        }
        return 'An unexpected error occurred.';
    }
}
