/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class EPayTransaction {
    global String algorithm;
    global Integer amount;
    global Boolean attempt_3dsecure;
    global String avs_code;
    global String avs_message;
    global String callback_avs_code;
    global String callback_avs_message;
    global Boolean callback_cancelled;
    global String callback_conversations;
    global Datetime callback_created_at;
    global String callback_cvv_code;
    global String callback_cvv_message;
    global String callback_error_code;
    global String callback_error_detail;
    global Boolean callback_fraud_review;
    global String callback_message;
    global Boolean callback_pending;
    global Boolean callback_result_uknown;
    global Boolean callback_success;
    global Datetime callback_updated_at;
    global String callback_url;
    global Boolean cancelled;
    global String checkout_form;
    global String checkout_url;
    global Datetime created_at;
    global String currency_code;
    global String custom_payment_type;
    global String cvv_code;
    global String cvv_message;
    global String description;
    global String email;
    global String error_code;
    global String error_detail;
    global List<FDService.Error> errors;
    global String fields;
    global FDService.EPayTransaction.Gateway gateway;
    global Map<String,String> gateway_specific_fields;
    global Map<String,String> gateway_specific_response_fields;
    global String gateway_token;
    global String gateway_transaction_id;
    global Map<String,Object> gatewaySpecificFields;
    global Map<String,Object> gatewaySpecificResponseFields;
    global String ip;
    global String merchant_location_descriptor;
    global String merchant_name_descriptor;
    global String message;
    global Boolean on_test_gateway;
    global String order_id;
    global String path;
    global FDService.EPayTransaction.PaymentMethod payment_method;
    global String payment_method_token;
    global Boolean pending;
    global String redirect_avs_code;
    global String redirect_avs_message;
    global Boolean redirect_cancelled;
    global Datetime redirect_created_at;
    global String redirect_cvv_code;
    global String redirect_cvv_message;
    global String redirect_error_code;
    global String redirect_error_detail;
    global Boolean redirect_fraud_review;
    global String redirect_message;
    global Boolean redirect_pending;
    global Boolean redirect_result_uknown;
    global Boolean redirect_success;
    global Datetime redirect_updated_at;
    global String redirect_url;
    global String reference_token;
    global Boolean retain_on_success;
    global String setup_checkout_url;
    global Datetime setup_created_at;
    global String setup_error_code;
    global String setup_message;
    global Boolean setup_success;
    global Datetime setup_updated_at;
    global String signature;
    global String state;
    global Boolean succeeded;
    global String token;
    global String transaction_type;
    global Datetime updated_at;
    global EPayTransaction() {

    }
    global EPayTransaction(String gateway_token, String currency_code) {

    }
global virtual class AuthMode {
    global String auth_mode_type;
    global List<FDService.EPayTransaction.Credential> credentials;
    global String name;
    global AuthMode() {

    }
}
global virtual class Credential {
    global String label;
    global String name;
    global Boolean safe;
    global String value;
    global Credential() {

    }
    global Credential(String name, String value) {

    }
}
global virtual class Gateway {
    global List<FDService.EPayTransaction.AuthMode> auth_modes;
    global String company_name;
    global String countries;
    global Datetime created_at;
    global String gateway_type;
    global String homepage;
    global String mode;
    global String name;
    global Boolean redacted;
    global String regions;
    global String state;
    global List<String> supported_payment_methods;
    global Boolean supports_3dsecure_authorize;
    global Boolean supports_3dsecure_purchase;
    global Boolean supports_authorize;
    global Boolean supports_capture;
    global Boolean supports_credit;
    global Boolean supports_credit_card;
    global Boolean supports_disburse;
    global Boolean supports_echeck;
    global Boolean supports_general_credit;
    global Boolean supports_offsite_authorize;
    global Boolean supports_offsite_purchase;
    global Boolean supports_purchase;
    global Boolean supports_purchase_via_preauthorization;
    global Boolean supports_reference_authorization;
    global Boolean supports_reference_purchase;
    global Boolean supports_remove;
    global Boolean supports_store;
    global Boolean supports_verify;
    global Boolean supports_void;
    global String token;
    global Datetime updated_at;
    global Gateway() {

    }
}
global virtual class PaymentMethod {
    global String account_holder_type;
    global String account_number;
    global String address1;
    global String address2;
    global String bank_account_type;
    global String bank_name;
    global String bank_routing_number;
    global String card_type;
    global String city;
    global String country;
    global Datetime created_at;
    global String cvv;
    global Boolean eligible_for_card_updater;
    global String email;
    global List<FDService.Error> errors;
    global String first_name;
    global String first_six_digits;
    global String full_name;
    global String last_four_digits;
    global String last_name;
    global Integer month;
    global String payment_method_type;
    global String phone;
    global Boolean retain_on_success;
    global String state;
    global String storage_state;
    global Boolean test;
    global String token;
    global Datetime updated_at;
    global String verification_value;
    global Integer year;
    global String zip;
    global PaymentMethod() {

    }
}
}
