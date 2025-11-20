/* http://addtocalendar.com/
 *
 *
 * @license
 The MIT License (MIT)
 Copyright (c) 2015 AddToCalendar
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

// create a function that builds and loads the dropdown UI for the different calendar types (e.g. Google, Outlook, Yahoo, etc.)
const loadCalendars = (function (w, d) {
    var
        atc_url = '//addtocalendar.com/atc/',
        atc_version = '1.5';


    if (!Array.indexOf) {
        Array.prototype.indexOf = function (obj) {
            for (var i = 0, l = this.length; i < l; i++) {
                if (this[i] == obj) {
                    return i
                }
            }
            return -1
        }
    }

    if (!Array.prototype.map) {
        Array.prototype.map = function (f) {
            var result = [];
            for (var i = 0, l = this.length; i < l; i++) {
                result.push(f(this[i]))
            }
            return result
        }
    }

    var isArray = function (obj) {
        return Object.prototype.toString.call(obj) === "[object Array]"
    };

    var isFunc = function (obj) {
        return Object.prototype.toString.call(obj) === "[object Function]"
    };

    if (!w.addtocalendar) w.addtocalendar = {};

    addtocalendar.languages = {
        'de': 'In den Kalender',
        'en': 'Add to Calendar',
        'es': 'Añadir al Calendario',
        'fi': 'Lisää kalenteriin',
        'fr': 'Ajouter au calendrier',
        'hi': 'कैलेंडर में जोड़ें',
        'in': 'Tambahkan ke Kalender',
        'ja': 'カレンダーに追加',
        'ko': '캘린더에 추가',
        'pt': 'Adicionar ao calendário',
        'ru': 'Добавить в календарь',
        'sv': 'Lägg till i kalender',
        'uk': 'Додати в календар',
        'zh': '添加到日历',
        'no': 'Legg til i kalender'
    };

    /*
     * https://www.google.com/calendar/render
     * ?action=TEMPLATE
     * &dates=20161129T230000Z/20161203T100000Z
     * &location=somewhere
     * &text=some+title
     * &details=some+descr
     */
    addtocalendar.googleLink = function (data) {
        var base = 'https://www.google.com/calendar/render?';

        return base +
            'action=TEMPLATE' +
            '&dates=' + [data.date_start, data.date_end].map(function (d) { return d.replace(/[-:]/g, '').replace(' ', 'T') }).join('/') +
            '&ctz=' + data.timezone +
            '&location=' + data.location +
            '&text=' + data.title +
            '&details=' + data.description;
    };

    /*
 * https://outlook.live.com/owa/
 * ?path=/calendar/action/compose
 * &subject=some+title
 * &location=somewhere
 * &body=some+descr
 * &startdt=20161129T230000Z
 * &enddt=20161203T100000Z
 */

    addtocalendar.outlookLink = function (data) {
        const base = 'https://outlook.live.com/owa/?';
        const splitStartDate = data.date_start_utc.split(/ /g);
        const startDate = splitStartDate[0];
        const startTime = splitStartDate.length > 1 ? encodeURIComponent(splitStartDate[1]):'';
        const splitEndDate = data.date_end_utc.split(/ /g);
        const endDate = splitEndDate[0];
        const endTime = splitEndDate.length > 1 ? encodeURIComponent(splitEndDate[1]):'';

        return base +
            '&path=/calendar/action/compose' +
            '&startdt=' + (startDate+'T'+startTime) + 'Z' +
            '&enddt=' + (endDate+'T'+endTime) + 'Z' +
            '&location=' + data.location +
            '&subject=' + data.title +
            '&body=' + strip(data.description) +
            '&allday=' + (data.mode && data.mode === 'day');
    };

    /*
     * http://calendar.yahoo.com/
     * ?st=20161129T230000Z
     * &et=20161203T100000Z
     * &view=d
     * &v=60
     * &type=20
     * &title=some+title
     * &in_loc=somewhere
     * &desc=some+descrm
     */
    addtocalendar.yahooLink = function (data) {
        var base = 'https://calendar.yahoo.com/?v=60&view=d&type=20';

        var startStr = data.date_start.replace(' ', 'T');
        // console.log(startStr);
        var st = moment.tz(startStr, data.timezone);
        var endStr = data.date_end.replace(' ', 'T');
        // console.log(endStr);
        var end = moment.tz(endStr, data.timezone);

        var diff = moment.duration(end.diff(st));

        return base +
            '&ST=' + st.tz('UTC').format().replace(' ', 'T').replace('+00:00', 'Z').replace(/[-:]/g, '') +
            '&DUR=' + String('0' + diff.hours()).slice(-2) + String('0' + diff.minutes() % 60).slice(-2) +
            '&in_loc=' + data.location +
            '&title=' + data.title +
            '&desc=' + data.description;
    };

    addtocalendar.calendar_urls = {};

    addtocalendar.loadSettings = function (element) {
        var settings = {
            'language': 'auto',
            'show-list-on': 'click',
            'calendars': [
                'iCalendar',
                'Google Calendar',
                'Outlook',
                'Outlook Online',
                'Yahoo! Calendar'
            ],
            'secure': 'auto',
            'on-button-click': function () {
            },
            'on-calendar-click': function () {
            }
        };

        for (var option in settings) {
            var pname = 'data-' + option;
            var eattr = element.getAttribute(pname);
            if (eattr != null) {

                if (isArray(settings[option])) {
                    settings[option] = eattr.replace(/\s*,\s*/g, ',').replace(/^\s+|\s+$/g, '').split(',');
                    continue;
                }

                if (isFunc(settings[option])) {
                    var fn = window[eattr];
                    if (isFunc(fn)) {
                        settings[option] = fn;
                    } else {
                        settings[option] = eval('(function(mouseEvent){' + eattr + '})');
                    }
                    continue;
                }

                settings[option] = element.getAttribute(pname);
            }
        }

        return settings;
    };

    addtocalendar.fixDates = function (data) {
        var fixHelper = function (date, timezone, utc) {
            var res = /(\d\d\d\d)-(\d+)-(\d+) (\d\d):(\d\d) (..)/.exec(date)
            if (res) {
                //temp var to use for parsing and 24hr conversion
                var m = moment(
                    res[1] + String('0' + res[2]).slice(-2) + String('0' + res[3]).slice(-2) + 'T' + String('0' + res[4]).slice(-2) + String('0' + res[5]).slice(-2) + res[6],
                    "YYYYMMDDThhmmaa");

                //format string removes assumed timezone
                //ctor takes explicit timezone
                var mtz = moment.tz(m.format("YYYY-MM-DDTHH:mm:00"), timezone);

                //return same format as VF page uses
                return mtz.format("YYYY-MM-DD HH:mm:00");
            }
            if (utc) {
                var mtz = moment.tz(date, timezone).tz('UTC');
                return mtz.format("YYYY-MM-DD HH:mm:00");
            }
            return date;
        };

        data.date_start = fixHelper(data.date_start, data.timezone);
        data.date_end = fixHelper(data.date_end, data.timezone);
        data.date_start_utc = fixHelper(data.date_start, data.timezone, true);
        data.date_end_utc = fixHelper(data.date_end, data.timezone, true);
        return data;
    },

        addtocalendar.load = function () {

            var calendarsUrl = {
                'iCalendar': 'ical',
                'Google Calendar': 'google',
                'Outlook': 'outlook',
                'Outlook Online': 'outlookonline',
                'Yahoo! Calendar': 'yahoo'
            };
            var utz = (-(new Date()).getTimezoneOffset().toString());

            var languages = addtocalendar.languages;

            var dom = document.getElementsByClassName('addtocalendar');
            for (var tagnum = 0; tagnum < dom.length; tagnum++) {
                var settings = addtocalendar.loadSettings(dom[tagnum]);

                var protocol = 'http:';
                if (settings['secure'] === 'auto') {
                    protocol = location.protocol === 'https:' ? 'https:' : 'http:';
                } else if (settings['secure'] === 'true') {
                    protocol = 'https:';
                }

                var tag_id = dom[tagnum].id;
                var atc_button_title = languages['en'];
                if (settings['language'] === 'auto') {
                    var user_lang = "no_lang";
                    if (typeof navigator.language === "string") {
                        user_lang = navigator.language.substr(0, 2)
                    } else if (typeof navigator.browserLanguage === "string") {
                        user_lang = navigator.browserLanguage.substr(0, 2)
                    }

                    if (languages.hasOwnProperty(user_lang)) {
                        atc_button_title = languages[user_lang];
                    }
                } else if (languages.hasOwnProperty(settings['language'])) {
                    atc_button_title = languages[settings['language']];
                }

                var url_parameters = [
                    'utz=' + utz,
                    'uln=' + navigator.language,
                    'vjs=' + atc_version
                ];

                var cal_params = {};

                var addtocalendar_div = dom[tagnum].getElementsByTagName('var');
                var event_number = -1;
                for (var varnum = 0; varnum < addtocalendar_div.length; varnum++) {
                    var param_name = addtocalendar_div[varnum].className.replace("atc_", "").split(" ")[0];
                    var param_value = addtocalendar_div[varnum].innerHTML;

                    if (param_name === 'event') {
                        event_number++;
                        continue;
                    }
                    else if (param_name === 'location' && param_value === ' , ,  ') {
                        param_value = '';
                    }

                    if (param_name === addtocalendar_div[varnum].className) {
                        if (param_name === 'atc-body') {
                            atc_button_title = param_value;
                        }
                        continue;
                    }

                    if (event_number === -1) {
                        continue;
                    }

                    url_parameters.push('e[' + event_number + '][' + param_name + ']' + '=' + encodeURIComponent(param_value));
                    cal_params[param_name] = param_value;
                }

                cal_params = addtocalendar.fixDates(cal_params);


                var atcb_link_id_val = (tag_id === '' ? '' : (tag_id + '_link'));
                var atcb_list = document.createElement('ul');
                atcb_list.className = 'atcb-list';

                var atcb_link_id_val = (tag_id == '' ? '' : (tag_id + '_link'));
                var atcb_list = document.createElement('ul');
                atcb_list.className = 'atcb-list';

                var menu_links = '';
                window.icsFormatter.addEvent(cal_params.timezone, cal_params.title, cal_params.description, cal_params.location, cal_params.date_start, cal_params.date_end);
                for (let calendarType of settings['calendars']) {
                    if (!calendarsUrl.hasOwnProperty(calendarType)) {
                        continue;
                    }
                    const calendarLinks = {
                        'google': addtocalendar.googleLink(cal_params),
                        'outlookonline': addtocalendar.outlookLink(cal_params),
                        'yahoo': addtocalendar.yahooLink(cal_params)
                    };
                    const cal_id = calendarsUrl[calendarType];
                    const atcb_cal_link_id = (tag_id === '' ? '' :  tag_id + '_' + cal_id + '_link');
                    const menuLinkItem = document.createElement('li');
                    const menuLinkItemAnchor = document.createElement('a');
                    const menuLinkItemAnchorText = document.createTextNode(calendarType);
                    menuLinkItem.setAttribute('class','atcb-item');
                    menuLinkItemAnchor.setAttribute('class','atcb-item-link');
                    if(atcb_cal_link_id) {
                        menuLinkItemAnchor.setAttribute('id', atcb_cal_link_id);
                    }
                    // using event listner to download ics files for iCalendar and Outlook
                    if(!(cal_id === 'google' || cal_id === 'outlookonline' || cal_id === 'yahoo')) {
                        menuLinkItemAnchor.addEventListener('click',function(){
                            window.icsFormatter.download('event','ics');
                        });
                    }
                    // set up links to hosted calendars for Google Calendar, Outlook Online, and Yahoo!
                    else {
                        menuLinkItemAnchor.setAttribute('target','_blank');
                        menuLinkItemAnchor.setAttribute('ref','nofollow');
                        menuLinkItemAnchor.setAttribute('href',calendarLinks[cal_id]);
                    }
                    menuLinkItemAnchor.appendChild(menuLinkItemAnchorText);
                    menuLinkItem.appendChild(menuLinkItemAnchor);
                    atcb_list.appendChild(menuLinkItem);
                }
    
                var atcb_link;
                if (dom[tagnum].querySelector('.atcb-link') == undefined) {
                    atcb_link = document.createElement('a');
                    atcb_link.className = 'atcb-link';
                    atcb_link.innerHTML = atc_button_title;
                    atcb_link.id = atcb_link_id_val;
                    atcb_link.tabIndex = 1;

                    dom[tagnum].appendChild(atcb_link);
                    dom[tagnum].appendChild(atcb_list);
                } else {
                    atcb_link = dom[tagnum].querySelector('.atcb-link');
                    atcb_link.parentNode.appendChild(atcb_list);
                    atcb_link.tabIndex = 1;
                    if (atcb_link.id == '') {
                        atcb_link.id = atcb_link_id_val;
                    }
                }

                if (atcb_link.addEventListener) {
                    atcb_link.addEventListener('click', settings['on-button-click'], false);
                } else {
                    atcb_link.attachEvent('onclick', settings['on-button-click']);
                }

                var item_links = dom[tagnum].querySelectorAll('atcb-item-link');

                for (var varnum = 0; varnum < item_links.length; varnum++) {
                    var item_link = item_links[varnum];
                    if (item_link.addEventListener) {
                        item_link.addEventListener('click', settings['on-calendar-click'], false);
                    } else {
                        item_link.attachEvent('onclick', settings['on-calendar-click']);
                    }

                }
            }
        };
    addtocalendar.load();

    function strip(html) {
        var tmp = document.createElement("DIV");
        tmp.innerHTML = html;
        return tmp.textContent || tmp.innerText || "";
    }
}).bind(this,window, document);

// immediately invoke the creation of the calendars dropdown
loadCalendars();