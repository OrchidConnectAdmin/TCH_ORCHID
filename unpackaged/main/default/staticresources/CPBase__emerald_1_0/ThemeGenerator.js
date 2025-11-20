(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.ThemeGenerator = factory();
    }

}(this, function () {
    return {
        generateTheme: function (themeObj) {
            var primaryButtonBackgroundColor = themeObj.brandPrimary;
            var primaryButtonBackgroundColorLight = this.lightenHexColor(themeObj.brandPrimary,0.025);
            var primaryButtonBackgroundColorDark = this.darkenHexColor(themeObj.brandPrimary,0.025);
            var secondaryButtonBackgroundColor = 'rgb(255, 255, 255)';
            var secondaryButtonBackgroundColorLight = secondaryButtonBackgroundColor;
            var secondaryButtonBackgroundColorDark = secondaryButtonBackgroundColor;
            var linkColorDark = this.darkenHexColor(themeObj.linkColor,0.025);
            var navbarBackgroundColor = themeObj.navbarBackgroundColor;
            var navbarLinkColor = themeObj.navbarLinkColor;
            var textColor = themeObj.textColor;
            //slds-modal__header
            var lightningStyles = FontevaStyler({
                'body' : {
                    'font-family': 'Proxima-Nova,"Helvetica Neue",Helvetica,Arial,sans-serif!important'
                },
                '.fonteva-portal input' : {
                    'font-size' : '14px!important',
                },
                '.fonteva-portal button' : {
                    border : 'none!important'
                },
                '.fonteva-portal a, .fonteva-portal .slds-button.slds-button--icon-border,  .fonteva-portal .slds-button.slds-button_icon-border': {
                    color:  linkColorDark+'!important'
                },
                '.fonteva-portal h1,.fonteva-portal h2,.fonteva-portal h3,.fonteva-portal h4,.fonteva-portal h5,.fonteva-portal h6, .fonteva-portal .slds-text-heading--large, .fonteva-portal .slds-text-heading--medium, .fonteva-portal .slds-text-heading--small, .fonteva-portal .slds-text-heading_large, .fonteva-portal .slds-text-heading_medium, .fonteva-portal .slds-text-heading_small' : {
                    color: textColor+'!important',
                },
                '.fonteva-portal .slds-text-body--regular, .fonteva-portal .slds-text-body_regular, .fonteva-portal .slds-text-body--small, .fonteva-portal .slds-text-body_small, .fonteva-portal p,.fonteva-portal .fonteva-slds-text, .fonteva-portal .uiOutputRichText, .fonteva-portal .slds-form-element__label, .fonteva-portal p.slds-tooltip--help-text, .fonteva-portal thead th, .fonteva-portal tbody td, .fonteva-portal .slds-table strong, .fonteva-portal strong, .fonteva-portal .slds-theme_default, .fonteva-portal .slds-theme--default, .fonteva-portal': {
                    color: textColor+'!important',
                },
                '.fonteva-portal .slds-modal__header' : {
                    'background-color' : navbarBackgroundColor+'!important',
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-modal__header .slds-text-heading--medium, .fonteva-portal .slds-modal__header .slds-text-heading_medium' : {
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-button.slds-button--brand:disabled, .fonteva-portal .slds-button.slds-button_brand:disabled, .forceActionLink': {
                    'background-color': primaryButtonBackgroundColorLight+'!important',
                    'border-color': primaryButtonBackgroundColorLight+'!important',
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-button.slds-button--brand, .fonteva-portal .slds-button.slds-button_brand, .forceActionLink' : {
                    'background-color' : primaryButtonBackgroundColor+'!important',
                    'border-color' : primaryButtonBackgroundColor+'!important',
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-button.slds-button--brand:hover, .fonteva-portal .slds-button.slds-button_brand:hover' : {
                    'background-color': primaryButtonBackgroundColorDark+'!important',
                    'border-color': primaryButtonBackgroundColorDark+'!important',
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-button.slds-button--brand:active, .fonteva-portal .slds-button.slds-button_brand:active' : {
                    'background-color': primaryButtonBackgroundColorDark+'!important',
                    'border-color' : primaryButtonBackgroundColorDark+'!important',
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-button.slds-button--brand:focus, .fonteva-portal .slds-button.slds-button_brand:focus' : {
                    'background-color' : primaryButtonBackgroundColorDark+'!important',
                    'border-color': primaryButtonBackgroundColorDark+'!important',
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-button.slds-button--brand.active, .fonteva-portal .slds-button.slds-button_brand.active' : {
                    'background-color' : primaryButtonBackgroundColorDark+'!important',
                    'border-color': primaryButtonBackgroundColorDark+'!important',
                    color : 'rgb(255, 255, 255)!important'
                },
                '.fonteva-portal .slds-button.slds-button--neutral:disabled, .fonteva-portal .slds-button.slds-button_neutral:disabled, .forceActionLink': {
                    'background-color': secondaryButtonBackgroundColorLight+'!important',
                    'border-color': secondaryButtonBackgroundColorLight+'!important',
                    color : textColor+'!important'
                },
                '.fonteva-portal .slds-button.slds-button--neutral, .fonteva-portal .slds-button.slds-button_neutral, .forceActionLink' : {
                    'background-color' : secondaryButtonBackgroundColor+'!important',
                    'border-color' : secondaryButtonBackgroundColor+'!important',
                    color : 'rgb(4, 32, 62)!important'
                },
                '.fonteva-portal .slds-button.slds-button--neutral:hover, .fonteva-portal .slds-button.slds-button_neutral:hover' : {
                    'background-color': secondaryButtonBackgroundColorDark+'!important',
                    border : 'none!important',
                    color : 'rgb(4, 32, 62)!important'
                },
                '.fonteva-portal .slds-button.slds-button--neutral:active, .fonteva-portal .slds-button.slds-button_neutral:active' : {
                    'background-color': secondaryButtonBackgroundColorDark+'!important',
                    'border-color' : secondaryButtonBackgroundColorDark+'!important',
                    color : 'rgb(4, 32, 62)!important'
                },
                '.fonteva-portal .slds-button.slds-button--neutral:focus, .fonteva-portal .slds-button.slds-button_neutral:focus' : {
                    'background-color' : secondaryButtonBackgroundColorDark+'!important',
                    'border-color': secondaryButtonBackgroundColorDark+'!important',
                    color : 'rgb(4, 32, 62)!important'
                },
                '.fonteva-portal .slds-button.slds-button--neutral.active, .fonteva-portal .slds-button.slds-button_neutral.active' : {
                    'background-color' : secondaryButtonBackgroundColorDark+'!important',
                    'border-color': secondaryButtonBackgroundColorDark+'!important',
                    color : 'rgb(4, 32, 62)!important'
                },
                '.fonteva-portal li.fonteva-slds-payment-tab--item.slds-active a, .fonteva-portal li.fonteva-slds-payment-tab--item a:hover, .fonteva-portal li.fonteva-slds-payment-tab--item a:focus' : {
                    'background-color': primaryButtonBackgroundColor+'!important'
                }
            });
            return lightningStyles.css;
        },
        darkenHexColor : function(color,value) {
        		if (!color || color.length == 0)
        				color = "#FFFFFF";
            color = color.replace(/[^0-9a-f]/gi,'');
            if (color.length < 6) {
                color = color[0]+ color[0]+ color[1]+ color[1]+ color[2]+ color[2];
            }
            value = (Math.abs(value) * -1) || 0; // always negative value or 0 for darker colors
            var newColor = "#", c, i, black = 0, white = 255;
            for (i = 0; i < 3; i++) {
                c = parseInt(color.substr(i*2,2), 16);
                c = Math.round(Math.min(Math.max(black, c + (value * white)), white)).toString(16);
                newColor += ("00"+c).substr(c.length);
            }
            return newColor;
        },
        lightenHexColor : function(color,value) {
        		if (!color || color.length == 0)
        				color = "#FFFFFF";
            color = color.replace(/[^0-9a-f]/gi, '');
            if (color.length < 6) {
                color = color[0]+ color[0]+ color[1]+ color[1]+ color[2]+ color[2];
            }
            value = Math.abs(value) || 0; // always positive or 0;
            var newColor = "#", c, i, black = 0, white = 255;
            for (i = 0; i < 3; i++) {
                c = parseInt(color.substr(i*2,2), 16);
                c = Math.round(Math.min(Math.max(black, c + (value * white)), white)).toString(16);
                newColor += ("00"+c).substr(c.length);
            }
            return newColor;
        }
    }
}));
