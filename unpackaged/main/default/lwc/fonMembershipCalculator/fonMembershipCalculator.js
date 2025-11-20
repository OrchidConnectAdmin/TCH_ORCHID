import { LightningElement } from 'lwc';

export default class FonMembershipCalculator extends LightningElement {
    selectedAccount;

    handleRecordSelected(event) {
        this.selectedAccount = event.detail;
        console.log("selaccount",event);
    }
    handleValueChanged(event) {
        this.selectedAccount = null;
        console.log("valuechanged",event);
    }
}