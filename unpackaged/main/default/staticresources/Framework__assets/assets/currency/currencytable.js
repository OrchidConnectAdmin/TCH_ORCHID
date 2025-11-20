(function(root, factory) {

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.CurrencyTable = factory();
    }

}(this, function() {
    return {
        currencyISOMap : {},
        currencySymbolMap : {},
        defaultISOCode : 'USD',
        getCurrencyFormat : function(currencyISOCode) {
            this.buildCurrencyMap(currencyISOCode);
        },
        getCurrencySymbol: function(isocode) {
            this.buildCurrencyMap(isocode);
            return typeof this.currencyISOMap[isocode] !== 'undefined' ? this.currencyISOMap[isocode].symbol : '$';// USD by default
        },
        getISOCode: function(symbol) {
            return typeof this.currencySymbolMap[symbol] !== 'undefined' ? this.currencySymbolMap[symbol].isocode : 'USD';// USD by default
        },
        getFormat: function(isocode,symbol) {
            this.buildCurrencyMap(isocode);
            if (typeof this.currencyISOMap[isocode] !== 'undefined') {
                return this.currencyISOMap[isocode].format;
            } else if (typeof this.currencySymbolMap[symbol] !== 'undefined') {
                return this.currencySymbolMap[symbol].format;
            } else {
                return '%s%v';
            }
        },
        setCurrencySymbol: function(isocode,newSymbol) {
            this.buildCurrencyMap(isocode);
            var oldSymbol = this.currencyISOMap[isocode].symbol;
            this.currencyISOMap[isocode].symbol = newSymbol;
            this.currencySymbolMap[newSymbol] = currencySymbolMap[oldSymbol];
            delete this.currencySymbolMap[oldSymbol]; // Sets the new Symbol.
        },
        setCurrencyFormat: function(isocode,symbol,newFormat,decimal,thousand) {
            this.buildCurrencyMap(currencyISOCode);
            if (typeof this.currencyISOMap[isocode] !== 'undefined') {
                this.currencyISOMap[isocode].format = newFormat;
                this.currencyISOMap[isocode].decimal = typeof decimal != 'undefined' ? decimal : '.';
                this.currencyISOMap[isocode].thousand = typeof thousand != 'undefined' ? thousand : ',';
                this.currencySymbolMap[currencyISOMap[isocode].symbol].format = newFormat;
                this.currencySymbolMap[currencyISOMap[isocode].symbol].decimal = typeof decimal != 'undefined' ? decimal : '.';
                this.currencySymbolMap[currencyISOMap[isocode].symbol].thousand = typeof thousand != 'undefined' ? thousand : ',';
            } else if (typeof this.currencySymbolMap[symbol] !== 'undefined') {
                this.currencySymbolMap[symbol].format = newFormat;
                this.currencySymbolMap[symbol].decimal = typeof decimal != 'undefined' ? decimal : '.';
                this.currencySymbolMap[symbol].thousand = typeof thousand != 'undefined' ? thousand : ',';
                this.currencyISOMap[currencySymbolMap[symbol].isocode].format = newFormat;
                this.currencyISOMap[currencySymbolMap[symbol].isocode].decimal = typeof decimal != 'undefined' ? decimal : '.';
                this.currencyISOMap[currencySymbolMap[symbol].isocode].thousand = typeof thousand != 'undefined' ? thousand : ',';
            }
        },
        formatElement: function(elementId, isocode, isMultiCurrency) {
            var spanElement = document.getElementById(elementId);
            if (typeof isocode == 'undefined' || isocode === null) {
                isocode = 'USD'; // Defaults to USD
            }

            var symbol = this.currencyISOMap[isocode].symbol;
            var format = this.currencyISOMap[isocode].format;
            if (isMultiCurrency) {
                format = '%s %v';
                symbol = this.currencyISOMap[isocode].isocode;
            }

            var options = {
                symbol: symbol,
                decimal: this.currencyISOMap[isocode].decimal,
                thousand: this.currencyISOMap[isocode].thousand,
                precision: '2',
                format: format
            }
            if (typeof spanElement.innerHTML !== 'undefined' && !spanElement.classList.contains('currency_formatted')) {
                spanElement.innerHTML = accounting.formatMoney(parseFloat(spanElement.innerHTML),options);
                spanElement.className = spanElement.className + ' currency_formatted';
            }
        },
        formatElements: function(elementClass, isocode, isMultiCurrency) {
            this.buildCurrencyMap(isocode);
            var spanElements = document.getElementsByClassName(elementClass);
            var symbol = this.currencyISOMap[isocode].symbol;
            var format = this.currencyISOMap[isocode].format;
            if (isMultiCurrency) {
                format = '%s %v';
                symbol = this.currencyISOMap[isocode].isocode;
            }

            var options = {
                symbol: symbol,
                decimal: this.currencyISOMap[isocode].decimal,
                thousand: this.currencyISOMap[isocode].thousand,
                precision: '2',
                format: format
            }
            for (idx in spanElements) {
                if (typeof spanElements[idx].innerHTML !== 'undefined' && !spanElements[idx].classList.contains('currency_formatted')) {
                    spanElements[idx].innerHTML = accounting.formatMoney(parseFloat(spanElements[idx].innerHTML),options);
                    spanElements[idx].className = spanElements[idx].className + ' currency_formatted'; // Add this class to make sure its formatted.
                }
            }
        },
        format: function(value, isocode,isMultiCurrency) {
            this.buildCurrencyMap(isocode);
            var symbol = this.currencyISOMap[isocode].symbol;
            var format = this.currencyISOMap[isocode].format;
            if (isMultiCurrency) {
                format = '%s %v';
                symbol = this.currencyISOMap[isocode].isocode;
            }
            var options = {
                symbol: symbol,
                decimal: this.currencyISOMap[isocode].decimal,
                thousand: this.currencyISOMap[isocode].thousand,
                precision: '2',
                format: format
            }
            if (typeof value !== 'undefined' && value !== null) {
                return accounting.formatMoney(parseFloat(value),options);
            }
            else {
                return value;
            }
        },
        unformat: function(value,isocode) {
            this.buildCurrencyMap(isocode);
            if (typeof isocode !== 'undefined' && isocode !== null) {
                return accounting.unformat(value,this.currencyISOMap[isocode].decimal);
            }
            else {
                return accounting.unformat(value,this.currencyISOMap[this.defaultISOCode].decimal);
            }
        },
        formatColumn: function(values, isocode) {
            this.buildCurrencyMap(isocode);
            var options = {
                symbol: this.currencyISOMap[isocode].symbol,
                decimal: this.currencyISOMap[isocode].decimal,
                thousand: this.currencyISOMap[isocode].thousand,
                precision: '2',
                format: this.currencyISOMap[isocode].format
            }
            return accounting.formatColumn(values,options);
        },
        formatNumber: function(value, isocode) {
            this.buildCurrencyMap(isocode);
            return accounting.formatNumber(value,2,this.currencyISOMap[isocode].thousand,this.currencyISOMap[isocode].decimal);
        },
        buildCurrencyMap : function (isocode) {
            var currencyJSON = '[  {    "isocode" : "ALL",    "symbol" : "\u004c\u0065\u006b",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "AFN",    "symbol" : "\u060b",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "ARS",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "AWG",    "symbol" : "\u0192",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "AUD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "AZN",    "symbol" : "\u043c\u0430\u043d\u002e",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BSD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BBD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BYR",    "symbol" : "\u0070\u002e",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BZD",    "symbol" : "\u0042\u005a\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BMD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BOB",    "symbol" : "\u0024\u0062",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BAM",    "symbol" : "\u004b\u004d",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BWP",    "symbol" : "\u0050",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BGN",    "symbol" : "\u043b\u0432",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BRL",    "symbol" : "\u0052\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "BND",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "KHR",    "symbol" : "\u17db",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "CAD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "KYD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "CLP",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "CNY",    "symbol" : "\u00a5",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "COP",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "CRC",    "symbol" : "\u20a1",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "HRK",    "symbol" : "\u006b\u006e",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "CUP",    "symbol" : "\u20b1",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "CZK",    "symbol" : "\u004b\u010d",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "DKK",    "symbol" : "\u006b\u0072",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "DOP",    "symbol" : "\u0052\u0044\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "XCD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "EGP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SVC",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "EEK",    "symbol" : "\u006b\u0072",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "EUR",    "symbol" : "\u20ac",    "format" : "%v %s",    "thousand" : ".",    "decimal" : ","  },  {    "isocode" : "FKP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "FJD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "GHC",    "symbol" : "\u00a2",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "GIP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "GTQ",    "symbol" : "\u0051",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "GGP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "GYD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "HNL",    "symbol" : "\u004c",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "HKD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "HUF",    "symbol" : "\u0046\u0074",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "ISK",    "symbol" : "\u006b\u0072",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "INR",    "symbol" : "\u0930",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "IDR",    "symbol" : "\u0052\u0070",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "IRR",    "symbol" : "\ufdfc",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "IMP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "ILS",    "symbol" : "\u20aa",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "JMD",    "symbol" : "\u004a\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "JPY",    "symbol" : "\u00a5",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "JEP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "KZT",    "symbol" : "\u043b\u0432",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "KPW",    "symbol" : "\u20a9",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "KRW",    "symbol" : "\u20a9",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "KGS",    "symbol" : "\u043b\u0432",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "LVL",    "symbol" : "\u004c\u0073",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "LBP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "LRD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "LTL",    "symbol" : "\u004c\u0074",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "MKD",    "symbol" : "\u0434\u0435\u043d",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "MYR",    "symbol" : "\u0052\u004d",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "MUR",    "symbol" : "\u20a8",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "MXN",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "MNT",    "symbol" : "\u20ae",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "MZN",    "symbol" : "\u004d\u0054",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "NAD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "NPR",    "symbol" : "\u20a8",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "ANG",    "symbol" : "\u0192",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "NZD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "NIO",    "symbol" : "\u0043\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "NGN",    "symbol" : "\u20a6",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "NOK",    "symbol" : "\u006b\u0072",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "OMR",    "symbol" : "\ufdfc",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "PKR",    "symbol" : "\u20a8",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "PAB",    "symbol" : "\u0042\u002f\u002e",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "PYG",    "symbol" : "\u0047\u0073",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "PEN",    "symbol" : "\u0053\u002f\u002e",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "PHP",    "symbol" : "\u20b1",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "PLN",    "symbol" : "\u007a\u0142",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "QAR",    "symbol" : "\ufdfc",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "RON",    "symbol" : "\u006c\u0065\u0069",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "RUB",    "symbol" : "\u0440\u0443\u0431",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SHP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SAR",    "symbol" : "\ufdfc",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "RSD",    "symbol" : "\u0414\u0438\u043d\u002e",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SCR",    "symbol" : "\u20a8",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SGD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SBD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SOS",    "symbol" : "\u0053",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "ZAR",    "symbol" : "\u0052",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "KRW",    "symbol" : "\u20a9",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "LKR",    "symbol" : "\u20a8",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SEK",    "symbol" : "\u006b\u0072",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "CHF",    "symbol" : "\u0043\u0048\u0046",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SRD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "SYP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "TWD",    "symbol" : "\u004e\u0054\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "THB",    "symbol" : "\u0e3f",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "TTD",    "symbol" : "\u0054\u0054\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "TRY",    "symbol" : "TL",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "TRL",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "TVD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "UAH",    "symbol" : "\u20b4",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "GBP",    "symbol" : "\u00a3",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "USD",    "symbol" : "\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "UYU",    "symbol" : "\u0024U",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "UZS",    "symbol" : "\u043b\u0432",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "VEF",    "symbol" : "\u0042\u0073",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "VND",    "symbol" : "\u20ab",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "YER",    "symbol" : "\ufdfc",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  },  {    "isocode" : "ZWD",    "symbol" : "\u005a\u0024",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  }, {    "isocode" : "AED",    "symbol" : "\u062F.\u0625",    "format" : "%s%v",    "thousand" : ",",    "decimal" : "."  }]';
            var currencyObject = JSON.parse(currencyJSON);
            this.currencyISOMap = new Object();
            this.currencySymbolMap = new Object();

            //build the maps
            for (var cur in currencyObject) {
                this.currencyISOMap[currencyObject[cur].isocode] = currencyObject[cur];
                this.currencySymbolMap[currencyObject[cur].symbol] = currencyObject[cur];
            }

            this.defaultISOCode = isocode;
        }
    }
}));
