import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/FON_MembershipCalculator.getAccounts';

const columns = [
    {label: 'DFI Name', fieldName: 'name', wrapText: true},
    {label: 'R/T Number', fieldName: 'Primary_R_T_Number__c'},
    {label: 'Billing Type', fieldName: 'FON_Billing_Type__c'},
    {label: 'Annual Dues', fieldName: 'FON_Annual_Dues__c'},
    {label: 'Status', fieldName: 'status'},
    {label: 'Result', fieldName: 'result', wrapText: true}
]

export default class FonMembershipCalculatorList extends LightningElement {
    @track searchText;
    columns = columns;
    accounts = [];

    @wire(getAccounts, {searchText: '$searchText'})
    wiredAccounts({error, data}) {
        if(data) {
            console.log('accounts ' + JSON.stringify(data));
            let accounts = JSON.parse(JSON.stringify(data));
            accounts.forEach(account => {
                let membership = 'Prospect';
                if(account.FON_Is_Member__c) {
                    membership = 'Active';
                }
                account.status = membership;

                let result = '';

                if(account.FON_Is_Member__c && account.FON_Billing_Type__c === 'Deposit') {
                    result = 'This DFI is currently an active member of ECCHO.';
                } else if(account.FON_Is_Member__c && account.FON_Billing_Type__c === 'Item') {
                    result = 'DFI’s Annual Membership would be ' + account.FON_Annual_Dues__c + '.';
                } else if(
                    !account.FON_Is_Member__c && 
                    (account.FON_Billing_Type__c === 'Deposit' || account.FON_Billing_Type__c === 'Item')
                ) {
                    result = 'DFI’s Annual Membership would be ' + account.FON_Annual_Dues__c + '.';
                }

                account.result = result;

                let address = '';

                if(account.BillingAddress) {
                    if(account.BillingAddress.street) {
                        address += account.BillingAddress.street + '\n';
                    }
    
                    if(account.BillingAddress.city) {
                        address += ' ' + account.BillingAddress.city
                    }
    
                    if(account.BillingAddress.state) {
                        if(account.BillingAddress.city) {
                            address += ', '
                        }
                        address += account.BillingAddress.state;
                    }
    
                    if(account.BillingAddress.postalCode) {
                        address += ' ' + account.BillingAddress.postalCode;
                    }
                }

                account.name = account.Name + '\n' + address;
            });

            this.accounts = accounts;
        } else if(error) {
            console.log('accounts error ' + JSON.stringify(error));
        }
    }

    handleChange(event) {
        console.log("SEQARCH",event.target.value.length);
        if(event.target.value.length > 0){
            this.searchText = event.target.value;
        }else{
            this.searchText = 'XXXXXXXXXXXXXXXXXXX';
        }
        
    }
}