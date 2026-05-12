/**
 * Data transfer objects for the Avalara ResolveAddress API operation.
 * Contains the Request and Response inner classes that represent
 * the API payload structures for address validation.
 */
public with sharing class AvalaraResolveAddress {

    /**
     * Request payload for the ResolveAddress API.
     * Minimum required: postalCode alone, OR line1 + city + region, OR line1 + postalCode.
     */
    public class Request {
        /** Street address line 1 */
        public String line1;
        /** Street address line 2 (apartment, suite, etc.) */
        public String line2;
        /** City name */
        public String city;
        /** State or region code (e.g., 'CA', 'NY') */
        public String region;
        /** Postal/ZIP code */
        public String postalCode;
        /** Country ISO 2-character code (e.g., 'US', 'CA') */
        public String country;
        /** Text case for the returned address: 'Upper' or 'Mixed' */
        public String textCase;
    }

    /**
     * Response payload from the ResolveAddress API.
     * Contains the original input address, validated addresses, coordinates,
     * resolution quality, tax authorities, and validation messages.
     */
    public class Response {
        /** The original input address echoed back by the API */
        public Address inputAddress;
        /** List of validated/normalized addresses returned by Avalara */
        public List<Address> validatedAddresses;
        /** Top-level geolocation coordinates for the resolved address */
        public Coordinates coordinates;
        /** Quality indicator: 'NotCoded', 'External', 'CountryLevel', 'RegionLevel', 'CityLevel', 'StreetLevel', 'Intersection' */
        public String resolutionQuality;
        /** Tax authorities (jurisdictions) that apply to the resolved address */
        public List<TaxAuthority> taxAuthorities;
        /** Validation messages (warnings, errors, informational) */
        public List<Message> messages;
    }

    /**
     * Represents an address (input or validated) returned by Avalara.
     * Contains the address fields, type classification, and geolocation coordinates.
     */
    public class Address {
        /** Address type classification (e.g., 'StreetOrResidentialAddress', 'UnknownAddressType') */
        public String addressType;
        /** Street address line 1 */
        public String line1;
        /** Street address line 2 */
        public String line2;
        /** Street address line 3 */
        public String line3;
        /** City name */
        public String city;
        /** State or region code */
        public String region;
        /** Postal/ZIP code */
        public String postalCode;
        /** Country ISO 2-character code */
        public String country;
        /** Latitude coordinate (null for input address and unresolved addresses) */
        public Decimal latitude;
        /** Longitude coordinate (null for input address and unresolved addresses) */
        public Decimal longitude;
    }

    /**
     * Top-level geolocation coordinates for the resolved address.
     */
    public class Coordinates {
        /** Latitude coordinate */
        public Decimal latitude;
        /** Longitude coordinate */
        public Decimal longitude;
    }

    /**
     * Represents a tax authority (jurisdiction) that applies to the resolved address.
     */
    public class TaxAuthority {
        /** Avalara internal ID for the jurisdiction */
        public String avalaraId;
        /** Name of the jurisdiction (e.g., 'DISTRICT OF COLUMBIA') */
        public String jurisdictionName;
        /** Type of jurisdiction: 'Country', 'State', 'County', 'City', 'Special' */
        public String jurisdictionType;
        /** Avalara signature code for the jurisdiction */
        public String signatureCode;
    }

    /**
     * Represents a validation message returned by the ResolveAddress API.
     * Messages can be informational, warnings, or errors about the address resolution.
     */
    public class Message {
        /** Brief summary of the message */
        public String summary;
        /** Detailed description of the message */
        public String details;
        /** What the message refers to (e.g., 'Address', 'Address.Line0') */
        public String refersTo;
        /** Message severity: 'Success', 'Warning', 'Error', 'Exception' */
        public String severity;
        /** Source of the message (e.g., 'Avalara.AvaTax.Common') */
        public String source;
    }
}
