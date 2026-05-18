HttpResponse response = AvalaraAuthProviderService.execute('Ping');

System.debug('Status: ' + response.getStatusCode());
System.debug('Body: ' + response.getBody());
