/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class Event extends FDService.WrapperBase {
    @AuraEnabled
    global String bannerImageUrl;
    @AuraEnabled
    global String currencyISOCode;
    @AuraEnabled
    global String description;
    @AuraEnabled
    global String displayName;
    @AuraEnabled
    global Date endDate;
    @AuraEnabled
    global EventApi__Event__c eventObj;
    @AuraEnabled
    global String id;
    @AuraEnabled
    global String imageUrl;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Boolean isFeatured;
    @AuraEnabled
    global Boolean isMultiCurrency;
    @AuraEnabled
    global Boolean isPublished;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String registrationStyle;
    @AuraEnabled
    global Decimal registrationTimer;
    @AuraEnabled
    global Date startDate;
    @AuraEnabled
    global String thumbnailImageUrl;
    global Event() {

    }
    global override virtual void fromSObject(SObject eventObj) {

    }
    global override virtual Object getFieldValueFromSObject(String fieldName) {
        return null;
    }
    global static FDService.Event getInstance() {
        return null;
    }
    global static FDService.Event getInstance(EventApi__Event__c eventObj) {
        return null;
    }
    global static List<FDService.Event> getInstance(List<EventApi__Event__c> eventObjs) {
        return null;
    }
    global override virtual SObject toSObject() {
        return null;
    }
}
