import { LightningElement, track } from 'lwc';
import getExemptionInfo from '@salesforce/apex/AvalaraTaxExemptionService.getExemptionInfo';

export default class AvalaraTaxExemption extends LightningElement {
    @track isLoading = true;
    @track isRegistered = false;
    @track errorMessage;
    @track certificates = [];

    connectedCallback() {
        this.loadExemptionInfo();
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
                if (this.isRegistered) {
                    this.certificates = this.mapCertificates(result.certificates);
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

    // ─── Helpers ───

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
