function createLightningComponents(contactId, siteId, orderNamespace, pagesNamespace,gatewayId, gatewayType) {
    orderNamespace = (orderNamespace != null && orderNamespace) ? orderNamespace : 'OrderApi';
    pagesNamespace = (pagesNamespace != null && pagesNamespace) ? pagesNamespace : 'PagesApi';

    $Lightning.use("OrderApi:PaymentMethodsApp", function() {
          if (document.getElementById("em-payment-methods-span") && document.getElementById("em-payment-methods-span") != null) {
            if (gatewayType == 'fontevaStripe') {
              $Lightning.createComponent("FontevaPay:StripePaymentMethods", {
                recordId: contactId,
                hideHeader: true,
                isThemed: true,
                isPortal: true,
              }, "em-payment-methods-span", function(cmp) {});
            } else {
              $Lightning.createComponent( "OrderApi:PaymentMethods",
                { recordId: contactId, hideHeader: true, isThemed: true, isPortal: true,
                  textColor : text_color,
                  singleGatewayToUse : gatewayId,
                  iFrameStyles: '.slds .slds-form-element__label {color: ' + text_color + ';font-weight: 700;font-size: 14px; font-family:Lato,"Helvetica Neue",Helvetica,Arial,sans-serif }'
                },
                "em-payment-methods-span",
                function(cmp) {
                });
            }

          }
          if (document.getElementById("em-addresses-span") && document.getElementById("em-addresses-span") != null) {
              $Lightning.createComponent("OrderApi:ManageAddress",
                    { recordId : contactId, hideHeader : true,isThemed : true},
                    "em-addresses-span",
                    function(cmp) {
                        var modalCloseIcon = document.querySelectorAll('.fonteva-portal .slds-modal__container .slds-modal__header use');
                        for (i = 0; i < modalCloseIcon.length; i++) {
                          if (modalCloseIcon[i].getAttribute('href').includes('close')) {
                            modalCloseIcon[i].setAttribute('href', modalCloseIcon[i].getAttribute('href').replace('close','clear'));
                          }
                        }
                    });
          }

          if (document.getElementById("cookiePrompt") && document.getElementById("cookiePrompt") != null) {
              $Lightning.createComponent("PagesApi:CookieUsagePrompt",
                    {   contact : contactId,
                        site : siteId,
                        isGuest : false
                    },
                    "cookiePrompt",
                    function(cmp,status,message) {
                    });
          }
    });
}
