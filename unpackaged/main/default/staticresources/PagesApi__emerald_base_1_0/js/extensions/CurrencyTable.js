/* -----------------------------------------------------------------------------
* COPYRIGHT (C) 2014, FONTEVA, INC.
* ALL RIGHTS RESERVED.
*
* ALL INFORMATION CONTAINED HEREIN IS, AND REMAINS THE PROPERTY OF FONTEVA
* INCORPORATED AND ITS SUPPLIERS, IF ANY. THE INTELLECTUAL AND TECHNICAL
* CONCEPTS CONTAINED HEREIN ARE PROPRIETARY TO FONTEVA INCORPORATED AND
* ITS SUPPLIERS AND MAY BE COVERED BY U.S. AND FOREIGN PATENTS, PATENTS IN
* PROCESS, AND ARE PROTECTED BY TRADE SECRET OR COPYRIGHT LAW. DISSEMINATION
* OF THIS INFORMATION OR REPRODUCTION OF THIS MATERIAL IS STRICTLY FORBIdDEN
* UNLESS PRIOR WRITTEN PERMISSION IS OBTAINED FROM FONTEVA, INC.
* -----------------------------------------------------------------------------
*
*
* @author Kartik Viswanadha
* Javascript utility for CURRENCY MANAGEMENT
* NOTE: No JQuery used, pure JS.
**/

// Constructor.
function currencyTable(isocode) {

 // TODO Do we need to move this to somewhere else?
 var currencyJSON = '[{"isocode":"ALL","symbol":"Lek","format":"%s %v","thousand":",","decimal":"."},{"isocode":"AFN","symbol":"Ø‹","format":"%s %v","thousand":",","decimal":"."},{"isocode":"ARS","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"AWG","symbol":"Æ’","format":"%s %v","thousand":",","decimal":"."},{"isocode":"AUD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"AZN","symbol":"Ð¼Ð°Ð½","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BSD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BBD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BYR","symbol":"p.","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BZD","symbol":"BZ$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BMD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BOB","symbol":"$b","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BAM","symbol":"KM","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BWP","symbol":"P","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BGN","symbol":"Ð»Ð²","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BRL","symbol":"R$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"BND","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KHR","symbol":"áŸ›","format":"%s %v","thousand":",","decimal":"."},{"isocode":"CAD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KYD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"CLP","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"CNY","symbol":"Â¥","format":"%s %v","thousand":",","decimal":"."},{"isocode":"COP","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"CRC","symbol":"â‚¡","format":"%s %v","thousand":",","decimal":"."},{"isocode":"HRK","symbol":"kn","format":"%s %v","thousand":",","decimal":"."},{"isocode":"CUP","symbol":"â‚±","format":"%s %v","thousand":",","decimal":"."},{"isocode":"CZK","symbol":"KÄ","format":"%s %v","thousand":",","decimal":"."},{"isocode":"DKK","symbol":"kr","format":"%s %v","thousand":",","decimal":"."},{"isocode":"DOP","symbol":"RD$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"XCD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"EGP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SVC","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"EEK","symbol":"kr","format":"%s %v","thousand":",","decimal":"."},{"isocode":"EUR","symbol":"â‚¬","format":"%v %s","thousand":".","decimal":","},{"isocode":"FKP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"FJD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"GHC","symbol":"Â¢","format":"%s %v","thousand":",","decimal":"."},{"isocode":"GIP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"GTQ","symbol":"Q","format":"%s %v","thousand":",","decimal":"."},{"isocode":"GGP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"GYD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"HNL","symbol":"L","format":"%s %v","thousand":",","decimal":"."},{"isocode":"HKD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"HUF","symbol":"Ft","format":"%s %v","thousand":",","decimal":"."},{"isocode":"ISK","symbol":"kr","format":"%s %v","thousand":",","decimal":"."},{"isocode":"INR","symbol":"Rs","format":"%s %v","thousand":",","decimal":"."},{"isocode":"IDR","symbol":"Rp","format":"%s %v","thousand":",","decimal":"."},{"isocode":"IRR","symbol":"ï·¼","format":"%s %v","thousand":",","decimal":"."},{"isocode":"IMP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"ILS","symbol":"â‚ª","format":"%s %v","thousand":",","decimal":"."},{"isocode":"JMD","symbol":"J$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"JPY","symbol":"Â¥","format":"%s %v","thousand":",","decimal":"."},{"isocode":"JEP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KZT","symbol":"Ð»Ð²","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KPW","symbol":"â‚©","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KRW","symbol":"â‚©","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KGS","symbol":"Ð»Ð²","format":"%s %v","thousand":",","decimal":"."},{"isocode":"LAK","symbol":"â‚­","format":"%s %v","thousand":",","decimal":"."},{"isocode":"LVL","symbol":"Ls","format":"%s %v","thousand":",","decimal":"."},{"isocode":"LBP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"LRD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"LTL","symbol":"Lt","format":"%s %v","thousand":",","decimal":"."},{"isocode":"MKD","symbol":"Ð´ÐµÐ½","format":"%s %v","thousand":",","decimal":"."},{"isocode":"MYR","symbol":"RM","format":"%s %v","thousand":",","decimal":"."},{"isocode":"MUR","symbol":"â‚¨","format":"%s %v","thousand":",","decimal":"."},{"isocode":"MXN","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"MNT","symbol":"â‚®","format":"%s %v","thousand":",","decimal":"."},{"isocode":"MZN","symbol":"MT","format":"%s %v","thousand":",","decimal":"."},{"isocode":"NAD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"NPR","symbol":"â‚¨","format":"%s %v","thousand":",","decimal":"."},{"isocode":"ANG","symbol":"Æ’","format":"%s %v","thousand":",","decimal":"."},{"isocode":"NZD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"NIO","symbol":"C$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"NGN","symbol":"â‚¦","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KPW","symbol":"â‚©","format":"%s %v","thousand":",","decimal":"."},{"isocode":"NOK","symbol":"kr","format":"%s %v","thousand":",","decimal":"."},{"isocode":"OMR","symbol":"ï·¼","format":"%s %v","thousand":",","decimal":"."},{"isocode":"PKR","symbol":"â‚¨","format":"%s %v","thousand":",","decimal":"."},{"isocode":"PAB","symbol":"B/.","format":"%s %v","thousand":",","decimal":"."},{"isocode":"PYG","symbol":"Gs","format":"%s %v","thousand":",","decimal":"."},{"isocode":"PEN","symbol":"S/.","format":"%s %v","thousand":",","decimal":"."},{"isocode":"PHP","symbol":"â‚±","format":"%s %v","thousand":",","decimal":"."},{"isocode":"PLN","symbol":"zÅ‚","format":"%s %v","thousand":",","decimal":"."},{"isocode":"QAR","symbol":"ï·¼","format":"%s %v","thousand":",","decimal":"."},{"isocode":"RON","symbol":"lei","format":"%s %v","thousand":",","decimal":"."},{"isocode":"RUB","symbol":"Ñ€ÑƒÐ±","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SHP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SAR","symbol":"ï·¼","format":"%s %v","thousand":",","decimal":"."},{"isocode":"RSD","symbol":"Ð”Ð¸Ð½.","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SCR","symbol":"â‚¨","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SGD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SBD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SOS","symbol":"S","format":"%s %v","thousand":",","decimal":"."},{"isocode":"ZAR","symbol":"R","format":"%s %v","thousand":",","decimal":"."},{"isocode":"KRW","symbol":"â‚©","format":"%s %v","thousand":",","decimal":"."},{"isocode":"LKR","symbol":"â‚¨","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SEK","symbol":"kr","format":"%s %v","thousand":",","decimal":"."},{"isocode":"CHF","symbol":"CHF","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SRD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"SYP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"TWD","symbol":"NT$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"THB","symbol":"à¸¿","format":"%s %v","thousand":",","decimal":"."},{"isocode":"TTD","symbol":"TT$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"TRY","symbol":"","format":"%s %v","thousand":",","decimal":"."},{"isocode":"TRL","symbol":"â‚¤","format":"%s %v","thousand":",","decimal":"."},{"isocode":"TVD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"UAH","symbol":"â‚´","format":"%s %v","thousand":",","decimal":"."},{"isocode":"GBP","symbol":"Â£","format":"%s %v","thousand":",","decimal":"."},{"isocode":"USD","symbol":"$","format":"%s %v","thousand":",","decimal":"."},{"isocode":"UYU","symbol":"$U","format":"%s %v","thousand":",","decimal":"."},{"isocode":"UZS","symbol":"Ð»Ð²","format":"%s %v","thousand":",","decimal":"."},{"isocode":"VEF","symbol":"Bs","format":"%s %v","thousand":",","decimal":"."},{"isocode":"VND","symbol":"20ab","format":"%s %v","thousand":",","decimal":"."},{"isocode":"YER","symbol":"ï·¼","format":"%s %v","thousand":",","decimal":"."},{"isocode":"ZWD","symbol":"Z$","format":"%s %v","thousand":",","decimal":"."}]';
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

// Build the prototype methods that can be called from other classes.
// TODO - do we need to make these as API methods??
currencyTable.prototype = {

     getCurrencySymbol: function(isocode) {
       return typeof this.currencyISOMap[isocode] !== 'undefined' ? this.currencyISOMap[isocode].symbol : '$';// USD by default
     },
     getISOCode: function(symbol) {
       return typeof this.currencySymbolMap[symbol] !== 'undefined' ? this.currencySymbolMap[symbol].isocode : 'USD';// USD by default
     },
     getFormat: function(isocode,symbol) {
       if (typeof this.currencyISOMap[isocode] !== 'undefined') {
         return this.currencyISOMap[isocode].format;
       } else if (typeof this.currencySymbolMap[symbol] !== 'undefined') {
         return this.currencySymbolMap[symbol].format;
       } else {
         return '%s %v';
       }
     },
     setCurrencySymbol: function(isocode,newSymbol) {
       var oldSymbol = this.currencyISOMap[isocode].symbol;
       this.currencyISOMap[isocode].symbol = newSymbol;
       this.currencySymbolMap[newSymbol] = currencySymbolMap[oldSymbol];
       delete this.currencySymbolMap[oldSymbol]; // Sets the new Symbol.
     },
     setCurrencyFormat: function(isocode,symbol,newFormat,decimal,thousand) {
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
     formatElement: function(elementId, isocode) {
       var spanElement = document.getElementById(elementId);
       if (typeof isocode == 'undefined' || isocode == null || isocode == '')
         isocode = 'USD'; // Defaults to USD
       var options = {
         symbol: this.currencyISOMap[isocode].symbol,
         decimal: this.currencyISOMap[isocode].decimal,
         thousand: this.currencyISOMap[isocode].thousand,
         precision: '2',
         format: this.currencyISOMap[isocode].format
       }
       if (typeof spanElement.innerHTML !== 'undefined' && !spanElement.classList.contains('currency_formatted')) {
         spanElement.innerHTML = accounting.formatMoney(parseFloat(spanElement.innerHTML),options);
         spanElement.className = spanElement.className + ' currency_formatted';
       }
     },
     formatElements: function(elementClass, isocode) {
       var spanElements = document.getElementsByClassName(elementClass);
       var options = {
         symbol: this.currencyISOMap[isocode].symbol,
         decimal: this.currencyISOMap[isocode].decimal,
         thousand: this.currencyISOMap[isocode].thousand,
         precision: '2',
         format: this.currencyISOMap[isocode].format
       }
       for (idx in spanElements) {
         if (typeof spanElements[idx].innerHTML !== 'undefined' && !spanElements[idx].classList.contains('currency_formatted')) {
           spanElements[idx].innerHTML = accounting.formatMoney(parseFloat(spanElements[idx].innerHTML),options);
           spanElements[idx].className = spanElements[idx].className + ' currency_formatted'; // Add this class to make sure its formatted.
         }
       }
     },
     format: function(value, isocode) {
       var options = {
         symbol: this.currencyISOMap[isocode].symbol,
         decimal: this.currencyISOMap[isocode].decimal,
         thousand: this.currencyISOMap[isocode].thousand,
         precision: '2',
         format: this.currencyISOMap[isocode].format
       }
       if (typeof value !== 'undefined' && value != null)
         return accounting.formatMoney(parseFloat(value),options);
       else
         return value;
     },
     unformat: function(value,isocode) {
       if (typeof isocode !== 'undefined' && isocode != null)
         return accounting.unformat(value,this.currencyISOMap[isocode].decimal);
       else
         return accounting.unformat(value,this.currencyISOMap[this.defaultISOCode].decimal);
     },
     formatColumn: function(values, isocode) {
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
       return accounting.formatNumber(value,2,this.currencyISOMap[isocode].thousand,this.currencyISOMap[isocode].decimal);
     }
}
