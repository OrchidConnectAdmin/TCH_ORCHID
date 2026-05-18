AvalaraCreateTransaction.Request transactionRequest = new AvalaraCreateTransaction.Request();
transactionRequest.companyCode = 'TCHPC';
transactionRequest.type = 'SalesOrder';
transactionRequest.transactionDate = String.valueOf(Date.today());
transactionRequest.customerCode = 'TEST-CUSTOMER-001';

AvalaraCreateTransaction.Address shipFrom = new AvalaraCreateTransaction.Address();
shipFrom.line1 = '123 Main Street';
shipFrom.city = 'Irvine';
shipFrom.region = 'CA';
shipFrom.postalCode = '92615';
shipFrom.country = 'US';
transactionRequest.shipFromAddress = shipFrom;

AvalaraCreateTransaction.Address shipTo = new AvalaraCreateTransaction.Address();
shipTo.line1 = '1600 Pennsylvania Avenue NW';
shipTo.city = 'Washington';
shipTo.region = 'DC';
shipTo.postalCode = '20500';
shipTo.country = 'US';
transactionRequest.shipToAddress = shipTo;

AvalaraCreateTransaction.LineItem lineItem = new AvalaraCreateTransaction.LineItem();
lineItem.number_x = '1';
lineItem.quantity = 1;
lineItem.amount = 100.00;
lineItem.taxCode = 'P0000000';
lineItem.itemCode = 'ITEM-001';
lineItem.description = 'Tangible personal property';
transactionRequest.lineItems = new List<AvalaraCreateTransaction.LineItem>{ lineItem };

AvalaraCreateTransaction.Response response = AvalaraCreateTransactionService.execute(transactionRequest);

System.debug('Status: ' + response.status);
System.debug('Code: ' + response.code);
System.debug('ID: ' + response.id);
System.debug('Total Tax: $' + response.totalTax);
System.debug('Total Taxable: $' + response.totalTaxable);
System.debug('Total Amount: $' + response.totalAmount);
System.debug('Total Exempt: $' + response.totalExempt);

for (AvalaraCreateTransaction.ResponseLine responseLine : response.lines) {
    System.debug('Line ' + responseLine.number_x + ': tax=$' + responseLine.tax + ' taxable=$' + responseLine.taxableAmount + ' rate=' + responseLine.rate + ' taxCode=' + responseLine.taxCode);
    if (responseLine.details != null) {
        for (AvalaraCreateTransaction.TaxDetail taxDetail : responseLine.details) {
            System.debug('  Jurisdiction: ' + taxDetail.jurisName + ' (' + taxDetail.jurisType + ') rate=' + taxDetail.rate + ' tax=$' + taxDetail.tax);
        }
    }
}
