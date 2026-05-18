// Test script for CommitTransaction and VoidTransaction
// Prerequisites: Run avalara-create-transaction-test.apex first to get a SalesInvoice transaction code
// Replace TRANSACTION_CODE below with the actual code from CreateTransaction response

// Step 1: Create a SalesInvoice (permanent, uncommitted)
AvalaraCreateTransaction.Request request = new AvalaraCreateTransaction.Request();
request.companyCode = 'DEFAULT';
request.type = 'SalesInvoice';
request.transactionDate = String.valueOf(Date.today());
request.customerCode = 'TEST-COMMIT-VOID';
request.commitTransaction = false;

request.shipFromAddress = new AvalaraCreateTransaction.Address();
request.shipFromAddress.line1 = '123 Main Street';
request.shipFromAddress.city = 'Irvine';
request.shipFromAddress.region = 'CA';
request.shipFromAddress.postalCode = '92615';
request.shipFromAddress.country = 'US';

request.shipToAddress = new AvalaraCreateTransaction.Address();
request.shipToAddress.line1 = '1600 Pennsylvania Avenue NW';
request.shipToAddress.city = 'Washington';
request.shipToAddress.region = 'DC';
request.shipToAddress.postalCode = '20500';
request.shipToAddress.country = 'US';

AvalaraCreateTransaction.LineItem lineItem = new AvalaraCreateTransaction.LineItem();
lineItem.number_x = '1';
lineItem.quantity = 1;
lineItem.amount = 50.00;
lineItem.taxCode = 'P0000000';
lineItem.itemCode = 'COMMIT-VOID-TEST';

request.lineItems = new List<AvalaraCreateTransaction.LineItem>{ lineItem };

AvalaraCreateTransaction.Response createResponse = AvalaraCreateTransactionService.execute(request);
System.debug('=== CreateTransaction ===');
System.debug('Code: ' + createResponse.code);
System.debug('Status: ' + createResponse.status);
System.debug('TotalTax: ' + createResponse.totalTax);

// Step 2: Commit the transaction
AvalaraCreateTransaction.Response commitResponse = AvalaraTransactionStatusService.commitTransaction('DEFAULT', createResponse.code);
System.debug('=== CommitTransaction ===');
System.debug('Status: ' + commitResponse.status);

// Step 3: Void the transaction
AvalaraCreateTransaction.Response voidResponse = AvalaraTransactionStatusService.voidTransaction('DEFAULT', createResponse.code);
System.debug('=== VoidTransaction ===');
System.debug('Status: ' + voidResponse.status);
