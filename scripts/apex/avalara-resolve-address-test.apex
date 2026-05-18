AvalaraResolveAddress.Request addressRequest = new AvalaraResolveAddress.Request();
addressRequest.line1 = '1600 Pennsylvania Avenue NW';
addressRequest.city = 'Washington';
addressRequest.region = 'DC';
addressRequest.postalCode = '20500';
addressRequest.country = 'US';

AvalaraResolveAddress.Response response = AvalaraResolveAddressService.execute(addressRequest);

System.debug('Resolution Quality: ' + response.resolutionQuality);

if (response.inputAddress != null) {
    System.debug('Input: ' + response.inputAddress.line1 + ', ' + response.inputAddress.city + ', ' + response.inputAddress.region);
}

if (response.coordinates != null) {
    System.debug('Coordinates: ' + response.coordinates.latitude + ', ' + response.coordinates.longitude);
}

for (AvalaraResolveAddress.Address validatedAddress : response.validatedAddresses) {
    System.debug('Validated: ' + validatedAddress.addressType + ' - ' + validatedAddress.line1 + ', ' + validatedAddress.city + ', ' + validatedAddress.region + ' ' + validatedAddress.postalCode);
}

if (response.taxAuthorities != null) {
    for (AvalaraResolveAddress.TaxAuthority taxAuthority : response.taxAuthorities) {
        System.debug('Tax Authority: ' + taxAuthority.jurisdictionName + ' (' + taxAuthority.jurisdictionType + ')');
    }
}

System.debug('Messages: ' + response.messages.size());
for (AvalaraResolveAddress.Message validationMessage : response.messages) {
    System.debug('Message [' + validationMessage.severity + ']: ' + validationMessage.summary + ' (refersTo: ' + validationMessage.refersTo + ')');
}
