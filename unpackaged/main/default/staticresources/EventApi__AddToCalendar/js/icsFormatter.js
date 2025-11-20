var icsFormatter = function () {
    'use strict';

    if (navigator.userAgent.indexOf('MSIE') > -1 && navigator.userAgent.indexOf('MSIE 10') == -1) {
        console.log('Unsupported Browser');
        return;
    }

    var SEPARATOR = (navigator.appVersion.indexOf('Win') !== -1) ? '\r\n' : '\n';
    var calendarEvents = [];
    var calendarStart = [
        'BEGIN:VCALENDAR',
        'VERSION:2.0'
    ].join(SEPARATOR);
    var calendarEnd = SEPARATOR + 'END:VCALENDAR';

    return {
        /**
         * Returns events array
         * @return {array} Events
         */
        'events': function () {
            return calendarEvents;
        },

        /**
         * Returns calendar
         * @return {string} Calendar in iCalendar format
         */
        'calendar': function () {
            return calendarStart + SEPARATOR + calendarEvents.join(SEPARATOR) + calendarEnd;
        },

        /**
         * Add event to the calendar
         * @param  {string} subject     Subject/Title of event
         * @param  {string} description Description of event
         * @param  {string} location    Location of event
         * @param  {string} begin       Beginning date of event
         * @param  {string} stop        Ending date of event
         */
        'addEvent': function (timezone,subject, description, location, begin, stop) {
            if (calendarEvents.length > 0) return;
            // I'm not in the mood to make these optional... So they are all required
            if (typeof subject === 'undefined' ||
                typeof description === 'undefined' ||
                typeof location === 'undefined' ||
                typeof begin === 'undefined' ||
                typeof stop === 'undefined'
            ) {
                return false;
            }

            subject = decodeURIComponent(subject);
            location = decodeURIComponent(location);
            description = decodeURIComponent(description);
            var div = document.createElement("div");
            div.innerHTML = description;
            description = div.innerText;

            const beginDate = new Date(begin);
            const start = moment.tz([
                beginDate.getFullYear(),
                beginDate.getMonth(),
                beginDate.getDate(),
                beginDate.getHours(),
                beginDate.getMinutes()
            ], timezone).format('YYYYMMDDTHHmmss');

            const endDate = new Date(stop);
            const end = moment.tz([
                endDate.getFullYear(),
                endDate.getMonth(),
                endDate.getDate(),
                endDate.getHours(),
                endDate.getMinutes()
            ], timezone).format('YYYYMMDDTHHmmss');

            const timeZoneParams = getTimeZoneParams(moment, timezone, beginDate);

            var calendarEvent = [
                'BEGIN:VTIMEZONE',
                'TZID:' + timezone,
                timeZoneParams +
                'END:VTIMEZONE',
                'BEGIN:VEVENT',
                'CLASS:PUBLIC',
                'DESCRIPTION:' + description,
                'DTSTART;TZID=' + timezone + ':' + start,
                'DTEND;TZID=' + timezone + ':' + end,
                'LOCATION:' + location,
                'SUMMARY;LANGUAGE=en-us:' + subject,
                'TRANSP:TRANSPARENT',
                'END:VEVENT'
            ].join(SEPARATOR);

            calendarEvents.push(calendarEvent);
            return calendarEvent;
        },

        /**
         * Download calendar using the saveAs function from filesave.js
         * @param  {string} filename Filename
         * @param  {string} ext      Extention
         */
        'download': function (filename, ext) {
            if (calendarEvents.length < 1) {
                return false;
            }

            ext = (typeof ext !== 'undefined') ? ext : 'ics';
            filename = (typeof filename !== 'undefined') ? filename : 'calendar';
            var calendar = calendarStart + SEPARATOR + calendarEvents.join(SEPARATOR) + calendarEnd;
            var blob;
            if (navigator.userAgent.indexOf('MSIE 10') === -1) { // chrome or firefox
                blob = new Blob([calendar]);
            } else { // ie
                var bb = new BlobBuilder();
                bb.append(calendar);
                blob = bb.getBlob('text/calendar;charset=utf8');
            }
            saveAs(blob, filename +'.'+ ext);
        }
    };
};

function getStartingIndex(dateInUse, zone) {
	let result = 0;
	try {
		const currentDateInMillis = new Date(dateInUse).getTime();
		for (let [index, i] of zone.untils.entries()) {
			if (
				i >= currentDateInMillis
			) {
				result = index;
				break;
			}
		}
	}
	catch(e) {
		console.log(e);
	}
	return result <= 0 ? 0 : result - 1;
}

function getTimeZoneParams(moment, timezone, dateInUse) {
    const zone = moment.tz.zone(timezone);
	const startingIndex = getStartingIndex(dateInUse, zone);
	const maxLoopCount = startingIndex + 3;
    let timeZoneParams = '';
    for(let i = startingIndex; i < maxLoopCount && i + 1 < zone.untils.length; i++) {
        const type = i%2 == 0 ? 'STANDARD' : 'DAYLIGHT';
        const startDate = moment.tz(zone.untils[i], timezone).format('YYYYMMDDTHHmmss');
		const endDate = moment.tz(zone.untils[i+1], timezone).format('YYYYMMDDTHHmmss');
        const tzOffsetTo = moment.tz(zone.untils[i], timezone).format('ZZ');
        const tzOffsetFrom = moment.tz(zone.untils[i+1], timezone).format('ZZ');
        const timeZoneItem = `BEGIN:${type}\n` +
            `DTSTART:${startDate}\n` +
            `TZOFFSETFROM:${tzOffsetFrom}\n` +
            `TZOFFSETTO:${tzOffsetTo}\n` +
			`DTEND:${endDate}\n` +
            `END:${type}\n`;
        timeZoneParams += timeZoneItem;
    }
    return timeZoneParams;
}

if (typeof define === "function" && define.amd) {
    /* AMD Format */
    define("icsFormatter", [], function () {
        return icsFormatter();
    });
} else if (typeof module === "object" && module.exports) {
    /* CommonJS Format */
    module.exports = icsFormatter();
} else {
    /* Plain Browser Support */
    window.icsFormatter = icsFormatter();
}
