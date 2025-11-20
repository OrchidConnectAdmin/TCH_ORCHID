!function(a,b){"function"==typeof define&&define.amd?define([],function(){return a.svg4everybody=b()}):"object"==typeof exports?module.exports=b():a.svg4everybody=b()}(this,function(){/*! svg4everybody v2.0.0 | github.com/jonathantneal/svg4everybody */
function a(a,b){if(b){var c=!a.getAttribute("viewBox")&&b.getAttribute("viewBox"),d=document.createDocumentFragment(),e=b.cloneNode(!0);for(c&&a.setAttribute("viewBox",c);e.childNodes.length;)d.appendChild(e.firstChild);a.appendChild(d)}}function b(b){b.onreadystatechange=function(){if(4===b.readyState){var c=document.createElement("x");c.innerHTML=b.responseText,b.s.splice(0).map(function(b){a(b[0],c.querySelector("#"+b[1].replace(/(\W)/g,"\\$1")))})}},b.onreadystatechange()}function c(c){function d(){for(var c;c=e[0];){var j=c.parentNode;if(j&&/svg/i.test(j.nodeName)){var k=c.getAttribute("xlink:href");if(f&&(!g||g(k,j,c))){var l=k.split("#"),m=l[0],n=l[1];if(j.removeChild(c),m.length){var o=i[m]=i[m]||new XMLHttpRequest;o.s||(o.s=[],o.open("GET",m),o.send()),o.s.push([j,n]),b(o)}else a(j,document.getElementById(n))}}}h(d,17)}c=c||{};var e=document.getElementsByTagName("use"),f="shim"in c?c.shim:/\bEdge\/12\b|\bTrident\/[567]\b|\bVersion\/7.0 Safari\b/.test(navigator.userAgent)||(navigator.userAgent.match(/AppleWebKit\/(\d+)/)||[])[1]<537,g=c.validate,h=window.requestAnimationFrame||setTimeout,i={};f&&d()}return c});



// ===============================
// SLDS INPUT SPINNER
// ===============================

(function ( $ ) {

	$.fn.sldsInputSpinner = function( options ) {

		var settings = $.extend({
			upClass: 'default',
			downClass: 'default',
			center: true
			}, options );

		return this.each(function(e) {
			var self = $(this);
			var clone = self.clone();

			var min = self.attr('min');
			var max = self.attr('max');

			function setText(n) {
				if((min && n < min) || (max && n > max)) {
					return false;
				}

				clone.focus().val(n);
				return true;
			}

			var group = $("<div class='slds-button-group'></div>");
			var down = $("<button type='button'><span class='slds-text-heading--small'><strong>-</strong></span></button>").attr('class', 'slds-button slds-button--icon-border slds-border-radius--right__none ' + settings.downClass).click(function() {
				setText(parseInt(clone.val()) - 1);
			});
			var up = $("<button type='button'><span class='slds-text-heading--small'><strong>+</strong></span></button>").attr('class', 'slds-button slds-button--icon-border slds-border-radius--left__none ' + settings.upClass).click(function() {
				setText(parseInt(clone.val()) + 1);
			});
			$("<span class='slds-input-group--button'></span>").append(down).appendTo(group);
			clone.appendTo(group);
			if(clone) {
				clone.css('text-align', 'center');
			}
			$("<span class='slds-input-group--button'></span>").append(up).appendTo(group);

			// remove spins from original
			clone.prop('type', 'text').keydown(function (e) {
				if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
					(e.keyCode == 65 && e.ctrlKey === true) ||
					(e.keyCode >= 35 && e.keyCode <= 39)) {
					return;
				}
				if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
					e.preventDefault();
				}

				var c = String.fromCharCode(e.which);
				var n = parseInt(clone.val() + c);

				if((min && n < min) || (max && n > max)) {
					e.preventDefault();
				}
			});

			self.replaceWith(group);
		});
	};
} ( jQuery ));




/**
 * sifter.js
 * Copyright (c) 2013 Brian Reavis & contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at:
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 *
 * @author Brian Reavis <brian@thirdroute.com>
 */

(function(root, factory) {
	if (typeof define === 'function' && define.amd) {
		define('sifter', factory);
	} else if (typeof exports === 'object') {
		module.exports = factory();
	} else {
		root.Sifter = factory();
	}
}(this, function() {

	/**
	 * Textually searches arrays and hashes of objects
	 * by property (or multiple properties). Designed
	 * specifically for autocomplete.
	 *
	 * @constructor
	 * @param {array|object} items
	 * @param {object} items
	 */
	var Sifter = function(items, settings) {
		this.items = items;
		this.settings = settings || {diacritics: true};
	};

	/**
	 * Splits a search string into an array of individual
	 * regexps to be used to match results.
	 *
	 * @param {string} query
	 * @returns {array}
	 */
	Sifter.prototype.tokenize = function(query) {
		query = trim(String(query || '').toLowerCase());
		if (!query || !query.length) return [];

		var i, n, regex, letter;
		var tokens = [];
		var words = query.split(/ +/);

		for (i = 0, n = words.length; i < n; i++) {
			regex = escape_regex(words[i]);
			if (this.settings.diacritics) {
				for (letter in DIACRITICS) {
					if (DIACRITICS.hasOwnProperty(letter)) {
						regex = regex.replace(new RegExp(letter, 'g'), DIACRITICS[letter]);
					}
				}
			}
			tokens.push({
				string : words[i],
				regex  : new RegExp(regex, 'i')
			});
		}

		return tokens;
	};

	/**
	 * Iterates over arrays and hashes.
	 *
	 * ```
	 * this.iterator(this.items, function(item, id) {
	 *    // invoked for each item
	 * });
	 * ```
	 *
	 * @param {array|object} object
	 */
	Sifter.prototype.iterator = function(object, callback) {
		var iterator;
		if (is_array(object)) {
			iterator = Array.prototype.forEach || function(callback) {
				for (var i = 0, n = this.length; i < n; i++) {
					callback(this[i], i, this);
				}
			};
		} else {
			iterator = function(callback) {
				for (var key in this) {
					if (this.hasOwnProperty(key)) {
						callback(this[key], key, this);
					}
				}
			};
		}

		iterator.apply(object, [callback]);
	};

	/**
	 * Returns a function to be used to score individual results.
	 *
	 * Good matches will have a higher score than poor matches.
	 * If an item is not a match, 0 will be returned by the function.
	 *
	 * @param {object|string} search
	 * @param {object} options (optional)
	 * @returns {function}
	 */
	Sifter.prototype.getScoreFunction = function(search, options) {
		var self, fields, tokens, token_count;

		self        = this;
		search      = self.prepareSearch(search, options);
		tokens      = search.tokens;
		fields      = search.options.fields;
		token_count = tokens.length;

		/**
		 * Calculates how close of a match the
		 * given value is against a search token.
		 *
		 * @param {mixed} value
		 * @param {object} token
		 * @return {number}
		 */
		var scoreValue = function(value, token) {
			var score, pos;

			if (!value) return 0;
			value = String(value || '');
			pos = value.search(token.regex);
			if (pos === -1) return 0;
			score = token.string.length / value.length;
			if (pos === 0) score += 0.5;
			return score;
		};

		/**
		 * Calculates the score of an object
		 * against the search query.
		 *
		 * @param {object} token
		 * @param {object} data
		 * @return {number}
		 */
		var scoreObject = (function() {
			var field_count = fields.length;
			if (!field_count) {
				return function() { return 0; };
			}
			if (field_count === 1) {
				return function(token, data) {
					return scoreValue(data[fields[0]], token);
				};
			}
			return function(token, data) {
				for (var i = 0, sum = 0; i < field_count; i++) {
					sum += scoreValue(data[fields[i]], token);
				}
				return sum / field_count;
			};
		})();

		if (!token_count) {
			return function() { return 0; };
		}
		if (token_count === 1) {
			return function(data) {
				return scoreObject(tokens[0], data);
			};
		}

		if (search.options.conjunction === 'and') {
			return function(data) {
				var score;
				for (var i = 0, sum = 0; i < token_count; i++) {
					score = scoreObject(tokens[i], data);
					if (score <= 0) return 0;
					sum += score;
				}
				return sum / token_count;
			};
		} else {
			return function(data) {
				for (var i = 0, sum = 0; i < token_count; i++) {
					sum += scoreObject(tokens[i], data);
				}
				return sum / token_count;
			};
		}
	};

	/**
	 * Returns a function that can be used to compare two
	 * results, for sorting purposes. If no sorting should
	 * be performed, `null` will be returned.
	 *
	 * @param {string|object} search
	 * @param {object} options
	 * @return function(a,b)
	 */
	Sifter.prototype.getSortFunction = function(search, options) {
		var i, n, self, field, fields, fields_count, multiplier, multipliers, get_field, implicit_score, sort;

		self   = this;
		search = self.prepareSearch(search, options);
		sort   = (!search.query && options.sort_empty) || options.sort;

		/**
		 * Fetches the specified sort field value
		 * from a search result item.
		 *
		 * @param  {string} name
		 * @param  {object} result
		 * @return {mixed}
		 */
		get_field = function(name, result) {
			if (name === '$score') return result.score;
			return self.items[result.id][name];
		};

		// parse options
		fields = [];
		if (sort) {
			for (i = 0, n = sort.length; i < n; i++) {
				if (search.query || sort[i].field !== '$score') {
					fields.push(sort[i]);
				}
			}
		}

		// the "$score" field is implied to be the primary
		// sort field, unless it's manually specified
		if (search.query) {
			implicit_score = true;
			for (i = 0, n = fields.length; i < n; i++) {
				if (fields[i].field === '$score') {
					implicit_score = false;
					break;
				}
			}
			if (implicit_score) {
				fields.unshift({field: '$score', direction: 'desc'});
			}
		} else {
			for (i = 0, n = fields.length; i < n; i++) {
				if (fields[i].field === '$score') {
					fields.splice(i, 1);
					break;
				}
			}
		}

		multipliers = [];
		for (i = 0, n = fields.length; i < n; i++) {
			multipliers.push(fields[i].direction === 'desc' ? -1 : 1);
		}

		// build function
		fields_count = fields.length;
		if (!fields_count) {
			return null;
		} else if (fields_count === 1) {
			field = fields[0].field;
			multiplier = multipliers[0];
			return function(a, b) {
				return multiplier * cmp(
					get_field(field, a),
					get_field(field, b)
				);
			};
		} else {
			return function(a, b) {
				var i, result, a_value, b_value, field;
				for (i = 0; i < fields_count; i++) {
					field = fields[i].field;
					result = multipliers[i] * cmp(
						get_field(field, a),
						get_field(field, b)
					);
					if (result) return result;
				}
				return 0;
			};
		}
	};

	/**
	 * Parses a search query and returns an object
	 * with tokens and fields ready to be populated
	 * with results.
	 *
	 * @param {string} query
	 * @param {object} options
	 * @returns {object}
	 */
	Sifter.prototype.prepareSearch = function(query, options) {
		if (typeof query === 'object') return query;

		options = extend({}, options);

		var option_fields     = options.fields;
		var option_sort       = options.sort;
		var option_sort_empty = options.sort_empty;

		if (option_fields && !is_array(option_fields)) options.fields = [option_fields];
		if (option_sort && !is_array(option_sort)) options.sort = [option_sort];
		if (option_sort_empty && !is_array(option_sort_empty)) options.sort_empty = [option_sort_empty];

		return {
			options : options,
			query   : String(query || '').toLowerCase(),
			tokens  : this.tokenize(query),
			total   : 0,
			items   : []
		};
	};

	/**
	 * Searches through all items and returns a sorted array of matches.
	 *
	 * The `options` parameter can contain:
	 *
	 *   - fields {string|array}
	 *   - sort {array}
	 *   - score {function}
	 *   - filter {bool}
	 *   - limit {integer}
	 *
	 * Returns an object containing:
	 *
	 *   - options {object}
	 *   - query {string}
	 *   - tokens {array}
	 *   - total {int}
	 *   - items {array}
	 *
	 * @param {string} query
	 * @param {object} options
	 * @returns {object}
	 */
	Sifter.prototype.search = function(query, options) {
		var self = this, value, score, search, calculateScore;
		var fn_sort;
		var fn_score;

		search  = this.prepareSearch(query, options);
		options = search.options;
		query   = search.query;

		// generate result scoring function
		fn_score = options.score || self.getScoreFunction(search);

		// perform search and sort
		if (query.length) {
			self.iterator(self.items, function(item, id) {
				score = fn_score(item);
				if (options.filter === false || score > 0) {
					search.items.push({'score': score, 'id': id});
				}
			});
		} else {
			self.iterator(self.items, function(item, id) {
				search.items.push({'score': 1, 'id': id});
			});
		}

		fn_sort = self.getSortFunction(search, options);
		if (fn_sort) search.items.sort(fn_sort);

		// apply limits
		search.total = search.items.length;
		if (typeof options.limit === 'number') {
			search.items = search.items.slice(0, options.limit);
		}

		return search;
	};

	// utilities
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	var cmp = function(a, b) {
		if (typeof a === 'number' && typeof b === 'number') {
			return a > b ? 1 : (a < b ? -1 : 0);
		}
		a = asciifold(String(a || ''));
		b = asciifold(String(b || ''));
		if (a > b) return 1;
		if (b > a) return -1;
		return 0;
	};

	var extend = function(a, b) {
		var i, n, k, object;
		for (i = 1, n = arguments.length; i < n; i++) {
			object = arguments[i];
			if (!object) continue;
			for (k in object) {
				if (object.hasOwnProperty(k)) {
					a[k] = object[k];
				}
			}
		}
		return a;
	};

	var trim = function(str) {
		return (str + '').replace(/^\s+|\s+$|/g, '');
	};

	var escape_regex = function(str) {
		return (str + '').replace(/([.?*+^$[\]\\(){}|-])/g, '\\$1');
	};

	var is_array = Array.isArray || ($ && $.isArray) || function(object) {
		return Object.prototype.toString.call(object) === '[object Array]';
	};

	var DIACRITICS = {
		'a': '[aÀÁÂÃÄÅàáâãäåĀāąĄ]',
		'c': '[cÇçćĆčČ]',
		'd': '[dđĐďĎ]',
		'e': '[eÈÉÊËèéêëěĚĒēęĘ]',
		'i': '[iÌÍÎÏìíîïĪī]',
		'l': '[lłŁ]',
		'n': '[nÑñňŇńŃ]',
		'o': '[oÒÓÔÕÕÖØòóôõöøŌō]',
		'r': '[rřŘ]',
		's': '[sŠšśŚ]',
		't': '[tťŤ]',
		'u': '[uÙÚÛÜùúûüůŮŪū]',
		'y': '[yŸÿýÝ]',
		'z': '[zŽžżŻźŹ]'
	};

	var asciifold = (function() {
		var i, n, k, chunk;
		var foreignletters = '';
		var lookup = {};
		for (k in DIACRITICS) {
			if (DIACRITICS.hasOwnProperty(k)) {
				chunk = DIACRITICS[k].substring(2, DIACRITICS[k].length - 1);
				foreignletters += chunk;
				for (i = 0, n = chunk.length; i < n; i++) {
					lookup[chunk.charAt(i)] = k;
				}
			}
		}
		var regexp = new RegExp('[' +  foreignletters + ']', 'g');
		return function(str) {
			return str.replace(regexp, function(foreignletter) {
				return lookup[foreignletter];
			}).toLowerCase();
		};
	})();


	// export
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	return Sifter;
}));



/**
 * microplugin.js
 * Copyright (c) 2013 Brian Reavis & contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at:
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 *
 * @author Brian Reavis <brian@thirdroute.com>
 */

(function(root, factory) {
	if (typeof define === 'function' && define.amd) {
		define('microplugin', factory);
	} else if (typeof exports === 'object') {
		module.exports = factory();
	} else {
		root.MicroPlugin = factory();
	}
}(this, function() {
	var MicroPlugin = {};

	MicroPlugin.mixin = function(Interface) {
		Interface.plugins = {};

		/**
		 * Initializes the listed plugins (with options).
		 * Acceptable formats:
		 *
		 * List (without options):
		 *   ['a', 'b', 'c']
		 *
		 * List (with options):
		 *   [{'name': 'a', options: {}}, {'name': 'b', options: {}}]
		 *
		 * Hash (with options):
		 *   {'a': { ... }, 'b': { ... }, 'c': { ... }}
		 *
		 * @param {mixed} plugins
		 */
		Interface.prototype.initializePlugins = function(plugins) {
			var i, n, key;
			var self  = this;
			var queue = [];

			self.plugins = {
				names     : [],
				settings  : {},
				requested : {},
				loaded    : {}
			};

			if (utils.isArray(plugins)) {
				for (i = 0, n = plugins.length; i < n; i++) {
					if (typeof plugins[i] === 'string') {
						queue.push(plugins[i]);
					} else {
						self.plugins.settings[plugins[i].name] = plugins[i].options;
						queue.push(plugins[i].name);
					}
				}
			} else if (plugins) {
				for (key in plugins) {
					if (plugins.hasOwnProperty(key)) {
						self.plugins.settings[key] = plugins[key];
						queue.push(key);
					}
				}
			}

			while (queue.length) {
				self.require(queue.shift());
			}
		};

		Interface.prototype.loadPlugin = function(name) {
			var self    = this;
			var plugins = self.plugins;
			var plugin  = Interface.plugins[name];

			if (!Interface.plugins.hasOwnProperty(name)) {
				throw new Error('Unable to find "' +  name + '" plugin');
			}

			plugins.requested[name] = true;
			plugins.loaded[name] = plugin.fn.apply(self, [self.plugins.settings[name] || {}]);
			plugins.names.push(name);
		};

		/**
		 * Initializes a plugin.
		 *
		 * @param {string} name
		 */
		Interface.prototype.require = function(name) {
			var self = this;
			var plugins = self.plugins;

			if (!self.plugins.loaded.hasOwnProperty(name)) {
				if (plugins.requested[name]) {
					throw new Error('Plugin has circular dependency ("' + name + '")');
				}
				self.loadPlugin(name);
			}

			return plugins.loaded[name];
		};

		/**
		 * Registers a plugin.
		 *
		 * @param {string} name
		 * @param {function} fn
		 */
		Interface.define = function(name, fn) {
			Interface.plugins[name] = {
				'name' : name,
				'fn'   : fn
			};
		};
	};

	var utils = {
		isArray: Array.isArray || function(vArg) {
			return Object.prototype.toString.call(vArg) === '[object Array]';
		}
	};

	return MicroPlugin;
}));

/**!
 * Sortable
 * @author	RubaXa   <trash@rubaxa.org>
 * @license MIT
 */


(function (factory) {
	"use strict";

	if (typeof define === "function" && define.amd) {
		define(factory);
	}
	else if (typeof module != "undefined" && typeof module.exports != "undefined") {
		module.exports = factory();
	}
	else if (typeof Package !== "undefined") {
		Sortable = factory();  // export for Meteor.js
	}
	else {
		/* jshint sub:true */
		window["Sortable"] = factory();
	}
})(function () {
	"use strict";
	
	if (typeof window == "undefined" || typeof window.document == "undefined") {
		return function () {
			throw new Error("Sortable.js requires a window with a document");
		};
	}

	var dragEl,
		parentEl,
		ghostEl,
		cloneEl,
		rootEl,
		nextEl,

		scrollEl,
		scrollParentEl,

		lastEl,
		lastCSS,
		lastParentCSS,

		oldIndex,
		newIndex,

		activeGroup,
		autoScroll = {},

		tapEvt,
		touchEvt,

		moved,

		/** @const */
		RSPACE = /\s+/g,

		expando = 'Sortable' + (new Date).getTime(),

		win = window,
		document = win.document,
		parseInt = win.parseInt,

		supportDraggable = !!('draggable' in document.createElement('div')),
		supportCssPointerEvents = (function (el) {
			el = document.createElement('x');
			el.style.cssText = 'pointer-events:auto';
			return el.style.pointerEvents === 'auto';
		})(),

		_silent = false,

		abs = Math.abs,
		slice = [].slice,

		touchDragOverListeners = [],

		_autoScroll = _throttle(function (/**Event*/evt, /**Object*/options, /**HTMLElement*/rootEl) {
			// Bug: https://bugzilla.mozilla.org/show_bug.cgi?id=505521
			if (rootEl && options.scroll) {
				var el,
					rect,
					sens = options.scrollSensitivity,
					speed = options.scrollSpeed,

					x = evt.clientX,
					y = evt.clientY,

					winWidth = window.innerWidth,
					winHeight = window.innerHeight,

					vx,
					vy
				;

				// Delect scrollEl
				if (scrollParentEl !== rootEl) {
					scrollEl = options.scroll;
					scrollParentEl = rootEl;

					if (scrollEl === true) {
						scrollEl = rootEl;

						do {
							if ((scrollEl.offsetWidth < scrollEl.scrollWidth) ||
								(scrollEl.offsetHeight < scrollEl.scrollHeight)
							) {
								break;
							}
							/* jshint boss:true */
						} while (scrollEl = scrollEl.parentNode);
					}
				}

				if (scrollEl) {
					el = scrollEl;
					rect = scrollEl.getBoundingClientRect();
					vx = (abs(rect.right - x) <= sens) - (abs(rect.left - x) <= sens);
					vy = (abs(rect.bottom - y) <= sens) - (abs(rect.top - y) <= sens);
				}


				if (!(vx || vy)) {
					vx = (winWidth - x <= sens) - (x <= sens);
					vy = (winHeight - y <= sens) - (y <= sens);

					/* jshint expr:true */
					(vx || vy) && (el = win);
				}


				if (autoScroll.vx !== vx || autoScroll.vy !== vy || autoScroll.el !== el) {
					autoScroll.el = el;
					autoScroll.vx = vx;
					autoScroll.vy = vy;

					clearInterval(autoScroll.pid);

					if (el) {
						autoScroll.pid = setInterval(function () {
							if (el === win) {
								win.scrollTo(win.pageXOffset + vx * speed, win.pageYOffset + vy * speed);
							} else {
								vy && (el.scrollTop += vy * speed);
								vx && (el.scrollLeft += vx * speed);
							}
						}, 24);
					}
				}
			}
		}, 30),

		_prepareGroup = function (options) {
			var group = options.group;

			if (!group || typeof group != 'object') {
				group = options.group = {name: group};
			}

			['pull', 'put'].forEach(function (key) {
				if (!(key in group)) {
					group[key] = true;
				}
			});

			options.groups = ' ' + group.name + (group.put.join ? ' ' + group.put.join(' ') : '') + ' ';
		}
	;



	/**
	 * @class  Sortable
	 * @param  {HTMLElement}  el
	 * @param  {Object}       [options]
	 */
	function Sortable(el, options) {
		if (!(el && el.nodeType && el.nodeType === 1)) {
			throw 'Sortable: `el` must be HTMLElement, and not ' + {}.toString.call(el);
		}

		this.el = el; // root element
		this.options = options = _extend({}, options);


		// Export instance
		el[expando] = this;


		// Default options
		var defaults = {
			group: Math.random(),
			sort: true,
			disabled: false,
			store: null,
			handle: null,
			scroll: true,
			scrollSensitivity: 30,
			scrollSpeed: 10,
			draggable: /[uo]l/i.test(el.nodeName) ? 'li' : '>*',
			ghostClass: 'sortable-ghost',
			chosenClass: 'sortable-chosen',
			ignore: 'a, img',
			filter: null,
			animation: 0,
			setData: function (dataTransfer, dragEl) {
				dataTransfer.setData('Text', dragEl.textContent);
			},
			dropBubble: false,
			dragoverBubble: false,
			dataIdAttr: 'data-id',
			delay: 0,
			forceFallback: false,
			fallbackClass: 'sortable-fallback',
			fallbackOnBody: false
		};


		// Set default options
		for (var name in defaults) {
			!(name in options) && (options[name] = defaults[name]);
		}

		_prepareGroup(options);

		// Bind all private methods
		for (var fn in this) {
			if (fn.charAt(0) === '_') {
				this[fn] = this[fn].bind(this);
			}
		}

		// Setup drag mode
		this.nativeDraggable = options.forceFallback ? false : supportDraggable;

		// Bind events
		_on(el, 'mousedown', this._onTapStart);
		_on(el, 'touchstart', this._onTapStart);

		if (this.nativeDraggable) {
			var self = this;
			_on(el, 'dragover', $A.getCallback(function(e){
				handleEventManually(e,self);
			}));
			_on(el, 'dragenter', $A.getCallback(function(e){
				handleEventManually(e,self);
			}));
		}

		touchDragOverListeners.push(this._onDragOver);

		// Restore sorting
		options.store && this.sort(options.store.get(this));
	}


	Sortable.prototype = /** @lends Sortable.prototype */ {
		constructor: Sortable,

		_onTapStart: function (/** Event|TouchEvent */evt) {
			var _this = this,
				el = this.el,
				options = this.options,
				type = evt.type,
				touch = evt.touches && evt.touches[0],
				target = (touch || evt).target,
				originalTarget = evt.target.shadowRoot && evt.path[0] || target,
				filter = options.filter;

			if (type === 'mousedown' && evt.button !== 0 || options.disabled) {
				return; // only left button or enabled
			}

			target = _closest(target, options.draggable, el);

			if (!target) {
				return;
			}

			// get the index of the dragged element within its parent
			oldIndex = _index(target, options.draggable);

			// Check filter
			if (typeof filter === 'function') {
				if (filter.call(this, evt, target, this)) {
					_dispatchEvent(_this, originalTarget, 'filter', target, el, oldIndex);
					evt.preventDefault();
					return; // cancel dnd
				}
			}
			else if (filter) {
				filter = filter.split(',').some(function (criteria) {
					criteria = _closest(originalTarget, criteria.trim(), el);

					if (criteria) {
						_dispatchEvent(_this, criteria, 'filter', target, el, oldIndex);
						return true;
					}
				});

				if (filter) {
					evt.preventDefault();
					return; // cancel dnd
				}
			}


			if (options.handle && !_closest(originalTarget, options.handle, el)) {
				return;
			}


			// Prepare `dragstart`
			this._prepareDragStart(evt, touch, target);
		},

		_prepareDragStart: function (/** Event */evt, /** Touch */touch, /** HTMLElement */target) {
			var _this = this,
				el = _this.el,
				options = _this.options,
				ownerDocument = el.ownerDocument,
				dragStartFn;

			if (target && !dragEl && (target.parentNode === el)) {
				tapEvt = evt;

				rootEl = el;
				dragEl = target;
				parentEl = dragEl.parentNode;
				nextEl = dragEl.nextSibling;
				activeGroup = options.group;

				dragStartFn = function () {
					// Delayed drag has been triggered
					// we can re-enable the events: touchmove/mousemove
					_this._disableDelayedDrag();

					// Make the element draggable
					dragEl.draggable = true;

					// Chosen item
					_toggleClass(dragEl, _this.options.chosenClass, true);

					// Bind the events: dragstart/dragend
					_this._triggerDragStart(touch);
				};

				// Disable "draggable"
				options.ignore.split(',').forEach(function (criteria) {
					_find(dragEl, criteria.trim(), _disableDraggable);
				});

				_on(ownerDocument, 'mouseup', _this._onDrop);
				_on(ownerDocument, 'touchend', _this._onDrop);
				_on(ownerDocument, 'touchcancel', _this._onDrop);

				if (options.delay) {
					// If the user moves the pointer or let go the click or touch
					// before the delay has been reached:
					// disable the delayed drag
					_on(ownerDocument, 'mouseup', _this._disableDelayedDrag);
					_on(ownerDocument, 'touchend', _this._disableDelayedDrag);
					_on(ownerDocument, 'touchcancel', _this._disableDelayedDrag);
					_on(ownerDocument, 'mousemove', _this._disableDelayedDrag);
					_on(ownerDocument, 'touchmove', _this._disableDelayedDrag);

					_this._dragStartTimer = setTimeout(dragStartFn, options.delay);
				} else {
					dragStartFn();
				}
			}
		},

		_disableDelayedDrag: function () {
			var ownerDocument = this.el.ownerDocument;

			clearTimeout(this._dragStartTimer);
			_off(ownerDocument, 'mouseup', this._disableDelayedDrag);
			_off(ownerDocument, 'touchend', this._disableDelayedDrag);
			_off(ownerDocument, 'touchcancel', this._disableDelayedDrag);
			_off(ownerDocument, 'mousemove', this._disableDelayedDrag);
			_off(ownerDocument, 'touchmove', this._disableDelayedDrag);
		},

		_triggerDragStart: function (/** Touch */touch) {
			if (touch) {
				// Touch device support
				tapEvt = {
					target: dragEl,
					clientX: touch.clientX,
					clientY: touch.clientY
				};

				this._onDragStart(tapEvt, 'touch');
			}
			else if (!this.nativeDraggable) {
				this._onDragStart(tapEvt, true);
			}
			else {
				var self = this;
				_on(dragEl, 'dragend', $A.getCallback(function(e){
					handleEventManually(e,self);
				}));
				_on(rootEl, 'dragstart', this._onDragStart);
			}

			try {
				if (document.selection) {					
					// Timeout neccessary for IE9					
					setTimeout(function () {
						document.selection.empty();
					});					
				} else {
					window.getSelection().removeAllRanges();
				}
			} catch (err) {
			}
		},

		_dragStarted: function () {
			if (rootEl && dragEl) {
				// Apply effect
				_toggleClass(dragEl, this.options.ghostClass, true);

				Sortable.active = this;

				// Drag start event
				_dispatchEvent(this, rootEl, 'start', dragEl, rootEl, oldIndex);
			}
		},

		_emulateDragOver: function () {
			if (touchEvt) {
				if (this._lastX === touchEvt.clientX && this._lastY === touchEvt.clientY) {
					return;
				}

				this._lastX = touchEvt.clientX;
				this._lastY = touchEvt.clientY;

				if (!supportCssPointerEvents) {
					_css(ghostEl, 'display', 'none');
				}

				var target = document.elementFromPoint(touchEvt.clientX, touchEvt.clientY),
					parent = target,
					groupName = ' ' + this.options.group.name + '',
					i = touchDragOverListeners.length;

				if (parent) {
					do {
						if (parent[expando] && parent[expando].options.groups.indexOf(groupName) > -1) {
							while (i--) {
								touchDragOverListeners[i]({
									clientX: touchEvt.clientX,
									clientY: touchEvt.clientY,
									target: target,
									rootEl: parent
								});
							}

							break;
						}

						target = parent; // store last element
					}
					/* jshint boss:true */
					while (parent = parent.parentNode);
				}

				if (!supportCssPointerEvents) {
					_css(ghostEl, 'display', '');
				}
			}
		},


		_onTouchMove: function (/**TouchEvent*/evt) {
			if (tapEvt) {
				// only set the status to dragging, when we are actually dragging
				if (!Sortable.active) {
					this._dragStarted();
				}

				// as well as creating the ghost element on the document body
				this._appendGhost();

				var touch = evt.touches ? evt.touches[0] : evt,
					dx = touch.clientX - tapEvt.clientX,
					dy = touch.clientY - tapEvt.clientY,
					translate3d = evt.touches ? 'translate3d(' + dx + 'px,' + dy + 'px,0)' : 'translate(' + dx + 'px,' + dy + 'px)';

				moved = true;
				touchEvt = touch;

				_css(ghostEl, 'webkitTransform', translate3d);
				_css(ghostEl, 'mozTransform', translate3d);
				_css(ghostEl, 'msTransform', translate3d);
				_css(ghostEl, 'transform', translate3d);

				evt.preventDefault();
			}
		},

		_appendGhost: function () {
			if (!ghostEl) {
				var rect = dragEl.getBoundingClientRect(),
					css = _css(dragEl),
					options = this.options,
					ghostRect;

				ghostEl = dragEl.cloneNode(true);

				_toggleClass(ghostEl, options.ghostClass, false);
				_toggleClass(ghostEl, options.fallbackClass, true);

				_css(ghostEl, 'top', rect.top - parseInt(css.marginTop, 10));
				_css(ghostEl, 'left', rect.left - parseInt(css.marginLeft, 10));
				_css(ghostEl, 'width', rect.width);
				_css(ghostEl, 'height', rect.height);
				_css(ghostEl, 'opacity', '0.8');
				_css(ghostEl, 'position', 'fixed');
				_css(ghostEl, 'zIndex', '100000');
				_css(ghostEl, 'pointerEvents', 'none');

				options.fallbackOnBody && document.body.appendChild(ghostEl) || rootEl.appendChild(ghostEl);

				// Fixing dimensions.
				ghostRect = ghostEl.getBoundingClientRect();
				_css(ghostEl, 'width', rect.width * 2 - ghostRect.width);
				_css(ghostEl, 'height', rect.height * 2 - ghostRect.height);
			}
		},

		_onDragStart: function (/**Event*/evt, /**boolean*/useFallback) {
			var dataTransfer = evt.dataTransfer,
				options = this.options;

			this._offUpEvents();

			if (activeGroup.pull == 'clone') {
				cloneEl = dragEl.cloneNode(true);
				_css(cloneEl, 'display', 'none');
				rootEl.insertBefore(cloneEl, dragEl);
			}

			if (useFallback) {

				if (useFallback === 'touch') {
					// Bind touch events
					_on(document, 'touchmove', this._onTouchMove);
					_on(document, 'touchend', this._onDrop);
					_on(document, 'touchcancel', this._onDrop);
				} else {
					// Old brwoser
					_on(document, 'mousemove', this._onTouchMove);
					_on(document, 'mouseup', this._onDrop);
				}

				this._loopId = setInterval(this._emulateDragOver, 50);
			}
			else {
				if (dataTransfer) {
					dataTransfer.effectAllowed = 'move';
					options.setData && options.setData.call(this, dataTransfer, dragEl);
				}

				var self = this;
				_on(document, 'drop', $A.getCallback(function(e){
					handleEventManually(e,self);
				}));
				setTimeout(this._dragStarted, 0);
			}
		},

		_onDragOver: function (/**Event*/evt) {
			var el = this.el,
				target,
				dragRect,
				revert,
				options = this.options,
				group = options.group,
				groupPut = group.put,
				isOwner = (activeGroup === group),
				canSort = options.sort;

			if (evt.preventDefault !== void 0) {
				evt.preventDefault();
				!options.dragoverBubble && evt.stopPropagation();
			}

			moved = true;

			if (activeGroup && !options.disabled &&
				(isOwner
					? canSort || (revert = !rootEl.contains(dragEl)) // Reverting item into the original list
					: activeGroup.pull && groupPut && (
						(activeGroup.name === group.name) || // by Name
						(groupPut.indexOf && ~groupPut.indexOf(activeGroup.name)) // by Array
					)
				) &&
				(evt.rootEl === void 0 || evt.rootEl === this.el) // touch fallback
			) {
				// Smart auto-scrolling
				_autoScroll(evt, options, this.el);

				if (_silent) {
					return;
				}

				target = _closest(evt.target, options.draggable, el);
				dragRect = dragEl.getBoundingClientRect();

				if (revert) {
					_cloneHide(true);

					if (cloneEl || nextEl) {
						rootEl.insertBefore(dragEl, cloneEl || nextEl);
					}
					else if (!canSort) {
						rootEl.appendChild(dragEl);
					}

					return;
				}


				if ((el.children.length === 0) || (el.children[0] === ghostEl) ||
					(el === evt.target) && (target = _ghostIsLast(el, evt))
				) {

					if (target) {
						if (target.animated) {
							return;
						}

						targetRect = target.getBoundingClientRect();
					}

					_cloneHide(isOwner);

					if (_onMove(rootEl, el, dragEl, dragRect, target, targetRect) !== false) {
						if (!dragEl.contains(el)) {
							el.appendChild(dragEl);
							parentEl = el; // actualization
						}

						this._animate(dragRect, dragEl);
						target && this._animate(targetRect, target);
					}
				}
				else if (target && !target.animated && target !== dragEl && (target.parentNode[expando] !== void 0)) {
					if (lastEl !== target) {
						lastEl = target;
						lastCSS = _css(target);
						lastParentCSS = _css(target.parentNode);
					}


					var targetRect = target.getBoundingClientRect(),
						width = targetRect.right - targetRect.left,
						height = targetRect.bottom - targetRect.top,
						floating = /left|right|inline/.test(lastCSS.cssFloat + lastCSS.display)
							|| (lastParentCSS.display == 'flex' && lastParentCSS['flex-direction'].indexOf('row') === 0),
						isWide = (target.offsetWidth > dragEl.offsetWidth),
						isLong = (target.offsetHeight > dragEl.offsetHeight),
						halfway = (floating ? (evt.clientX - targetRect.left) / width : (evt.clientY - targetRect.top) / height) > 0.5,
						nextSibling = target.nextElementSibling,
						moveVector = _onMove(rootEl, el, dragEl, dragRect, target, targetRect),
						after
					;

					if (moveVector !== false) {
						_silent = true;
						setTimeout(_unsilent, 30);

						_cloneHide(isOwner);

						if (moveVector === 1 || moveVector === -1) {
							after = (moveVector === 1);
						}
						else if (floating) {
							var elTop = dragEl.offsetTop,
								tgTop = target.offsetTop;

							if (elTop === tgTop) {
								after = (target.previousElementSibling === dragEl) && !isWide || halfway && isWide;
							} else {
								after = tgTop > elTop;
							}
						} else {
							after = (nextSibling !== dragEl) && !isLong || halfway && isLong;
						}

						if (!dragEl.contains(el)) {
							if (after && !nextSibling) {
								el.appendChild(dragEl);
							} else {
								target.parentNode.insertBefore(dragEl, after ? nextSibling : target);
							}
						}

						parentEl = dragEl.parentNode; // actualization

						this._animate(dragRect, dragEl);
						this._animate(targetRect, target);
					}
				}
			}
		},

		_animate: function (prevRect, target) {
			var ms = this.options.animation;

			if (ms) {
				var currentRect = target.getBoundingClientRect();

				_css(target, 'transition', 'none');
				_css(target, 'transform', 'translate3d('
					+ (prevRect.left - currentRect.left) + 'px,'
					+ (prevRect.top - currentRect.top) + 'px,0)'
				);

				target.offsetWidth; // repaint

				_css(target, 'transition', 'all ' + ms + 'ms');
				_css(target, 'transform', 'translate3d(0,0,0)');

				clearTimeout(target.animated);
				target.animated = setTimeout(function () {
					_css(target, 'transition', '');
					_css(target, 'transform', '');
					target.animated = false;
				}, ms);
			}
		},

		_offUpEvents: function () {
			var ownerDocument = this.el.ownerDocument;

			_off(document, 'touchmove', this._onTouchMove);
			_off(ownerDocument, 'mouseup', this._onDrop);
			_off(ownerDocument, 'touchend', this._onDrop);
			_off(ownerDocument, 'touchcancel', this._onDrop);
		},

		_onDrop: function (/**Event*/evt) {
			var el = this.el,
				options = this.options;

			clearInterval(this._loopId);
			clearInterval(autoScroll.pid);
			clearTimeout(this._dragStartTimer);

			// Unbind events
			_off(document, 'mousemove', this._onTouchMove);

			if (this.nativeDraggable) {
				_off(document, 'drop', this);
				_off(el, 'dragstart', this._onDragStart);
			}

			this._offUpEvents();

			if (evt) {
				if (moved) {
					evt.preventDefault();
					!options.dropBubble && evt.stopPropagation();
				}

				ghostEl && ghostEl.parentNode.removeChild(ghostEl);

				if (dragEl) {
					if (this.nativeDraggable) {
						var self = this;
						_off(dragEl, 'dragend', $A.getCallback(function(e){
							handleEventManually(e,self);
						}));
					}

					_disableDraggable(dragEl);

					// Remove class's
					_toggleClass(dragEl, this.options.ghostClass, false);
					_toggleClass(dragEl, this.options.chosenClass, false);

					if (rootEl !== parentEl) {
						newIndex = _index(dragEl, options.draggable);

						if (newIndex >= 0) {
							// drag from one list and drop into another
							_dispatchEvent(null, parentEl, 'sort', dragEl, rootEl, oldIndex, newIndex);
							_dispatchEvent(this, rootEl, 'sort', dragEl, rootEl, oldIndex, newIndex);

							// Add event
							_dispatchEvent(null, parentEl, 'add', dragEl, rootEl, oldIndex, newIndex);

							// Remove event
							_dispatchEvent(this, rootEl, 'remove', dragEl, rootEl, oldIndex, newIndex);
						}
					}
					else {
						// Remove clone
						cloneEl && cloneEl.parentNode.removeChild(cloneEl);

						if (dragEl.nextSibling !== nextEl) {
							// Get the index of the dragged element within its parent
							newIndex = _index(dragEl, options.draggable);

							if (newIndex >= 0) {
								// drag & drop within the same list
								_dispatchEvent(this, rootEl, 'update', dragEl, rootEl, oldIndex, newIndex);
								_dispatchEvent(this, rootEl, 'sort', dragEl, rootEl, oldIndex, newIndex);
							}
						}
					}

					if (Sortable.active) {
						/* jshint eqnull:true */
						if (newIndex == null || newIndex === -1) {
							newIndex = oldIndex;
						}

						_dispatchEvent(this, rootEl, 'end', dragEl, rootEl, oldIndex, newIndex);

						// Save sorting
						this.save();
					}
				}

			}

			this._nulling();
		},

		_nulling: function () {
			if (Sortable.active === this) {
				rootEl =
				dragEl =
				parentEl =
				ghostEl =
				nextEl =
				cloneEl =

				scrollEl =
				scrollParentEl =

				tapEvt =
				touchEvt =

				moved =
				newIndex =

				lastEl =
				lastCSS =

				activeGroup =
				Sortable.active = null;
			}
		},

		handleEvent: function (/**Event*/evt) {
			var type = evt.type;
			if (type === 'dragover' || type === 'dragenter') {
				if (dragEl) {
					this._onDragOver(evt);
					_globalDragOver(evt);
				}
			}
			else if (type === 'drop' || type === 'dragend') {
				this._onDrop(evt);
			}
		},


		/**
		 * Serializes the item into an array of string.
		 * @returns {String[]}
		 */
		toArray: function () {
			var order = [],
				el,
				children = this.el.children,
				i = 0,
				n = children.length,
				options = this.options;

			for (; i < n; i++) {
				el = children[i];
				if (_closest(el, options.draggable, this.el)) {
					order.push(el.getAttribute(options.dataIdAttr) || _generateId(el));
				}
			}

			return order;
		},


		/**
		 * Sorts the elements according to the array.
		 * @param  {String[]}  order  order of the items
		 */
		sort: function (order) {
			var items = {}, rootEl = this.el;

			this.toArray().forEach(function (id, i) {
				var el = rootEl.children[i];

				if (_closest(el, this.options.draggable, rootEl)) {
					items[id] = el;
				}
			}, this);

			order.forEach(function (id) {
				if (items[id]) {
					rootEl.removeChild(items[id]);
					rootEl.appendChild(items[id]);
				}
			});
		},


		/**
		 * Save the current sorting
		 */
		save: function () {
			var store = this.options.store;
			store && store.set(this);
		},


		/**
		 * For each element in the set, get the first element that matches the selector by testing the element itself and traversing up through its ancestors in the DOM tree.
		 * @param   {HTMLElement}  el
		 * @param   {String}       [selector]  default: `options.draggable`
		 * @returns {HTMLElement|null}
		 */
		closest: function (el, selector) {
			return _closest(el, selector || this.options.draggable, this.el);
		},


		/**
		 * Set/get option
		 * @param   {string} name
		 * @param   {*}      [value]
		 * @returns {*}
		 */
		option: function (name, value) {
			var options = this.options;

			if (value === void 0) {
				return options[name];
			} else {
				options[name] = value;

				if (name === 'group') {
					_prepareGroup(options);
				}
			}
		},


		/**
		 * Destroy
		 */
		destroy: function () {
			var el = this.el;

			el[expando] = null;

			_off(el, 'mousedown', this._onTapStart);
			_off(el, 'touchstart', this._onTapStart);

			if (this.nativeDraggable) {
				_off(el, 'dragover', this);
				_off(el, 'dragenter', this);
			}

			// Remove draggable attributes
			Array.prototype.forEach.call(el.querySelectorAll('[draggable]'), function (el) {
				el.removeAttribute('draggable');
			});

			touchDragOverListeners.splice(touchDragOverListeners.indexOf(this._onDragOver), 1);

			this._onDrop();

			this.el = el = null;
		}
	};

		function handleEventManually (/**Event*/evt,sortableObj) {
			var type = evt.type;
			console.log(type);
			console.log(sortableObj);
			if (type === 'dragover' || type === 'dragenter') {
				//if (dragEl) {
					sortableObj._onDragOver(evt);
					_globalDragOver(evt);
				//}
			}
			else if (type === 'drop' || type === 'dragend') {
				sortableObj._onDrop(evt);
			}
		}
		
	function _cloneHide(state) {
		if (cloneEl && (cloneEl.state !== state)) {
			_css(cloneEl, 'display', state ? 'none' : '');
			!state && cloneEl.state && rootEl.insertBefore(cloneEl, dragEl);
			cloneEl.state = state;
		}
	}


	function _closest(/**HTMLElement*/el, /**String*/selector, /**HTMLElement*/ctx) {
		if (el) {
			ctx = ctx || document;

			do {
				if (
					(selector === '>*' && el.parentNode === ctx)
					|| _matches(el, selector)
				) {
					return el;
				}
			}
			while (el = ('host' in el) ? el.host : el.parentNode)
		}

		return null;
	}




	function _globalDragOver(/**Event*/evt) {
		if (evt.dataTransfer) {
			evt.dataTransfer.dropEffect = 'move';
		}
		evt.preventDefault();
	}


	function _on(el, event, fn) {
		el.addEventListener(event, fn, false);
	}


	function _off(el, event, fn) {
		el.removeEventListener(event, fn, false);
	}


	function _toggleClass(el, name, state) {
		if (el) {
			if (el.classList) {
				el.classList[state ? 'add' : 'remove'](name);
			}
			else {
				var className = (' ' + el.className + ' ').replace(RSPACE, ' ').replace(' ' + name + ' ', ' ');
				el.className = (className + (state ? ' ' + name : '')).replace(RSPACE, ' ');
			}
		}
	}


	function _css(el, prop, val) {
		var style = el && el.style;

		if (style) {
			if (val === void 0) {
				if (document.defaultView && document.defaultView.getComputedStyle) {
					val = document.defaultView.getComputedStyle(el, '');
				}
				else if (el.currentStyle) {
					val = el.currentStyle;
				}

				return prop === void 0 ? val : val[prop];
			}
			else {
				if (!(prop in style)) {
					prop = '-webkit-' + prop;
				}

				style[prop] = val + (typeof val === 'string' ? '' : 'px');
			}
		}
	}


	function _find(ctx, tagName, iterator) {
		if (ctx) {
			var list = ctx.getElementsByTagName(tagName), i = 0, n = list.length;

			if (iterator) {
				for (; i < n; i++) {
					iterator(list[i], i);
				}
			}

			return list;
		}

		return [];
	}



	function _dispatchEvent(sortable, rootEl, name, targetEl, fromEl, startIndex, newIndex) {
		var evt = document.createEvent('Event'),
			options = (sortable || rootEl[expando]).options,
			onName = 'on' + name.charAt(0).toUpperCase() + name.substr(1);

		evt.initEvent(name, true, true);

		evt.to = rootEl;
		evt.from = fromEl || rootEl;
		evt.item = targetEl || rootEl;
		evt.clone = cloneEl;

		evt.oldIndex = startIndex;
		evt.newIndex = newIndex;

		rootEl.dispatchEvent(evt);

		if (options[onName]) {
			options[onName].call(sortable, evt);
		}
	}


	function _onMove(fromEl, toEl, dragEl, dragRect, targetEl, targetRect) {
		var evt,
			sortable = fromEl[expando],
			onMoveFn = sortable.options.onMove,
			retVal;

		evt = document.createEvent('Event');
		evt.initEvent('move', true, true);

		evt.to = toEl;
		evt.from = fromEl;
		evt.dragged = dragEl;
		evt.draggedRect = dragRect;
		evt.related = targetEl || toEl;
		evt.relatedRect = targetRect || toEl.getBoundingClientRect();

		fromEl.dispatchEvent(evt);

		if (onMoveFn) {
			retVal = onMoveFn.call(sortable, evt);
		}

		return retVal;
	}


	function _disableDraggable(el) {
		el.draggable = false;
	}


	function _unsilent() {
		_silent = false;
	}


	/** @returns {HTMLElement|false} */
	function _ghostIsLast(el, evt) {
		var lastEl = el.lastElementChild,
				rect = lastEl.getBoundingClientRect();

		return ((evt.clientY - (rect.top + rect.height) > 5) || (evt.clientX - (rect.right + rect.width) > 5)) && lastEl; // min delta
	}


	/**
	 * Generate id
	 * @param   {HTMLElement} el
	 * @returns {String}
	 * @private
	 */
	function _generateId(el) {
		var str = el.tagName + el.className + el.src + el.href + el.textContent,
			i = str.length,
			sum = 0;

		while (i--) {
			sum += str.charCodeAt(i);
		}

		return sum.toString(36);
	}

	/**
	 * Returns the index of an element within its parent for a selected set of
	 * elements
	 * @param  {HTMLElement} el
	 * @param  {selector} selector
	 * @return {number}
	 */
	function _index(el, selector) {
		var index = 0;

		if (!el || !el.parentNode) {
			return -1;
		}

		while (el && (el = el.previousElementSibling)) {
			if (el.nodeName.toUpperCase() !== 'TEMPLATE'
					&& _matches(el, selector)) {
				index++;
			}
		}

		return index;
	}

	function _matches(/**HTMLElement*/el, /**String*/selector) {
		if (el) {
			selector = selector.split('.');

			var tag = selector.shift().toUpperCase(),
				re = new RegExp('\\s(' + selector.join('|') + ')(?=\\s)', 'g');

			return (
				(tag === '' || el.nodeName.toUpperCase() == tag) &&
				(!selector.length || ((' ' + el.className + ' ').match(re) || []).length == selector.length)
			);
		}

		return false;
	}

	function _throttle(callback, ms) {
		var args, _this;

		return function () {
			if (args === void 0) {
				args = arguments;
				_this = this;

				setTimeout(function () {
					if (args.length === 1) {
						callback.call(_this, args[0]);
					} else {
						callback.apply(_this, args);
					}

					args = void 0;
				}, ms);
			}
		};
	}

	function _extend(dst, src) {
		if (dst && src) {
			for (var key in src) {
				if (src.hasOwnProperty(key)) {
					dst[key] = src[key];
				}
			}
		}

		return dst;
	}


	// Export utils
	Sortable.utils = {
		on: _on,
		off: _off,
		css: _css,
		find: _find,
		is: function (el, selector) {
			return !!_closest(el, selector, el);
		},
		extend: _extend,
		throttle: _throttle,
		closest: _closest,
		toggleClass: _toggleClass,
		index: _index
	};


	/**
	 * Create sortable instance
	 * @param {HTMLElement}  el
	 * @param {Object}      [options]
	 */
	Sortable.create = function (el, options) {
		return new Sortable(el, options);
	};


	// Export
	Sortable.version = '1.4.2';
	return Sortable;
});


/*!
 * clipboard.js v1.5.12
 * https://zenorocha.github.io/clipboard.js
 *
 * Licensed MIT © Zeno Rocha
 */
!function(t){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=t();else if("function"==typeof define&&define.amd)define([],t);else{var e;e="undefined"!=typeof window?window:"undefined"!=typeof global?global:"undefined"!=typeof self?self:this,e.Clipboard=t()}}(function(){var t,e,n;return function t(e,n,o){function i(a,c){if(!n[a]){if(!e[a]){var s="function"==typeof require&&require;if(!c&&s)return s(a,!0);if(r)return r(a,!0);var l=new Error("Cannot find module '"+a+"'");throw l.code="MODULE_NOT_FOUND",l}var u=n[a]={exports:{}};e[a][0].call(u.exports,function(t){var n=e[a][1][t];return i(n?n:t)},u,u.exports,t,e,n,o)}return n[a].exports}for(var r="function"==typeof require&&require,a=0;a<o.length;a++)i(o[a]);return i}({1:[function(t,e,n){var o=t("matches-selector");e.exports=function(t,e,n){for(var i=n?t:t.parentNode;i&&i!==document;){if(o(i,e))return i;i=i.parentNode}}},{"matches-selector":5}],2:[function(t,e,n){function o(t,e,n,o,r){var a=i.apply(this,arguments);return t.addEventListener(n,a,r),{destroy:function(){t.removeEventListener(n,a,r)}}}function i(t,e,n,o){return function(n){n.delegateTarget=r(n.target,e,!0),n.delegateTarget&&o.call(t,n)}}var r=t("closest");e.exports=o},{closest:1}],3:[function(t,e,n){n.node=function(t){return void 0!==t&&t instanceof HTMLElement&&1===t.nodeType},n.nodeList=function(t){var e=Object.prototype.toString.call(t);return void 0!==t&&("[object NodeList]"===e||"[object HTMLCollection]"===e)&&"length"in t&&(0===t.length||n.node(t[0]))},n.string=function(t){return"string"==typeof t||t instanceof String},n.fn=function(t){var e=Object.prototype.toString.call(t);return"[object Function]"===e}},{}],4:[function(t,e,n){function o(t,e,n){if(!t&&!e&&!n)throw new Error("Missing required arguments");if(!c.string(e))throw new TypeError("Second argument must be a String");if(!c.fn(n))throw new TypeError("Third argument must be a Function");if(c.node(t))return i(t,e,n);if(c.nodeList(t))return r(t,e,n);if(c.string(t))return a(t,e,n);throw new TypeError("First argument must be a String, HTMLElement, HTMLCollection, or NodeList")}function i(t,e,n){return t.addEventListener(e,n),{destroy:function(){t.removeEventListener(e,n)}}}function r(t,e,n){return Array.prototype.forEach.call(t,function(t){t.addEventListener(e,n)}),{destroy:function(){Array.prototype.forEach.call(t,function(t){t.removeEventListener(e,n)})}}}function a(t,e,n){return s(document.body,t,e,n)}var c=t("./is"),s=t("delegate");e.exports=o},{"./is":3,delegate:2}],5:[function(t,e,n){function o(t,e){if(r)return r.call(t,e);for(var n=t.parentNode.querySelectorAll(e),o=0;o<n.length;++o)if(n[o]==t)return!0;return!1}var i=Element.prototype,r=i.matchesSelector||i.webkitMatchesSelector||i.mozMatchesSelector||i.msMatchesSelector||i.oMatchesSelector;e.exports=o},{}],6:[function(t,e,n){function o(t){var e;if("INPUT"===t.nodeName||"TEXTAREA"===t.nodeName)t.focus(),t.setSelectionRange(0,t.value.length),e=t.value;else{t.hasAttribute("contenteditable")&&t.focus();var n=window.getSelection(),o=document.createRange();o.selectNodeContents(t),n.removeAllRanges(),n.addRange(o),e=n.toString()}return e}e.exports=o},{}],7:[function(t,e,n){function o(){}o.prototype={on:function(t,e,n){var o=this.e||(this.e={});return(o[t]||(o[t]=[])).push({fn:e,ctx:n}),this},once:function(t,e,n){function o(){i.off(t,o),e.apply(n,arguments)}var i=this;return o._=e,this.on(t,o,n)},emit:function(t){var e=[].slice.call(arguments,1),n=((this.e||(this.e={}))[t]||[]).slice(),o=0,i=n.length;for(o;i>o;o++)n[o].fn.apply(n[o].ctx,e);return this},off:function(t,e){var n=this.e||(this.e={}),o=n[t],i=[];if(o&&e)for(var r=0,a=o.length;a>r;r++)o[r].fn!==e&&o[r].fn._!==e&&i.push(o[r]);return i.length?n[t]=i:delete n[t],this}},e.exports=o},{}],8:[function(e,n,o){!function(i,r){if("function"==typeof t&&t.amd)t(["module","select"],r);else if("undefined"!=typeof o)r(n,e("select"));else{var a={exports:{}};r(a,i.select),i.clipboardAction=a.exports}}(this,function(t,e){"use strict";function n(t){return t&&t.__esModule?t:{"default":t}}function o(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}var i=n(e),r="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol?"symbol":typeof t},a=function(){function t(t,e){for(var n=0;n<e.length;n++){var o=e[n];o.enumerable=o.enumerable||!1,o.configurable=!0,"value"in o&&(o.writable=!0),Object.defineProperty(t,o.key,o)}}return function(e,n,o){return n&&t(e.prototype,n),o&&t(e,o),e}}(),c=function(){function t(e){o(this,t),this.resolveOptions(e),this.initSelection()}return t.prototype.resolveOptions=function t(){var e=arguments.length<=0||void 0===arguments[0]?{}:arguments[0];this.action=e.action,this.emitter=e.emitter,this.target=e.target,this.text=e.text,this.trigger=e.trigger,this.selectedText=""},t.prototype.initSelection=function t(){this.text?this.selectFake():this.target&&this.selectTarget()},t.prototype.selectFake=function t(){var e=this,n="rtl"==document.documentElement.getAttribute("dir");this.removeFake(),this.fakeHandlerCallback=function(){return e.removeFake()},this.fakeHandler=document.body.addEventListener("click",this.fakeHandlerCallback)||!0,this.fakeElem=document.createElement("textarea"),this.fakeElem.style.fontSize="12pt",this.fakeElem.style.border="0",this.fakeElem.style.padding="0",this.fakeElem.style.margin="0",this.fakeElem.style.position="absolute",this.fakeElem.style[n?"right":"left"]="-9999px",this.fakeElem.style.top=(window.pageYOffset||document.documentElement.scrollTop)+"px",this.fakeElem.setAttribute("readonly",""),this.fakeElem.value=this.text,document.body.appendChild(this.fakeElem),this.selectedText=(0,i.default)(this.fakeElem),this.copyText()},t.prototype.removeFake=function t(){this.fakeHandler&&(document.body.removeEventListener("click",this.fakeHandlerCallback),this.fakeHandler=null,this.fakeHandlerCallback=null),this.fakeElem&&(document.body.removeChild(this.fakeElem),this.fakeElem=null)},t.prototype.selectTarget=function t(){this.selectedText=(0,i.default)(this.target),this.copyText()},t.prototype.copyText=function t(){var e=void 0;try{e=document.execCommand(this.action)}catch(n){e=!1}this.handleResult(e)},t.prototype.handleResult=function t(e){e?this.emitter.emit("success",{action:this.action,text:this.selectedText,trigger:this.trigger,clearSelection:this.clearSelection.bind(this)}):this.emitter.emit("error",{action:this.action,trigger:this.trigger,clearSelection:this.clearSelection.bind(this)})},t.prototype.clearSelection=function t(){this.target&&this.target.blur(),window.getSelection().removeAllRanges()},t.prototype.destroy=function t(){this.removeFake()},a(t,[{key:"action",set:function t(){var e=arguments.length<=0||void 0===arguments[0]?"copy":arguments[0];if(this._action=e,"copy"!==this._action&&"cut"!==this._action)throw new Error('Invalid "action" value, use either "copy" or "cut"')},get:function t(){return this._action}},{key:"target",set:function t(e){if(void 0!==e){if(!e||"object"!==("undefined"==typeof e?"undefined":r(e))||1!==e.nodeType)throw new Error('Invalid "target" value, use a valid Element');if("copy"===this.action&&e.hasAttribute("disabled"))throw new Error('Invalid "target" attribute. Please use "readonly" instead of "disabled" attribute');if("cut"===this.action&&(e.hasAttribute("readonly")||e.hasAttribute("disabled")))throw new Error('Invalid "target" attribute. You can\'t cut text from elements with "readonly" or "disabled" attributes');this._target=e}},get:function t(){return this._target}}]),t}();t.exports=c})},{select:6}],9:[function(e,n,o){!function(i,r){if("function"==typeof t&&t.amd)t(["module","./clipboard-action","tiny-emitter","good-listener"],r);else if("undefined"!=typeof o)r(n,e("./clipboard-action"),e("tiny-emitter"),e("good-listener"));else{var a={exports:{}};r(a,i.clipboardAction,i.tinyEmitter,i.goodListener),i.clipboard=a.exports}}(this,function(t,e,n,o){"use strict";function i(t){return t&&t.__esModule?t:{"default":t}}function r(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}function a(t,e){if(!t)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!e||"object"!=typeof e&&"function"!=typeof e?t:e}function c(t,e){if("function"!=typeof e&&null!==e)throw new TypeError("Super expression must either be null or a function, not "+typeof e);t.prototype=Object.create(e&&e.prototype,{constructor:{value:t,enumerable:!1,writable:!0,configurable:!0}}),e&&(Object.setPrototypeOf?Object.setPrototypeOf(t,e):t.__proto__=e)}function s(t,e){var n="data-clipboard-"+t;if(e.hasAttribute(n))return e.getAttribute(n)}var l=i(e),u=i(n),f=i(o),d=function(t){function e(n,o){r(this,e);var i=a(this,t.call(this));return i.resolveOptions(o),i.listenClick(n),i}return c(e,t),e.prototype.resolveOptions=function t(){var e=arguments.length<=0||void 0===arguments[0]?{}:arguments[0];this.action="function"==typeof e.action?e.action:this.defaultAction,this.target="function"==typeof e.target?e.target:this.defaultTarget,this.text="function"==typeof e.text?e.text:this.defaultText},e.prototype.listenClick=function t(e){var n=this;this.listener=(0,f.default)(e,"click",function(t){return n.onClick(t)})},e.prototype.onClick=function t(e){var n=e.delegateTarget||e.currentTarget;this.clipboardAction&&(this.clipboardAction=null),this.clipboardAction=new l.default({action:this.action(n),target:this.target(n),text:this.text(n),trigger:n,emitter:this})},e.prototype.defaultAction=function t(e){return s("action",e)},e.prototype.defaultTarget=function t(e){var n=s("target",e);return n?document.querySelector(n):void 0},e.prototype.defaultText=function t(e){return s("text",e)},e.prototype.destroy=function t(){this.listener.destroy(),this.clipboardAction&&(this.clipboardAction.destroy(),this.clipboardAction=null)},e}(u.default);t.exports=d})},{"./clipboard-action":8,"good-listener":4,"tiny-emitter":7}]},{},[9])(9)});

/**
 * @license
 * Lodash lodash.com/license | Underscore.js 1.8.3 underscorejs.org/LICENSE
 */
;(function(){function n(n,t){return n.set(t[0],t[1]),n}function t(n,t){return n.add(t),n}function r(n,t,r){switch(r.length){case 0:return n.call(t);case 1:return n.call(t,r[0]);case 2:return n.call(t,r[0],r[1]);case 3:return n.call(t,r[0],r[1],r[2])}return n.apply(t,r)}function e(n,t,r,e){for(var u=-1,i=null==n?0:n.length;++u<i;){var o=n[u];t(e,o,r(o),n)}return e}function u(n,t){for(var r=-1,e=null==n?0:n.length;++r<e&&false!==t(n[r],r,n););return n}function i(n,t){for(var r=null==n?0:n.length;r--&&false!==t(n[r],r,n););
return n}function o(n,t){for(var r=-1,e=null==n?0:n.length;++r<e;)if(!t(n[r],r,n))return false;return true}function f(n,t){for(var r=-1,e=null==n?0:n.length,u=0,i=[];++r<e;){var o=n[r];t(o,r,n)&&(i[u++]=o)}return i}function c(n,t){return!(null==n||!n.length)&&-1<d(n,t,0)}function a(n,t,r){for(var e=-1,u=null==n?0:n.length;++e<u;)if(r(t,n[e]))return true;return false}function l(n,t){for(var r=-1,e=null==n?0:n.length,u=Array(e);++r<e;)u[r]=t(n[r],r,n);return u}function s(n,t){for(var r=-1,e=t.length,u=n.length;++r<e;)n[u+r]=t[r];
return n}function h(n,t,r,e){var u=-1,i=null==n?0:n.length;for(e&&i&&(r=n[++u]);++u<i;)r=t(r,n[u],u,n);return r}function p(n,t,r,e){var u=null==n?0:n.length;for(e&&u&&(r=n[--u]);u--;)r=t(r,n[u],u,n);return r}function _(n,t){for(var r=-1,e=null==n?0:n.length;++r<e;)if(t(n[r],r,n))return true;return false}function v(n,t,r){var e;return r(n,function(n,r,u){if(t(n,r,u))return e=r,false}),e}function g(n,t,r,e){var u=n.length;for(r+=e?1:-1;e?r--:++r<u;)if(t(n[r],r,n))return r;return-1}function d(n,t,r){if(t===t)n:{
--r;for(var e=n.length;++r<e;)if(n[r]===t){n=r;break n}n=-1}else n=g(n,b,r);return n}function y(n,t,r,e){--r;for(var u=n.length;++r<u;)if(e(n[r],t))return r;return-1}function b(n){return n!==n}function x(n,t){var r=null==n?0:n.length;return r?k(n,t)/r:P}function j(n){return function(t){return null==t?F:t[n]}}function w(n){return function(t){return null==n?F:n[t]}}function m(n,t,r,e,u){return u(n,function(n,u,i){r=e?(e=false,n):t(r,n,u,i)}),r}function A(n,t){var r=n.length;for(n.sort(t);r--;)n[r]=n[r].c;
return n}function k(n,t){for(var r,e=-1,u=n.length;++e<u;){var i=t(n[e]);i!==F&&(r=r===F?i:r+i)}return r}function E(n,t){for(var r=-1,e=Array(n);++r<n;)e[r]=t(r);return e}function O(n,t){return l(t,function(t){return[t,n[t]]})}function S(n){return function(t){return n(t)}}function I(n,t){return l(t,function(t){return n[t]})}function R(n,t){return n.has(t)}function z(n,t){for(var r=-1,e=n.length;++r<e&&-1<d(t,n[r],0););return r}function W(n,t){for(var r=n.length;r--&&-1<d(t,n[r],0););return r}function B(n){
return"\\"+Tn[n]}function L(n){var t=-1,r=Array(n.size);return n.forEach(function(n,e){r[++t]=[e,n]}),r}function U(n,t){return function(r){return n(t(r))}}function C(n,t){for(var r=-1,e=n.length,u=0,i=[];++r<e;){var o=n[r];o!==t&&"__lodash_placeholder__"!==o||(n[r]="__lodash_placeholder__",i[u++]=r)}return i}function D(n){var t=-1,r=Array(n.size);return n.forEach(function(n){r[++t]=n}),r}function M(n){var t=-1,r=Array(n.size);return n.forEach(function(n){r[++t]=[n,n]}),r}function T(n){if(Bn.test(n)){
for(var t=zn.lastIndex=0;zn.test(n);)++t;n=t}else n=tt(n);return n}function $(n){return Bn.test(n)?n.match(zn)||[]:n.split("")}var F,N=1/0,P=NaN,Z=[["ary",128],["bind",1],["bindKey",2],["curry",8],["curryRight",16],["flip",512],["partial",32],["partialRight",64],["rearg",256]],q=/\b__p\+='';/g,V=/\b(__p\+=)''\+/g,K=/(__e\(.*?\)|\b__t\))\+'';/g,G=/&(?:amp|lt|gt|quot|#39);/g,H=/[&<>"']/g,J=RegExp(G.source),Y=RegExp(H.source),Q=/<%-([\s\S]+?)%>/g,X=/<%([\s\S]+?)%>/g,nn=/<%=([\s\S]+?)%>/g,tn=/\.|\[(?:[^[\]]*|(["'])(?:(?!\1)[^\\]|\\.)*?\1)\]/,rn=/^\w*$/,en=/^\./,un=/[^.[\]]+|\[(?:(-?\d+(?:\.\d+)?)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]|(?=(?:\.|\[\])(?:\.|\[\]|$))/g,on=/[\\^$.*+?()[\]{}|]/g,fn=RegExp(on.source),cn=/^\s+|\s+$/g,an=/^\s+/,ln=/\s+$/,sn=/\{(?:\n\/\* \[wrapped with .+\] \*\/)?\n?/,hn=/\{\n\/\* \[wrapped with (.+)\] \*/,pn=/,? & /,_n=/[^\x00-\x2f\x3a-\x40\x5b-\x60\x7b-\x7f]+/g,vn=/\\(\\)?/g,gn=/\$\{([^\\}]*(?:\\.[^\\}]*)*)\}/g,dn=/\w*$/,yn=/^[-+]0x[0-9a-f]+$/i,bn=/^0b[01]+$/i,xn=/^\[object .+?Constructor\]$/,jn=/^0o[0-7]+$/i,wn=/^(?:0|[1-9]\d*)$/,mn=/[\xc0-\xd6\xd8-\xf6\xf8-\xff\u0100-\u017f]/g,An=/($^)/,kn=/['\n\r\u2028\u2029\\]/g,En="[\\ufe0e\\ufe0f]?(?:[\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff]|\\ud83c[\\udffb-\\udfff])?(?:\\u200d(?:[^\\ud800-\\udfff]|(?:\\ud83c[\\udde6-\\uddff]){2}|[\\ud800-\\udbff][\\udc00-\\udfff])[\\ufe0e\\ufe0f]?(?:[\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff]|\\ud83c[\\udffb-\\udfff])?)*",On="(?:[\\u2700-\\u27bf]|(?:\\ud83c[\\udde6-\\uddff]){2}|[\\ud800-\\udbff][\\udc00-\\udfff])"+En,Sn="(?:[^\\ud800-\\udfff][\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff]?|[\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff]|(?:\\ud83c[\\udde6-\\uddff]){2}|[\\ud800-\\udbff][\\udc00-\\udfff]|[\\ud800-\\udfff])",In=RegExp("['\u2019]","g"),Rn=RegExp("[\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff]","g"),zn=RegExp("\\ud83c[\\udffb-\\udfff](?=\\ud83c[\\udffb-\\udfff])|"+Sn+En,"g"),Wn=RegExp(["[A-Z\\xc0-\\xd6\\xd8-\\xde]?[a-z\\xdf-\\xf6\\xf8-\\xff]+(?:['\u2019](?:d|ll|m|re|s|t|ve))?(?=[\\xac\\xb1\\xd7\\xf7\\x00-\\x2f\\x3a-\\x40\\x5b-\\x60\\x7b-\\xbf\\u2000-\\u206f \\t\\x0b\\f\\xa0\\ufeff\\n\\r\\u2028\\u2029\\u1680\\u180e\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200a\\u202f\\u205f\\u3000]|[A-Z\\xc0-\\xd6\\xd8-\\xde]|$)|(?:[A-Z\\xc0-\\xd6\\xd8-\\xde]|[^\\ud800-\\udfff\\xac\\xb1\\xd7\\xf7\\x00-\\x2f\\x3a-\\x40\\x5b-\\x60\\x7b-\\xbf\\u2000-\\u206f \\t\\x0b\\f\\xa0\\ufeff\\n\\r\\u2028\\u2029\\u1680\\u180e\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200a\\u202f\\u205f\\u3000\\d+\\u2700-\\u27bfa-z\\xdf-\\xf6\\xf8-\\xffA-Z\\xc0-\\xd6\\xd8-\\xde])+(?:['\u2019](?:D|LL|M|RE|S|T|VE))?(?=[\\xac\\xb1\\xd7\\xf7\\x00-\\x2f\\x3a-\\x40\\x5b-\\x60\\x7b-\\xbf\\u2000-\\u206f \\t\\x0b\\f\\xa0\\ufeff\\n\\r\\u2028\\u2029\\u1680\\u180e\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200a\\u202f\\u205f\\u3000]|[A-Z\\xc0-\\xd6\\xd8-\\xde](?:[a-z\\xdf-\\xf6\\xf8-\\xff]|[^\\ud800-\\udfff\\xac\\xb1\\xd7\\xf7\\x00-\\x2f\\x3a-\\x40\\x5b-\\x60\\x7b-\\xbf\\u2000-\\u206f \\t\\x0b\\f\\xa0\\ufeff\\n\\r\\u2028\\u2029\\u1680\\u180e\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200a\\u202f\\u205f\\u3000\\d+\\u2700-\\u27bfa-z\\xdf-\\xf6\\xf8-\\xffA-Z\\xc0-\\xd6\\xd8-\\xde])|$)|[A-Z\\xc0-\\xd6\\xd8-\\xde]?(?:[a-z\\xdf-\\xf6\\xf8-\\xff]|[^\\ud800-\\udfff\\xac\\xb1\\xd7\\xf7\\x00-\\x2f\\x3a-\\x40\\x5b-\\x60\\x7b-\\xbf\\u2000-\\u206f \\t\\x0b\\f\\xa0\\ufeff\\n\\r\\u2028\\u2029\\u1680\\u180e\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200a\\u202f\\u205f\\u3000\\d+\\u2700-\\u27bfa-z\\xdf-\\xf6\\xf8-\\xffA-Z\\xc0-\\xd6\\xd8-\\xde])+(?:['\u2019](?:d|ll|m|re|s|t|ve))?|[A-Z\\xc0-\\xd6\\xd8-\\xde]+(?:['\u2019](?:D|LL|M|RE|S|T|VE))?|\\d*(?:(?:1ST|2ND|3RD|(?![123])\\dTH)\\b)|\\d*(?:(?:1st|2nd|3rd|(?![123])\\dth)\\b)|\\d+",On].join("|"),"g"),Bn=RegExp("[\\u200d\\ud800-\\udfff\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff\\ufe0e\\ufe0f]"),Ln=/[a-z][A-Z]|[A-Z]{2,}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9 ]/,Un="Array Buffer DataView Date Error Float32Array Float64Array Function Int8Array Int16Array Int32Array Map Math Object Promise RegExp Set String Symbol TypeError Uint8Array Uint8ClampedArray Uint16Array Uint32Array WeakMap _ clearTimeout isFinite parseInt setTimeout".split(" "),Cn={};
Cn["[object Float32Array]"]=Cn["[object Float64Array]"]=Cn["[object Int8Array]"]=Cn["[object Int16Array]"]=Cn["[object Int32Array]"]=Cn["[object Uint8Array]"]=Cn["[object Uint8ClampedArray]"]=Cn["[object Uint16Array]"]=Cn["[object Uint32Array]"]=true,Cn["[object Arguments]"]=Cn["[object Array]"]=Cn["[object ArrayBuffer]"]=Cn["[object Boolean]"]=Cn["[object DataView]"]=Cn["[object Date]"]=Cn["[object Error]"]=Cn["[object Function]"]=Cn["[object Map]"]=Cn["[object Number]"]=Cn["[object Object]"]=Cn["[object RegExp]"]=Cn["[object Set]"]=Cn["[object String]"]=Cn["[object WeakMap]"]=false;
var Dn={};Dn["[object Arguments]"]=Dn["[object Array]"]=Dn["[object ArrayBuffer]"]=Dn["[object DataView]"]=Dn["[object Boolean]"]=Dn["[object Date]"]=Dn["[object Float32Array]"]=Dn["[object Float64Array]"]=Dn["[object Int8Array]"]=Dn["[object Int16Array]"]=Dn["[object Int32Array]"]=Dn["[object Map]"]=Dn["[object Number]"]=Dn["[object Object]"]=Dn["[object RegExp]"]=Dn["[object Set]"]=Dn["[object String]"]=Dn["[object Symbol]"]=Dn["[object Uint8Array]"]=Dn["[object Uint8ClampedArray]"]=Dn["[object Uint16Array]"]=Dn["[object Uint32Array]"]=true,
Dn["[object Error]"]=Dn["[object Function]"]=Dn["[object WeakMap]"]=false;var Mn,Tn={"\\":"\\","'":"'","\n":"n","\r":"r","\u2028":"u2028","\u2029":"u2029"},$n=parseFloat,Fn=parseInt,Nn=typeof global=="object"&&global&&global.Object===Object&&global,Pn=typeof self=="object"&&self&&self.Object===Object&&self,Zn=Nn||Pn||Function("return this")(),qn=typeof exports=="object"&&exports&&!exports.nodeType&&exports,Vn=qn&&typeof module=="object"&&module&&!module.nodeType&&module,Kn=Vn&&Vn.exports===qn,Gn=Kn&&Nn.process;
n:{try{Mn=Gn&&Gn.binding&&Gn.binding("util");break n}catch(n){}Mn=void 0}var Hn=Mn&&Mn.isArrayBuffer,Jn=Mn&&Mn.isDate,Yn=Mn&&Mn.isMap,Qn=Mn&&Mn.isRegExp,Xn=Mn&&Mn.isSet,nt=Mn&&Mn.isTypedArray,tt=j("length"),rt=w({"\xc0":"A","\xc1":"A","\xc2":"A","\xc3":"A","\xc4":"A","\xc5":"A","\xe0":"a","\xe1":"a","\xe2":"a","\xe3":"a","\xe4":"a","\xe5":"a","\xc7":"C","\xe7":"c","\xd0":"D","\xf0":"d","\xc8":"E","\xc9":"E","\xca":"E","\xcb":"E","\xe8":"e","\xe9":"e","\xea":"e","\xeb":"e","\xcc":"I","\xcd":"I","\xce":"I",
"\xcf":"I","\xec":"i","\xed":"i","\xee":"i","\xef":"i","\xd1":"N","\xf1":"n","\xd2":"O","\xd3":"O","\xd4":"O","\xd5":"O","\xd6":"O","\xd8":"O","\xf2":"o","\xf3":"o","\xf4":"o","\xf5":"o","\xf6":"o","\xf8":"o","\xd9":"U","\xda":"U","\xdb":"U","\xdc":"U","\xf9":"u","\xfa":"u","\xfb":"u","\xfc":"u","\xdd":"Y","\xfd":"y","\xff":"y","\xc6":"Ae","\xe6":"ae","\xde":"Th","\xfe":"th","\xdf":"ss","\u0100":"A","\u0102":"A","\u0104":"A","\u0101":"a","\u0103":"a","\u0105":"a","\u0106":"C","\u0108":"C","\u010a":"C",
"\u010c":"C","\u0107":"c","\u0109":"c","\u010b":"c","\u010d":"c","\u010e":"D","\u0110":"D","\u010f":"d","\u0111":"d","\u0112":"E","\u0114":"E","\u0116":"E","\u0118":"E","\u011a":"E","\u0113":"e","\u0115":"e","\u0117":"e","\u0119":"e","\u011b":"e","\u011c":"G","\u011e":"G","\u0120":"G","\u0122":"G","\u011d":"g","\u011f":"g","\u0121":"g","\u0123":"g","\u0124":"H","\u0126":"H","\u0125":"h","\u0127":"h","\u0128":"I","\u012a":"I","\u012c":"I","\u012e":"I","\u0130":"I","\u0129":"i","\u012b":"i","\u012d":"i",
"\u012f":"i","\u0131":"i","\u0134":"J","\u0135":"j","\u0136":"K","\u0137":"k","\u0138":"k","\u0139":"L","\u013b":"L","\u013d":"L","\u013f":"L","\u0141":"L","\u013a":"l","\u013c":"l","\u013e":"l","\u0140":"l","\u0142":"l","\u0143":"N","\u0145":"N","\u0147":"N","\u014a":"N","\u0144":"n","\u0146":"n","\u0148":"n","\u014b":"n","\u014c":"O","\u014e":"O","\u0150":"O","\u014d":"o","\u014f":"o","\u0151":"o","\u0154":"R","\u0156":"R","\u0158":"R","\u0155":"r","\u0157":"r","\u0159":"r","\u015a":"S","\u015c":"S",
"\u015e":"S","\u0160":"S","\u015b":"s","\u015d":"s","\u015f":"s","\u0161":"s","\u0162":"T","\u0164":"T","\u0166":"T","\u0163":"t","\u0165":"t","\u0167":"t","\u0168":"U","\u016a":"U","\u016c":"U","\u016e":"U","\u0170":"U","\u0172":"U","\u0169":"u","\u016b":"u","\u016d":"u","\u016f":"u","\u0171":"u","\u0173":"u","\u0174":"W","\u0175":"w","\u0176":"Y","\u0177":"y","\u0178":"Y","\u0179":"Z","\u017b":"Z","\u017d":"Z","\u017a":"z","\u017c":"z","\u017e":"z","\u0132":"IJ","\u0133":"ij","\u0152":"Oe","\u0153":"oe",
"\u0149":"'n","\u017f":"s"}),et=w({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}),ut=w({"&amp;":"&","&lt;":"<","&gt;":">","&quot;":'"',"&#39;":"'"}),it=function w(En){function On(n){if(xu(n)&&!af(n)&&!(n instanceof Mn)){if(n instanceof zn)return n;if(ci.call(n,"__wrapped__"))return Pe(n)}return new zn(n)}function Sn(){}function zn(n,t){this.__wrapped__=n,this.__actions__=[],this.__chain__=!!t,this.__index__=0,this.__values__=F}function Mn(n){this.__wrapped__=n,this.__actions__=[],this.__dir__=1,
this.__filtered__=false,this.__iteratees__=[],this.__takeCount__=4294967295,this.__views__=[]}function Tn(n){var t=-1,r=null==n?0:n.length;for(this.clear();++t<r;){var e=n[t];this.set(e[0],e[1])}}function Nn(n){var t=-1,r=null==n?0:n.length;for(this.clear();++t<r;){var e=n[t];this.set(e[0],e[1])}}function Pn(n){var t=-1,r=null==n?0:n.length;for(this.clear();++t<r;){var e=n[t];this.set(e[0],e[1])}}function qn(n){var t=-1,r=null==n?0:n.length;for(this.__data__=new Pn;++t<r;)this.add(n[t])}function Vn(n){
this.size=(this.__data__=new Nn(n)).size}function Gn(n,t){var r,e=af(n),u=!e&&cf(n),i=!e&&!u&&sf(n),o=!e&&!u&&!i&&gf(n),u=(e=e||u||i||o)?E(n.length,ri):[],f=u.length;for(r in n)!t&&!ci.call(n,r)||e&&("length"==r||i&&("offset"==r||"parent"==r)||o&&("buffer"==r||"byteLength"==r||"byteOffset"==r)||Re(r,f))||u.push(r);return u}function tt(n){var t=n.length;return t?n[cr(0,t-1)]:F}function ot(n,t){return Te(Mr(n),gt(t,0,n.length))}function ft(n){return Te(Mr(n))}function ct(n,t,r){(r===F||hu(n[t],r))&&(r!==F||t in n)||_t(n,t,r);
}function at(n,t,r){var e=n[t];ci.call(n,t)&&hu(e,r)&&(r!==F||t in n)||_t(n,t,r)}function lt(n,t){for(var r=n.length;r--;)if(hu(n[r][0],t))return r;return-1}function st(n,t,r,e){return oo(n,function(n,u,i){t(e,n,r(n),i)}),e}function ht(n,t){return n&&Tr(t,Lu(t),n)}function pt(n,t){return n&&Tr(t,Uu(t),n)}function _t(n,t,r){"__proto__"==t&&Ei?Ei(n,t,{configurable:true,enumerable:true,value:r,writable:true}):n[t]=r}function vt(n,t){for(var r=-1,e=t.length,u=Hu(e),i=null==n;++r<e;)u[r]=i?F:Wu(n,t[r]);return u;
}function gt(n,t,r){return n===n&&(r!==F&&(n=n<=r?n:r),t!==F&&(n=n>=t?n:t)),n}function dt(n,t,r,e,i,o){var f,c=1&t,a=2&t,l=4&t;if(r&&(f=i?r(n,e,i,o):r(n)),f!==F)return f;if(!bu(n))return n;if(e=af(n)){if(f=Ee(n),!c)return Mr(n,f)}else{var s=yo(n),h="[object Function]"==s||"[object GeneratorFunction]"==s;if(sf(n))return Wr(n,c);if("[object Object]"==s||"[object Arguments]"==s||h&&!i){if(f=a||h?{}:Oe(n),!c)return a?Fr(n,pt(f,n)):$r(n,ht(f,n))}else{if(!Dn[s])return i?n:{};f=Se(n,s,dt,c)}}if(o||(o=new Vn),
i=o.get(n))return i;o.set(n,f);var a=l?a?ye:de:a?Uu:Lu,p=e?F:a(n);return u(p||n,function(e,u){p&&(u=e,e=n[u]),at(f,u,dt(e,t,r,u,n,o))}),f}function yt(n){var t=Lu(n);return function(r){return bt(r,n,t)}}function bt(n,t,r){var e=r.length;if(null==n)return!e;for(n=ni(n);e--;){var u=r[e],i=t[u],o=n[u];if(o===F&&!(u in n)||!i(o))return false}return true}function xt(n,t,r){if(typeof n!="function")throw new ei("Expected a function");return jo(function(){n.apply(F,r)},t)}function jt(n,t,r,e){var u=-1,i=c,o=true,f=n.length,s=[],h=t.length;
if(!f)return s;r&&(t=l(t,S(r))),e?(i=a,o=false):200<=t.length&&(i=R,o=false,t=new qn(t));n:for(;++u<f;){var p=n[u],_=null==r?p:r(p),p=e||0!==p?p:0;if(o&&_===_){for(var v=h;v--;)if(t[v]===_)continue n;s.push(p)}else i(t,_,e)||s.push(p)}return s}function wt(n,t){var r=true;return oo(n,function(n,e,u){return r=!!t(n,e,u)}),r}function mt(n,t,r){for(var e=-1,u=n.length;++e<u;){var i=n[e],o=t(i);if(null!=o&&(f===F?o===o&&!Au(o):r(o,f)))var f=o,c=i}return c}function At(n,t){var r=[];return oo(n,function(n,e,u){
t(n,e,u)&&r.push(n)}),r}function kt(n,t,r,e,u){var i=-1,o=n.length;for(r||(r=Ie),u||(u=[]);++i<o;){var f=n[i];0<t&&r(f)?1<t?kt(f,t-1,r,e,u):s(u,f):e||(u[u.length]=f)}return u}function Et(n,t){return n&&co(n,t,Lu)}function Ot(n,t){return n&&ao(n,t,Lu)}function St(n,t){return f(t,function(t){return gu(n[t])})}function It(n,t){t=Rr(t,n);for(var r=0,e=t.length;null!=n&&r<e;)n=n[$e(t[r++])];return r&&r==e?n:F}function Rt(n,t,r){return t=t(n),af(n)?t:s(t,r(n))}function zt(n){if(null==n)n=n===F?"[object Undefined]":"[object Null]";else if(ki&&ki in ni(n)){
var t=ci.call(n,ki),r=n[ki];try{n[ki]=F;var e=true}catch(n){}var u=si.call(n);e&&(t?n[ki]=r:delete n[ki]),n=u}else n=si.call(n);return n}function Wt(n,t){return n>t}function Bt(n,t){return null!=n&&ci.call(n,t)}function Lt(n,t){return null!=n&&t in ni(n)}function Ut(n,t,r){for(var e=r?a:c,u=n[0].length,i=n.length,o=i,f=Hu(i),s=1/0,h=[];o--;){var p=n[o];o&&t&&(p=l(p,S(t))),s=Mi(p.length,s),f[o]=!r&&(t||120<=u&&120<=p.length)?new qn(o&&p):F}var p=n[0],_=-1,v=f[0];n:for(;++_<u&&h.length<s;){var g=p[_],d=t?t(g):g,g=r||0!==g?g:0;
if(v?!R(v,d):!e(h,d,r)){for(o=i;--o;){var y=f[o];if(y?!R(y,d):!e(n[o],d,r))continue n}v&&v.push(d),h.push(g)}}return h}function Ct(n,t,r){var e={};return Et(n,function(n,u,i){t(e,r(n),u,i)}),e}function Dt(n,t,e){return t=Rr(t,n),n=2>t.length?n:It(n,vr(t,0,-1)),t=null==n?n:n[$e(Ge(t))],null==t?F:r(t,n,e)}function Mt(n){return xu(n)&&"[object Arguments]"==zt(n)}function Tt(n){return xu(n)&&"[object ArrayBuffer]"==zt(n)}function $t(n){return xu(n)&&"[object Date]"==zt(n)}function Ft(n,t,r,e,u){if(n===t)t=true;else if(null==n||null==t||!xu(n)&&!xu(t))t=n!==n&&t!==t;else n:{
var i=af(n),o=af(t),f=i?"[object Array]":yo(n),c=o?"[object Array]":yo(t),f="[object Arguments]"==f?"[object Object]":f,c="[object Arguments]"==c?"[object Object]":c,a="[object Object]"==f,o="[object Object]"==c;if((c=f==c)&&sf(n)){if(!sf(t)){t=false;break n}i=true,a=false}if(c&&!a)u||(u=new Vn),t=i||gf(n)?_e(n,t,r,e,Ft,u):ve(n,t,f,r,e,Ft,u);else{if(!(1&r)&&(i=a&&ci.call(n,"__wrapped__"),f=o&&ci.call(t,"__wrapped__"),i||f)){n=i?n.value():n,t=f?t.value():t,u||(u=new Vn),t=Ft(n,t,r,e,u);break n}if(c)t:if(u||(u=new Vn),
i=1&r,f=de(n),o=f.length,c=de(t).length,o==c||i){for(a=o;a--;){var l=f[a];if(!(i?l in t:ci.call(t,l))){t=false;break t}}if((c=u.get(n))&&u.get(t))t=c==t;else{c=true,u.set(n,t),u.set(t,n);for(var s=i;++a<o;){var l=f[a],h=n[l],p=t[l];if(e)var _=i?e(p,h,l,t,n,u):e(h,p,l,n,t,u);if(_===F?h!==p&&!Ft(h,p,r,e,u):!_){c=false;break}s||(s="constructor"==l)}c&&!s&&(r=n.constructor,e=t.constructor,r!=e&&"constructor"in n&&"constructor"in t&&!(typeof r=="function"&&r instanceof r&&typeof e=="function"&&e instanceof e)&&(c=false)),
u.delete(n),u.delete(t),t=c}}else t=false;else t=false}}return t}function Nt(n){return xu(n)&&"[object Map]"==yo(n)}function Pt(n,t,r,e){var u=r.length,i=u,o=!e;if(null==n)return!i;for(n=ni(n);u--;){var f=r[u];if(o&&f[2]?f[1]!==n[f[0]]:!(f[0]in n))return false}for(;++u<i;){var f=r[u],c=f[0],a=n[c],l=f[1];if(o&&f[2]){if(a===F&&!(c in n))return false}else{if(f=new Vn,e)var s=e(a,l,c,n,t,f);if(s===F?!Ft(l,a,3,e,f):!s)return false}}return true}function Zt(n){return!(!bu(n)||li&&li in n)&&(gu(n)?_i:xn).test(Fe(n))}function qt(n){
return xu(n)&&"[object RegExp]"==zt(n)}function Vt(n){return xu(n)&&"[object Set]"==yo(n)}function Kt(n){return xu(n)&&yu(n.length)&&!!Cn[zt(n)]}function Gt(n){return typeof n=="function"?n:null==n?Nu:typeof n=="object"?af(n)?Xt(n[0],n[1]):Qt(n):Vu(n)}function Ht(n){if(!Le(n))return Ci(n);var t,r=[];for(t in ni(n))ci.call(n,t)&&"constructor"!=t&&r.push(t);return r}function Jt(n,t){return n<t}function Yt(n,t){var r=-1,e=pu(n)?Hu(n.length):[];return oo(n,function(n,u,i){e[++r]=t(n,u,i)}),e}function Qt(n){
var t=me(n);return 1==t.length&&t[0][2]?Ue(t[0][0],t[0][1]):function(r){return r===n||Pt(r,n,t)}}function Xt(n,t){return We(n)&&t===t&&!bu(t)?Ue($e(n),t):function(r){var e=Wu(r,n);return e===F&&e===t?Bu(r,n):Ft(t,e,3)}}function nr(n,t,r,e,u){n!==t&&co(t,function(i,o){if(bu(i)){u||(u=new Vn);var f=u,c=n[o],a=t[o],l=f.get(a);if(l)ct(n,o,l);else{var l=e?e(c,a,o+"",n,t,f):F,s=l===F;if(s){var h=af(a),p=!h&&sf(a),_=!h&&!p&&gf(a),l=a;h||p||_?af(c)?l=c:_u(c)?l=Mr(c):p?(s=false,l=Wr(a,true)):_?(s=false,l=Lr(a,true)):l=[]:wu(a)||cf(a)?(l=c,
cf(c)?l=Ru(c):(!bu(c)||r&&gu(c))&&(l=Oe(a))):s=false}s&&(f.set(a,l),nr(l,a,r,e,f),f.delete(a)),ct(n,o,l)}}else f=e?e(n[o],i,o+"",n,t,u):F,f===F&&(f=i),ct(n,o,f)},Uu)}function tr(n,t){var r=n.length;if(r)return t+=0>t?r:0,Re(t,r)?n[t]:F}function rr(n,t,r){var e=-1;return t=l(t.length?t:[Nu],S(je())),n=Yt(n,function(n){return{a:l(t,function(t){return t(n)}),b:++e,c:n}}),A(n,function(n,t){var e;n:{e=-1;for(var u=n.a,i=t.a,o=u.length,f=r.length;++e<o;){var c=Ur(u[e],i[e]);if(c){e=e>=f?c:c*("desc"==r[e]?-1:1);
break n}}e=n.b-t.b}return e})}function er(n,t){return ur(n,t,function(t,r){return Bu(n,r)})}function ur(n,t,r){for(var e=-1,u=t.length,i={};++e<u;){var o=t[e],f=It(n,o);r(f,o)&&pr(i,Rr(o,n),f)}return i}function ir(n){return function(t){return It(t,n)}}function or(n,t,r,e){var u=e?y:d,i=-1,o=t.length,f=n;for(n===t&&(t=Mr(t)),r&&(f=l(n,S(r)));++i<o;)for(var c=0,a=t[i],a=r?r(a):a;-1<(c=u(f,a,c,e));)f!==n&&wi.call(f,c,1),wi.call(n,c,1);return n}function fr(n,t){for(var r=n?t.length:0,e=r-1;r--;){var u=t[r];
if(r==e||u!==i){var i=u;Re(u)?wi.call(n,u,1):mr(n,u)}}}function cr(n,t){return n+zi(Fi()*(t-n+1))}function ar(n,t){var r="";if(!n||1>t||9007199254740991<t)return r;do t%2&&(r+=n),(t=zi(t/2))&&(n+=n);while(t);return r}function lr(n,t){return wo(Ce(n,t,Nu),n+"")}function sr(n){return tt(Du(n))}function hr(n,t){var r=Du(n);return Te(r,gt(t,0,r.length))}function pr(n,t,r,e){if(!bu(n))return n;t=Rr(t,n);for(var u=-1,i=t.length,o=i-1,f=n;null!=f&&++u<i;){var c=$e(t[u]),a=r;if(u!=o){var l=f[c],a=e?e(l,c,f):F;
a===F&&(a=bu(l)?l:Re(t[u+1])?[]:{})}at(f,c,a),f=f[c]}return n}function _r(n){return Te(Du(n))}function vr(n,t,r){var e=-1,u=n.length;for(0>t&&(t=-t>u?0:u+t),r=r>u?u:r,0>r&&(r+=u),u=t>r?0:r-t>>>0,t>>>=0,r=Hu(u);++e<u;)r[e]=n[e+t];return r}function gr(n,t){var r;return oo(n,function(n,e,u){return r=t(n,e,u),!r}),!!r}function dr(n,t,r){var e=0,u=null==n?e:n.length;if(typeof t=="number"&&t===t&&2147483647>=u){for(;e<u;){var i=e+u>>>1,o=n[i];null!==o&&!Au(o)&&(r?o<=t:o<t)?e=i+1:u=i}return u}return yr(n,t,Nu,r);
}function yr(n,t,r,e){t=r(t);for(var u=0,i=null==n?0:n.length,o=t!==t,f=null===t,c=Au(t),a=t===F;u<i;){var l=zi((u+i)/2),s=r(n[l]),h=s!==F,p=null===s,_=s===s,v=Au(s);(o?e||_:a?_&&(e||h):f?_&&h&&(e||!p):c?_&&h&&!p&&(e||!v):p||v?0:e?s<=t:s<t)?u=l+1:i=l}return Mi(i,4294967294)}function br(n,t){for(var r=-1,e=n.length,u=0,i=[];++r<e;){var o=n[r],f=t?t(o):o;if(!r||!hu(f,c)){var c=f;i[u++]=0===o?0:o}}return i}function xr(n){return typeof n=="number"?n:Au(n)?P:+n}function jr(n){if(typeof n=="string")return n;
if(af(n))return l(n,jr)+"";if(Au(n))return uo?uo.call(n):"";var t=n+"";return"0"==t&&1/n==-N?"-0":t}function wr(n,t,r){var e=-1,u=c,i=n.length,o=true,f=[],l=f;if(r)o=false,u=a;else if(200<=i){if(u=t?null:po(n))return D(u);o=false,u=R,l=new qn}else l=t?[]:f;n:for(;++e<i;){var s=n[e],h=t?t(s):s,s=r||0!==s?s:0;if(o&&h===h){for(var p=l.length;p--;)if(l[p]===h)continue n;t&&l.push(h),f.push(s)}else u(l,h,r)||(l!==f&&l.push(h),f.push(s))}return f}function mr(n,t){return t=Rr(t,n),n=2>t.length?n:It(n,vr(t,0,-1)),
null==n||delete n[$e(Ge(t))]}function Ar(n,t,r,e){for(var u=n.length,i=e?u:-1;(e?i--:++i<u)&&t(n[i],i,n););return r?vr(n,e?0:i,e?i+1:u):vr(n,e?i+1:0,e?u:i)}function kr(n,t){var r=n;return r instanceof Mn&&(r=r.value()),h(t,function(n,t){return t.func.apply(t.thisArg,s([n],t.args))},r)}function Er(n,t,r){var e=n.length;if(2>e)return e?wr(n[0]):[];for(var u=-1,i=Hu(e);++u<e;)for(var o=n[u],f=-1;++f<e;)f!=u&&(i[u]=jt(i[u]||o,n[f],t,r));return wr(kt(i,1),t,r)}function Or(n,t,r){for(var e=-1,u=n.length,i=t.length,o={};++e<u;)r(o,n[e],e<i?t[e]:F);
return o}function Sr(n){return _u(n)?n:[]}function Ir(n){return typeof n=="function"?n:Nu}function Rr(n,t){return af(n)?n:We(n,t)?[n]:mo(zu(n))}function zr(n,t,r){var e=n.length;return r=r===F?e:r,!t&&r>=e?n:vr(n,t,r)}function Wr(n,t){if(t)return n.slice();var r=n.length,r=yi?yi(r):new n.constructor(r);return n.copy(r),r}function Br(n){var t=new n.constructor(n.byteLength);return new di(t).set(new di(n)),t}function Lr(n,t){return new n.constructor(t?Br(n.buffer):n.buffer,n.byteOffset,n.length)}function Ur(n,t){
if(n!==t){var r=n!==F,e=null===n,u=n===n,i=Au(n),o=t!==F,f=null===t,c=t===t,a=Au(t);if(!f&&!a&&!i&&n>t||i&&o&&c&&!f&&!a||e&&o&&c||!r&&c||!u)return 1;if(!e&&!i&&!a&&n<t||a&&r&&u&&!e&&!i||f&&r&&u||!o&&u||!c)return-1}return 0}function Cr(n,t,r,e){var u=-1,i=n.length,o=r.length,f=-1,c=t.length,a=Di(i-o,0),l=Hu(c+a);for(e=!e;++f<c;)l[f]=t[f];for(;++u<o;)(e||u<i)&&(l[r[u]]=n[u]);for(;a--;)l[f++]=n[u++];return l}function Dr(n,t,r,e){var u=-1,i=n.length,o=-1,f=r.length,c=-1,a=t.length,l=Di(i-f,0),s=Hu(l+a);
for(e=!e;++u<l;)s[u]=n[u];for(l=u;++c<a;)s[l+c]=t[c];for(;++o<f;)(e||u<i)&&(s[l+r[o]]=n[u++]);return s}function Mr(n,t){var r=-1,e=n.length;for(t||(t=Hu(e));++r<e;)t[r]=n[r];return t}function Tr(n,t,r,e){var u=!r;r||(r={});for(var i=-1,o=t.length;++i<o;){var f=t[i],c=e?e(r[f],n[f],f,r,n):F;c===F&&(c=n[f]),u?_t(r,f,c):at(r,f,c)}return r}function $r(n,t){return Tr(n,vo(n),t)}function Fr(n,t){return Tr(n,go(n),t)}function Nr(n,t){return function(r,u){var i=af(r)?e:st,o=t?t():{};return i(r,n,je(u,2),o);
}}function Pr(n){return lr(function(t,r){var e=-1,u=r.length,i=1<u?r[u-1]:F,o=2<u?r[2]:F,i=3<n.length&&typeof i=="function"?(u--,i):F;for(o&&ze(r[0],r[1],o)&&(i=3>u?F:i,u=1),t=ni(t);++e<u;)(o=r[e])&&n(t,o,e,i);return t})}function Zr(n,t){return function(r,e){if(null==r)return r;if(!pu(r))return n(r,e);for(var u=r.length,i=t?u:-1,o=ni(r);(t?i--:++i<u)&&false!==e(o[i],i,o););return r}}function qr(n){return function(t,r,e){var u=-1,i=ni(t);e=e(t);for(var o=e.length;o--;){var f=e[n?o:++u];if(false===r(i[f],f,i))break;
}return t}}function Vr(n,t,r){function e(){return(this&&this!==Zn&&this instanceof e?i:n).apply(u?r:this,arguments)}var u=1&t,i=Hr(n);return e}function Kr(n){return function(t){t=zu(t);var r=Bn.test(t)?$(t):F,e=r?r[0]:t.charAt(0);return t=r?zr(r,1).join(""):t.slice(1),e[n]()+t}}function Gr(n){return function(t){return h($u(Tu(t).replace(In,"")),n,"")}}function Hr(n){return function(){var t=arguments;switch(t.length){case 0:return new n;case 1:return new n(t[0]);case 2:return new n(t[0],t[1]);case 3:
return new n(t[0],t[1],t[2]);case 4:return new n(t[0],t[1],t[2],t[3]);case 5:return new n(t[0],t[1],t[2],t[3],t[4]);case 6:return new n(t[0],t[1],t[2],t[3],t[4],t[5]);case 7:return new n(t[0],t[1],t[2],t[3],t[4],t[5],t[6])}var r=io(n.prototype),t=n.apply(r,t);return bu(t)?t:r}}function Jr(n,t,e){function u(){for(var o=arguments.length,f=Hu(o),c=o,a=xe(u);c--;)f[c]=arguments[c];return c=3>o&&f[0]!==a&&f[o-1]!==a?[]:C(f,a),o-=c.length,o<e?fe(n,t,Xr,u.placeholder,F,f,c,F,F,e-o):r(this&&this!==Zn&&this instanceof u?i:n,this,f);
}var i=Hr(n);return u}function Yr(n){return function(t,r,e){var u=ni(t);if(!pu(t)){var i=je(r,3);t=Lu(t),r=function(n){return i(u[n],n,u)}}return r=n(t,r,e),-1<r?u[i?t[r]:r]:F}}function Qr(n){return ge(function(t){var r=t.length,e=r,u=zn.prototype.thru;for(n&&t.reverse();e--;){var i=t[e];if(typeof i!="function")throw new ei("Expected a function");if(u&&!o&&"wrapper"==be(i))var o=new zn([],true)}for(e=o?e:r;++e<r;)var i=t[e],u=be(i),f="wrapper"==u?_o(i):F,o=f&&Be(f[0])&&424==f[1]&&!f[4].length&&1==f[9]?o[be(f[0])].apply(o,f[3]):1==i.length&&Be(i)?o[u]():o.thru(i);
return function(){var n=arguments,e=n[0];if(o&&1==n.length&&af(e))return o.plant(e).value();for(var u=0,n=r?t[u].apply(this,n):e;++u<r;)n=t[u].call(this,n);return n}})}function Xr(n,t,r,e,u,i,o,f,c,a){function l(){for(var d=arguments.length,y=Hu(d),b=d;b--;)y[b]=arguments[b];if(_){var x,j=xe(l),b=y.length;for(x=0;b--;)y[b]===j&&++x}if(e&&(y=Cr(y,e,u,_)),i&&(y=Dr(y,i,o,_)),d-=x,_&&d<a)return j=C(y,j),fe(n,t,Xr,l.placeholder,r,y,j,f,c,a-d);if(j=h?r:this,b=p?j[n]:n,d=y.length,f){x=y.length;for(var w=Mi(f.length,x),m=Mr(y);w--;){
var A=f[w];y[w]=Re(A,x)?m[A]:F}}else v&&1<d&&y.reverse();return s&&c<d&&(y.length=c),this&&this!==Zn&&this instanceof l&&(b=g||Hr(b)),b.apply(j,y)}var s=128&t,h=1&t,p=2&t,_=24&t,v=512&t,g=p?F:Hr(n);return l}function ne(n,t){return function(r,e){return Ct(r,n,t(e))}}function te(n,t){return function(r,e){var u;if(r===F&&e===F)return t;if(r!==F&&(u=r),e!==F){if(u===F)return e;typeof r=="string"||typeof e=="string"?(r=jr(r),e=jr(e)):(r=xr(r),e=xr(e)),u=n(r,e)}return u}}function re(n){return ge(function(t){
return t=l(t,S(je())),lr(function(e){var u=this;return n(t,function(n){return r(n,u,e)})})})}function ee(n,t){t=t===F?" ":jr(t);var r=t.length;return 2>r?r?ar(t,n):t:(r=ar(t,Ri(n/T(t))),Bn.test(t)?zr($(r),0,n).join(""):r.slice(0,n))}function ue(n,t,e,u){function i(){for(var t=-1,c=arguments.length,a=-1,l=u.length,s=Hu(l+c),h=this&&this!==Zn&&this instanceof i?f:n;++a<l;)s[a]=u[a];for(;c--;)s[a++]=arguments[++t];return r(h,o?e:this,s)}var o=1&t,f=Hr(n);return i}function ie(n){return function(t,r,e){
e&&typeof e!="number"&&ze(t,r,e)&&(r=e=F),t=Eu(t),r===F?(r=t,t=0):r=Eu(r),e=e===F?t<r?1:-1:Eu(e);var u=-1;r=Di(Ri((r-t)/(e||1)),0);for(var i=Hu(r);r--;)i[n?r:++u]=t,t+=e;return i}}function oe(n){return function(t,r){return typeof t=="string"&&typeof r=="string"||(t=Iu(t),r=Iu(r)),n(t,r)}}function fe(n,t,r,e,u,i,o,f,c,a){var l=8&t,s=l?o:F;o=l?F:o;var h=l?i:F;return i=l?F:i,t=(t|(l?32:64))&~(l?64:32),4&t||(t&=-4),u=[n,t,u,h,s,i,o,f,c,a],r=r.apply(F,u),Be(n)&&xo(r,u),r.placeholder=e,De(r,n,t)}function ce(n){
var t=Xu[n];return function(n,r){if(n=Iu(n),r=null==r?0:Mi(Ou(r),292)){var e=(zu(n)+"e").split("e"),e=t(e[0]+"e"+(+e[1]+r)),e=(zu(e)+"e").split("e");return+(e[0]+"e"+(+e[1]-r))}return t(n)}}function ae(n){return function(t){var r=yo(t);return"[object Map]"==r?L(t):"[object Set]"==r?M(t):O(t,n(t))}}function le(n,t,r,e,u,i,o,f){var c=2&t;if(!c&&typeof n!="function")throw new ei("Expected a function");var a=e?e.length:0;if(a||(t&=-97,e=u=F),o=o===F?o:Di(Ou(o),0),f=f===F?f:Ou(f),a-=u?u.length:0,64&t){
var l=e,s=u;e=u=F}var h=c?F:_o(n);return i=[n,t,r,e,u,l,s,i,o,f],h&&(r=i[1],n=h[1],t=r|n,e=128==n&&8==r||128==n&&256==r&&i[7].length<=h[8]||384==n&&h[7].length<=h[8]&&8==r,131>t||e)&&(1&n&&(i[2]=h[2],t|=1&r?0:4),(r=h[3])&&(e=i[3],i[3]=e?Cr(e,r,h[4]):r,i[4]=e?C(i[3],"__lodash_placeholder__"):h[4]),(r=h[5])&&(e=i[5],i[5]=e?Dr(e,r,h[6]):r,i[6]=e?C(i[5],"__lodash_placeholder__"):h[6]),(r=h[7])&&(i[7]=r),128&n&&(i[8]=null==i[8]?h[8]:Mi(i[8],h[8])),null==i[9]&&(i[9]=h[9]),i[0]=h[0],i[1]=t),n=i[0],t=i[1],
r=i[2],e=i[3],u=i[4],f=i[9]=i[9]===F?c?0:n.length:Di(i[9]-a,0),!f&&24&t&&(t&=-25),De((h?lo:xo)(t&&1!=t?8==t||16==t?Jr(n,t,f):32!=t&&33!=t||u.length?Xr.apply(F,i):ue(n,t,r,e):Vr(n,t,r),i),n,t)}function se(n,t,r,e){return n===F||hu(n,ii[r])&&!ci.call(e,r)?t:n}function he(n,t,r,e,u,i){return bu(n)&&bu(t)&&(i.set(t,n),nr(n,t,F,he,i),i.delete(t)),n}function pe(n){return wu(n)?F:n}function _e(n,t,r,e,u,i){var o=1&r,f=n.length,c=t.length;if(f!=c&&!(o&&c>f))return false;if((c=i.get(n))&&i.get(t))return c==t;var c=-1,a=true,l=2&r?new qn:F;
for(i.set(n,t),i.set(t,n);++c<f;){var s=n[c],h=t[c];if(e)var p=o?e(h,s,c,t,n,i):e(s,h,c,n,t,i);if(p!==F){if(p)continue;a=false;break}if(l){if(!_(t,function(n,t){if(!R(l,t)&&(s===n||u(s,n,r,e,i)))return l.push(t)})){a=false;break}}else if(s!==h&&!u(s,h,r,e,i)){a=false;break}}return i.delete(n),i.delete(t),a}function ve(n,t,r,e,u,i,o){switch(r){case"[object DataView]":if(n.byteLength!=t.byteLength||n.byteOffset!=t.byteOffset)break;n=n.buffer,t=t.buffer;case"[object ArrayBuffer]":if(n.byteLength!=t.byteLength||!i(new di(n),new di(t)))break;
return true;case"[object Boolean]":case"[object Date]":case"[object Number]":return hu(+n,+t);case"[object Error]":return n.name==t.name&&n.message==t.message;case"[object RegExp]":case"[object String]":return n==t+"";case"[object Map]":var f=L;case"[object Set]":if(f||(f=D),n.size!=t.size&&!(1&e))break;return(r=o.get(n))?r==t:(e|=2,o.set(n,t),t=_e(f(n),f(t),e,u,i,o),o.delete(n),t);case"[object Symbol]":if(eo)return eo.call(n)==eo.call(t)}return false}function ge(n){return wo(Ce(n,F,Ve),n+"")}function de(n){
return Rt(n,Lu,vo)}function ye(n){return Rt(n,Uu,go)}function be(n){for(var t=n.name+"",r=Ji[t],e=ci.call(Ji,t)?r.length:0;e--;){var u=r[e],i=u.func;if(null==i||i==n)return u.name}return t}function xe(n){return(ci.call(On,"placeholder")?On:n).placeholder}function je(){var n=On.iteratee||Pu,n=n===Pu?Gt:n;return arguments.length?n(arguments[0],arguments[1]):n}function we(n,t){var r=n.__data__,e=typeof t;return("string"==e||"number"==e||"symbol"==e||"boolean"==e?"__proto__"!==t:null===t)?r[typeof t=="string"?"string":"hash"]:r.map;
}function me(n){for(var t=Lu(n),r=t.length;r--;){var e=t[r],u=n[e];t[r]=[e,u,u===u&&!bu(u)]}return t}function Ae(n,t){var r=null==n?F:n[t];return Zt(r)?r:F}function ke(n,t,r){t=Rr(t,n);for(var e=-1,u=t.length,i=false;++e<u;){var o=$e(t[e]);if(!(i=null!=n&&r(n,o)))break;n=n[o]}return i||++e!=u?i:(u=null==n?0:n.length,!!u&&yu(u)&&Re(o,u)&&(af(n)||cf(n)))}function Ee(n){var t=n.length,r=n.constructor(t);return t&&"string"==typeof n[0]&&ci.call(n,"index")&&(r.index=n.index,r.input=n.input),r}function Oe(n){
return typeof n.constructor!="function"||Le(n)?{}:io(bi(n))}function Se(r,e,u,i){var o=r.constructor;switch(e){case"[object ArrayBuffer]":return Br(r);case"[object Boolean]":case"[object Date]":return new o(+r);case"[object DataView]":return e=i?Br(r.buffer):r.buffer,new r.constructor(e,r.byteOffset,r.byteLength);case"[object Float32Array]":case"[object Float64Array]":case"[object Int8Array]":case"[object Int16Array]":case"[object Int32Array]":case"[object Uint8Array]":case"[object Uint8ClampedArray]":
case"[object Uint16Array]":case"[object Uint32Array]":return Lr(r,i);case"[object Map]":return e=i?u(L(r),1):L(r),h(e,n,new r.constructor);case"[object Number]":case"[object String]":return new o(r);case"[object RegExp]":return e=new r.constructor(r.source,dn.exec(r)),e.lastIndex=r.lastIndex,e;case"[object Set]":return e=i?u(D(r),1):D(r),h(e,t,new r.constructor);case"[object Symbol]":return eo?ni(eo.call(r)):{}}}function Ie(n){return af(n)||cf(n)||!!(mi&&n&&n[mi])}function Re(n,t){return t=null==t?9007199254740991:t,
!!t&&(typeof n=="number"||wn.test(n))&&-1<n&&0==n%1&&n<t}function ze(n,t,r){if(!bu(r))return false;var e=typeof t;return!!("number"==e?pu(r)&&Re(t,r.length):"string"==e&&t in r)&&hu(r[t],n)}function We(n,t){if(af(n))return false;var r=typeof n;return!("number"!=r&&"symbol"!=r&&"boolean"!=r&&null!=n&&!Au(n))||(rn.test(n)||!tn.test(n)||null!=t&&n in ni(t))}function Be(n){var t=be(n),r=On[t];return typeof r=="function"&&t in Mn.prototype&&(n===r||(t=_o(r),!!t&&n===t[0]))}function Le(n){var t=n&&n.constructor;
return n===(typeof t=="function"&&t.prototype||ii)}function Ue(n,t){return function(r){return null!=r&&(r[n]===t&&(t!==F||n in ni(r)))}}function Ce(n,t,e){return t=Di(t===F?n.length-1:t,0),function(){for(var u=arguments,i=-1,o=Di(u.length-t,0),f=Hu(o);++i<o;)f[i]=u[t+i];for(i=-1,o=Hu(t+1);++i<t;)o[i]=u[i];return o[t]=e(f),r(n,this,o)}}function De(n,t,r){var e=t+"";t=wo;var u,i=Ne;return u=(u=e.match(hn))?u[1].split(pn):[],r=i(u,r),(i=r.length)&&(u=i-1,r[u]=(1<i?"& ":"")+r[u],r=r.join(2<i?", ":" "),
e=e.replace(sn,"{\n/* [wrapped with "+r+"] */\n")),t(n,e)}function Me(n){var t=0,r=0;return function(){var e=Ti(),u=16-(e-r);if(r=e,0<u){if(800<=++t)return arguments[0]}else t=0;return n.apply(F,arguments)}}function Te(n,t){var r=-1,e=n.length,u=e-1;for(t=t===F?e:t;++r<t;){var e=cr(r,u),i=n[e];n[e]=n[r],n[r]=i}return n.length=t,n}function $e(n){if(typeof n=="string"||Au(n))return n;var t=n+"";return"0"==t&&1/n==-N?"-0":t}function Fe(n){if(null!=n){try{return fi.call(n)}catch(n){}return n+""}return"";
}function Ne(n,t){return u(Z,function(r){var e="_."+r[0];t&r[1]&&!c(n,e)&&n.push(e)}),n.sort()}function Pe(n){if(n instanceof Mn)return n.clone();var t=new zn(n.__wrapped__,n.__chain__);return t.__actions__=Mr(n.__actions__),t.__index__=n.__index__,t.__values__=n.__values__,t}function Ze(n,t,r){var e=null==n?0:n.length;return e?(r=null==r?0:Ou(r),0>r&&(r=Di(e+r,0)),g(n,je(t,3),r)):-1}function qe(n,t,r){var e=null==n?0:n.length;if(!e)return-1;var u=e-1;return r!==F&&(u=Ou(r),u=0>r?Di(e+u,0):Mi(u,e-1)),
g(n,je(t,3),u,true)}function Ve(n){return(null==n?0:n.length)?kt(n,1):[]}function Ke(n){return n&&n.length?n[0]:F}function Ge(n){var t=null==n?0:n.length;return t?n[t-1]:F}function He(n,t){return n&&n.length&&t&&t.length?or(n,t):n}function Je(n){return null==n?n:Ni.call(n)}function Ye(n){if(!n||!n.length)return[];var t=0;return n=f(n,function(n){if(_u(n))return t=Di(n.length,t),true}),E(t,function(t){return l(n,j(t))})}function Qe(n,t){if(!n||!n.length)return[];var e=Ye(n);return null==t?e:l(e,function(n){
return r(t,F,n)})}function Xe(n){return n=On(n),n.__chain__=true,n}function nu(n,t){return t(n)}function tu(){return this}function ru(n,t){return(af(n)?u:oo)(n,je(t,3))}function eu(n,t){return(af(n)?i:fo)(n,je(t,3))}function uu(n,t){return(af(n)?l:Yt)(n,je(t,3))}function iu(n,t,r){return t=r?F:t,t=n&&null==t?n.length:t,le(n,128,F,F,F,F,t)}function ou(n,t){var r;if(typeof t!="function")throw new ei("Expected a function");return n=Ou(n),function(){return 0<--n&&(r=t.apply(this,arguments)),1>=n&&(t=F),
r}}function fu(n,t,r){return t=r?F:t,n=le(n,8,F,F,F,F,F,t),n.placeholder=fu.placeholder,n}function cu(n,t,r){return t=r?F:t,n=le(n,16,F,F,F,F,F,t),n.placeholder=cu.placeholder,n}function au(n,t,r){function e(t){var r=c,e=a;return c=a=F,_=t,s=n.apply(e,r)}function u(n){var r=n-p;return n-=_,p===F||r>=t||0>r||g&&n>=l}function i(){var n=Jo();if(u(n))return o(n);var r,e=jo;r=n-_,n=t-(n-p),r=g?Mi(n,l-r):n,h=e(i,r)}function o(n){return h=F,d&&c?e(n):(c=a=F,s)}function f(){var n=Jo(),r=u(n);if(c=arguments,
a=this,p=n,r){if(h===F)return _=n=p,h=jo(i,t),v?e(n):s;if(g)return h=jo(i,t),e(p)}return h===F&&(h=jo(i,t)),s}var c,a,l,s,h,p,_=0,v=false,g=false,d=true;if(typeof n!="function")throw new ei("Expected a function");return t=Iu(t)||0,bu(r)&&(v=!!r.leading,l=(g="maxWait"in r)?Di(Iu(r.maxWait)||0,t):l,d="trailing"in r?!!r.trailing:d),f.cancel=function(){h!==F&&ho(h),_=0,c=p=a=h=F},f.flush=function(){return h===F?s:o(Jo())},f}function lu(n,t){function r(){var e=arguments,u=t?t.apply(this,e):e[0],i=r.cache;return i.has(u)?i.get(u):(e=n.apply(this,e),
r.cache=i.set(u,e)||i,e)}if(typeof n!="function"||null!=t&&typeof t!="function")throw new ei("Expected a function");return r.cache=new(lu.Cache||Pn),r}function su(n){if(typeof n!="function")throw new ei("Expected a function");return function(){var t=arguments;switch(t.length){case 0:return!n.call(this);case 1:return!n.call(this,t[0]);case 2:return!n.call(this,t[0],t[1]);case 3:return!n.call(this,t[0],t[1],t[2])}return!n.apply(this,t)}}function hu(n,t){return n===t||n!==n&&t!==t}function pu(n){return null!=n&&yu(n.length)&&!gu(n);
}function _u(n){return xu(n)&&pu(n)}function vu(n){if(!xu(n))return false;var t=zt(n);return"[object Error]"==t||"[object DOMException]"==t||typeof n.message=="string"&&typeof n.name=="string"&&!wu(n)}function gu(n){return!!bu(n)&&(n=zt(n),"[object Function]"==n||"[object GeneratorFunction]"==n||"[object AsyncFunction]"==n||"[object Proxy]"==n)}function du(n){return typeof n=="number"&&n==Ou(n)}function yu(n){return typeof n=="number"&&-1<n&&0==n%1&&9007199254740991>=n}function bu(n){var t=typeof n;return null!=n&&("object"==t||"function"==t);
}function xu(n){return null!=n&&typeof n=="object"}function ju(n){return typeof n=="number"||xu(n)&&"[object Number]"==zt(n)}function wu(n){return!(!xu(n)||"[object Object]"!=zt(n))&&(n=bi(n),null===n||(n=ci.call(n,"constructor")&&n.constructor,typeof n=="function"&&n instanceof n&&fi.call(n)==hi))}function mu(n){return typeof n=="string"||!af(n)&&xu(n)&&"[object String]"==zt(n)}function Au(n){return typeof n=="symbol"||xu(n)&&"[object Symbol]"==zt(n)}function ku(n){if(!n)return[];if(pu(n))return mu(n)?$(n):Mr(n);
if(Ai&&n[Ai]){n=n[Ai]();for(var t,r=[];!(t=n.next()).done;)r.push(t.value);return r}return t=yo(n),("[object Map]"==t?L:"[object Set]"==t?D:Du)(n)}function Eu(n){return n?(n=Iu(n),n===N||n===-N?1.7976931348623157e308*(0>n?-1:1):n===n?n:0):0===n?n:0}function Ou(n){n=Eu(n);var t=n%1;return n===n?t?n-t:n:0}function Su(n){return n?gt(Ou(n),0,4294967295):0}function Iu(n){if(typeof n=="number")return n;if(Au(n))return P;if(bu(n)&&(n=typeof n.valueOf=="function"?n.valueOf():n,n=bu(n)?n+"":n),typeof n!="string")return 0===n?n:+n;
n=n.replace(cn,"");var t=bn.test(n);return t||jn.test(n)?Fn(n.slice(2),t?2:8):yn.test(n)?P:+n}function Ru(n){return Tr(n,Uu(n))}function zu(n){return null==n?"":jr(n)}function Wu(n,t,r){return n=null==n?F:It(n,t),n===F?r:n}function Bu(n,t){return null!=n&&ke(n,t,Lt)}function Lu(n){return pu(n)?Gn(n):Ht(n)}function Uu(n){if(pu(n))n=Gn(n,true);else if(bu(n)){var t,r=Le(n),e=[];for(t in n)("constructor"!=t||!r&&ci.call(n,t))&&e.push(t);n=e}else{if(t=[],null!=n)for(r in ni(n))t.push(r);n=t}return n}function Cu(n,t){
if(null==n)return{};var r=l(ye(n),function(n){return[n]});return t=je(t),ur(n,r,function(n,r){return t(n,r[0])})}function Du(n){return null==n?[]:I(n,Lu(n))}function Mu(n){return Nf(zu(n).toLowerCase())}function Tu(n){return(n=zu(n))&&n.replace(mn,rt).replace(Rn,"")}function $u(n,t,r){return n=zu(n),t=r?F:t,t===F?Ln.test(n)?n.match(Wn)||[]:n.match(_n)||[]:n.match(t)||[]}function Fu(n){return function(){return n}}function Nu(n){return n}function Pu(n){return Gt(typeof n=="function"?n:dt(n,1))}function Zu(n,t,r){
var e=Lu(t),i=St(t,e);null!=r||bu(t)&&(i.length||!e.length)||(r=t,t=n,n=this,i=St(t,Lu(t)));var o=!(bu(r)&&"chain"in r&&!r.chain),f=gu(n);return u(i,function(r){var e=t[r];n[r]=e,f&&(n.prototype[r]=function(){var t=this.__chain__;if(o||t){var r=n(this.__wrapped__);return(r.__actions__=Mr(this.__actions__)).push({func:e,args:arguments,thisArg:n}),r.__chain__=t,r}return e.apply(n,s([this.value()],arguments))})}),n}function qu(){}function Vu(n){return We(n)?j($e(n)):ir(n)}function Ku(){return[]}function Gu(){
return false}En=null==En?Zn:it.defaults(Zn.Object(),En,it.pick(Zn,Un));var Hu=En.Array,Ju=En.Date,Yu=En.Error,Qu=En.Function,Xu=En.Math,ni=En.Object,ti=En.RegExp,ri=En.String,ei=En.TypeError,ui=Hu.prototype,ii=ni.prototype,oi=En["__core-js_shared__"],fi=Qu.prototype.toString,ci=ii.hasOwnProperty,ai=0,li=function(){var n=/[^.]+$/.exec(oi&&oi.keys&&oi.keys.IE_PROTO||"");return n?"Symbol(src)_1."+n:""}(),si=ii.toString,hi=fi.call(ni),pi=Zn._,_i=ti("^"+fi.call(ci).replace(on,"\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g,"$1.*?")+"$"),vi=Kn?En.Buffer:F,gi=En.Symbol,di=En.Uint8Array,yi=vi?vi.f:F,bi=U(ni.getPrototypeOf,ni),xi=ni.create,ji=ii.propertyIsEnumerable,wi=ui.splice,mi=gi?gi.isConcatSpreadable:F,Ai=gi?gi.iterator:F,ki=gi?gi.toStringTag:F,Ei=function(){
try{var n=Ae(ni,"defineProperty");return n({},"",{}),n}catch(n){}}(),Oi=En.clearTimeout!==Zn.clearTimeout&&En.clearTimeout,Si=Ju&&Ju.now!==Zn.Date.now&&Ju.now,Ii=En.setTimeout!==Zn.setTimeout&&En.setTimeout,Ri=Xu.ceil,zi=Xu.floor,Wi=ni.getOwnPropertySymbols,Bi=vi?vi.isBuffer:F,Li=En.isFinite,Ui=ui.join,Ci=U(ni.keys,ni),Di=Xu.max,Mi=Xu.min,Ti=Ju.now,$i=En.parseInt,Fi=Xu.random,Ni=ui.reverse,Pi=Ae(En,"DataView"),Zi=Ae(En,"Map"),qi=Ae(En,"Promise"),Vi=Ae(En,"Set"),Ki=Ae(En,"WeakMap"),Gi=Ae(ni,"create"),Hi=Ki&&new Ki,Ji={},Yi=Fe(Pi),Qi=Fe(Zi),Xi=Fe(qi),no=Fe(Vi),to=Fe(Ki),ro=gi?gi.prototype:F,eo=ro?ro.valueOf:F,uo=ro?ro.toString:F,io=function(){
function n(){}return function(t){return bu(t)?xi?xi(t):(n.prototype=t,t=new n,n.prototype=F,t):{}}}();On.templateSettings={escape:Q,evaluate:X,interpolate:nn,variable:"",imports:{_:On}},On.prototype=Sn.prototype,On.prototype.constructor=On,zn.prototype=io(Sn.prototype),zn.prototype.constructor=zn,Mn.prototype=io(Sn.prototype),Mn.prototype.constructor=Mn,Tn.prototype.clear=function(){this.__data__=Gi?Gi(null):{},this.size=0},Tn.prototype.delete=function(n){return n=this.has(n)&&delete this.__data__[n],
this.size-=n?1:0,n},Tn.prototype.get=function(n){var t=this.__data__;return Gi?(n=t[n],"__lodash_hash_undefined__"===n?F:n):ci.call(t,n)?t[n]:F},Tn.prototype.has=function(n){var t=this.__data__;return Gi?t[n]!==F:ci.call(t,n)},Tn.prototype.set=function(n,t){var r=this.__data__;return this.size+=this.has(n)?0:1,r[n]=Gi&&t===F?"__lodash_hash_undefined__":t,this},Nn.prototype.clear=function(){this.__data__=[],this.size=0},Nn.prototype.delete=function(n){var t=this.__data__;return n=lt(t,n),!(0>n)&&(n==t.length-1?t.pop():wi.call(t,n,1),
--this.size,true)},Nn.prototype.get=function(n){var t=this.__data__;return n=lt(t,n),0>n?F:t[n][1]},Nn.prototype.has=function(n){return-1<lt(this.__data__,n)},Nn.prototype.set=function(n,t){var r=this.__data__,e=lt(r,n);return 0>e?(++this.size,r.push([n,t])):r[e][1]=t,this},Pn.prototype.clear=function(){this.size=0,this.__data__={hash:new Tn,map:new(Zi||Nn),string:new Tn}},Pn.prototype.delete=function(n){return n=we(this,n).delete(n),this.size-=n?1:0,n},Pn.prototype.get=function(n){return we(this,n).get(n);
},Pn.prototype.has=function(n){return we(this,n).has(n)},Pn.prototype.set=function(n,t){var r=we(this,n),e=r.size;return r.set(n,t),this.size+=r.size==e?0:1,this},qn.prototype.add=qn.prototype.push=function(n){return this.__data__.set(n,"__lodash_hash_undefined__"),this},qn.prototype.has=function(n){return this.__data__.has(n)},Vn.prototype.clear=function(){this.__data__=new Nn,this.size=0},Vn.prototype.delete=function(n){var t=this.__data__;return n=t.delete(n),this.size=t.size,n},Vn.prototype.get=function(n){
return this.__data__.get(n)},Vn.prototype.has=function(n){return this.__data__.has(n)},Vn.prototype.set=function(n,t){var r=this.__data__;if(r instanceof Nn){var e=r.__data__;if(!Zi||199>e.length)return e.push([n,t]),this.size=++r.size,this;r=this.__data__=new Pn(e)}return r.set(n,t),this.size=r.size,this};var oo=Zr(Et),fo=Zr(Ot,true),co=qr(),ao=qr(true),lo=Hi?function(n,t){return Hi.set(n,t),n}:Nu,so=Ei?function(n,t){return Ei(n,"toString",{configurable:true,enumerable:false,value:Fu(t),writable:true})}:Nu,ho=Oi||function(n){
return Zn.clearTimeout(n)},po=Vi&&1/D(new Vi([,-0]))[1]==N?function(n){return new Vi(n)}:qu,_o=Hi?function(n){return Hi.get(n)}:qu,vo=Wi?function(n){return null==n?[]:(n=ni(n),f(Wi(n),function(t){return ji.call(n,t)}))}:Ku,go=Wi?function(n){for(var t=[];n;)s(t,vo(n)),n=bi(n);return t}:Ku,yo=zt;(Pi&&"[object DataView]"!=yo(new Pi(new ArrayBuffer(1)))||Zi&&"[object Map]"!=yo(new Zi)||qi&&"[object Promise]"!=yo(qi.resolve())||Vi&&"[object Set]"!=yo(new Vi)||Ki&&"[object WeakMap]"!=yo(new Ki))&&(yo=function(n){
var t=zt(n);if(n=(n="[object Object]"==t?n.constructor:F)?Fe(n):"")switch(n){case Yi:return"[object DataView]";case Qi:return"[object Map]";case Xi:return"[object Promise]";case no:return"[object Set]";case to:return"[object WeakMap]"}return t});var bo=oi?gu:Gu,xo=Me(lo),jo=Ii||function(n,t){return Zn.setTimeout(n,t)},wo=Me(so),mo=function(n){n=lu(n,function(n){return 500===t.size&&t.clear(),n});var t=n.cache;return n}(function(n){var t=[];return en.test(n)&&t.push(""),n.replace(un,function(n,r,e,u){
t.push(e?u.replace(vn,"$1"):r||n)}),t}),Ao=lr(function(n,t){return _u(n)?jt(n,kt(t,1,_u,true)):[]}),ko=lr(function(n,t){var r=Ge(t);return _u(r)&&(r=F),_u(n)?jt(n,kt(t,1,_u,true),je(r,2)):[]}),Eo=lr(function(n,t){var r=Ge(t);return _u(r)&&(r=F),_u(n)?jt(n,kt(t,1,_u,true),F,r):[]}),Oo=lr(function(n){var t=l(n,Sr);return t.length&&t[0]===n[0]?Ut(t):[]}),So=lr(function(n){var t=Ge(n),r=l(n,Sr);return t===Ge(r)?t=F:r.pop(),r.length&&r[0]===n[0]?Ut(r,je(t,2)):[]}),Io=lr(function(n){var t=Ge(n),r=l(n,Sr);return(t=typeof t=="function"?t:F)&&r.pop(),
r.length&&r[0]===n[0]?Ut(r,F,t):[]}),Ro=lr(He),zo=ge(function(n,t){var r=null==n?0:n.length,e=vt(n,t);return fr(n,l(t,function(n){return Re(n,r)?+n:n}).sort(Ur)),e}),Wo=lr(function(n){return wr(kt(n,1,_u,true))}),Bo=lr(function(n){var t=Ge(n);return _u(t)&&(t=F),wr(kt(n,1,_u,true),je(t,2))}),Lo=lr(function(n){var t=Ge(n),t=typeof t=="function"?t:F;return wr(kt(n,1,_u,true),F,t)}),Uo=lr(function(n,t){return _u(n)?jt(n,t):[]}),Co=lr(function(n){return Er(f(n,_u))}),Do=lr(function(n){var t=Ge(n);return _u(t)&&(t=F),
Er(f(n,_u),je(t,2))}),Mo=lr(function(n){var t=Ge(n),t=typeof t=="function"?t:F;return Er(f(n,_u),F,t)}),To=lr(Ye),$o=lr(function(n){var t=n.length,t=1<t?n[t-1]:F,t=typeof t=="function"?(n.pop(),t):F;return Qe(n,t)}),Fo=ge(function(n){function t(t){return vt(t,n)}var r=n.length,e=r?n[0]:0,u=this.__wrapped__;return!(1<r||this.__actions__.length)&&u instanceof Mn&&Re(e)?(u=u.slice(e,+e+(r?1:0)),u.__actions__.push({func:nu,args:[t],thisArg:F}),new zn(u,this.__chain__).thru(function(n){return r&&!n.length&&n.push(F),
n})):this.thru(t)}),No=Nr(function(n,t,r){ci.call(n,r)?++n[r]:_t(n,r,1)}),Po=Yr(Ze),Zo=Yr(qe),qo=Nr(function(n,t,r){ci.call(n,r)?n[r].push(t):_t(n,r,[t])}),Vo=lr(function(n,t,e){var u=-1,i=typeof t=="function",o=pu(n)?Hu(n.length):[];return oo(n,function(n){o[++u]=i?r(t,n,e):Dt(n,t,e)}),o}),Ko=Nr(function(n,t,r){_t(n,r,t)}),Go=Nr(function(n,t,r){n[r?0:1].push(t)},function(){return[[],[]]}),Ho=lr(function(n,t){if(null==n)return[];var r=t.length;return 1<r&&ze(n,t[0],t[1])?t=[]:2<r&&ze(t[0],t[1],t[2])&&(t=[t[0]]),
rr(n,kt(t,1),[])}),Jo=Si||function(){return Zn.Date.now()},Yo=lr(function(n,t,r){var e=1;if(r.length)var u=C(r,xe(Yo)),e=32|e;return le(n,e,t,r,u)}),Qo=lr(function(n,t,r){var e=3;if(r.length)var u=C(r,xe(Qo)),e=32|e;return le(t,e,n,r,u)}),Xo=lr(function(n,t){return xt(n,1,t)}),nf=lr(function(n,t,r){return xt(n,Iu(t)||0,r)});lu.Cache=Pn;var tf=lr(function(n,t){t=1==t.length&&af(t[0])?l(t[0],S(je())):l(kt(t,1),S(je()));var e=t.length;return lr(function(u){for(var i=-1,o=Mi(u.length,e);++i<o;)u[i]=t[i].call(this,u[i]);
return r(n,this,u)})}),rf=lr(function(n,t){return le(n,32,F,t,C(t,xe(rf)))}),ef=lr(function(n,t){return le(n,64,F,t,C(t,xe(ef)))}),uf=ge(function(n,t){return le(n,256,F,F,F,t)}),of=oe(Wt),ff=oe(function(n,t){return n>=t}),cf=Mt(function(){return arguments}())?Mt:function(n){return xu(n)&&ci.call(n,"callee")&&!ji.call(n,"callee")},af=Hu.isArray,lf=Hn?S(Hn):Tt,sf=Bi||Gu,hf=Jn?S(Jn):$t,pf=Yn?S(Yn):Nt,_f=Qn?S(Qn):qt,vf=Xn?S(Xn):Vt,gf=nt?S(nt):Kt,df=oe(Jt),yf=oe(function(n,t){return n<=t}),bf=Pr(function(n,t){
if(Le(t)||pu(t))Tr(t,Lu(t),n);else for(var r in t)ci.call(t,r)&&at(n,r,t[r])}),xf=Pr(function(n,t){Tr(t,Uu(t),n)}),jf=Pr(function(n,t,r,e){Tr(t,Uu(t),n,e)}),wf=Pr(function(n,t,r,e){Tr(t,Lu(t),n,e)}),mf=ge(vt),Af=lr(function(n){return n.push(F,se),r(jf,F,n)}),kf=lr(function(n){return n.push(F,he),r(Rf,F,n)}),Ef=ne(function(n,t,r){n[t]=r},Fu(Nu)),Of=ne(function(n,t,r){ci.call(n,t)?n[t].push(r):n[t]=[r]},je),Sf=lr(Dt),If=Pr(function(n,t,r){nr(n,t,r)}),Rf=Pr(function(n,t,r,e){nr(n,t,r,e)}),zf=ge(function(n,t){
var r={};if(null==n)return r;var e=false;t=l(t,function(t){return t=Rr(t,n),e||(e=1<t.length),t}),Tr(n,ye(n),r),e&&(r=dt(r,7,pe));for(var u=t.length;u--;)mr(r,t[u]);return r}),Wf=ge(function(n,t){return null==n?{}:er(n,t)}),Bf=ae(Lu),Lf=ae(Uu),Uf=Gr(function(n,t,r){return t=t.toLowerCase(),n+(r?Mu(t):t)}),Cf=Gr(function(n,t,r){return n+(r?"-":"")+t.toLowerCase()}),Df=Gr(function(n,t,r){return n+(r?" ":"")+t.toLowerCase()}),Mf=Kr("toLowerCase"),Tf=Gr(function(n,t,r){return n+(r?"_":"")+t.toLowerCase();
}),$f=Gr(function(n,t,r){return n+(r?" ":"")+Nf(t)}),Ff=Gr(function(n,t,r){return n+(r?" ":"")+t.toUpperCase()}),Nf=Kr("toUpperCase"),Pf=lr(function(n,t){try{return r(n,F,t)}catch(n){return vu(n)?n:new Yu(n)}}),Zf=ge(function(n,t){return u(t,function(t){t=$e(t),_t(n,t,Yo(n[t],n))}),n}),qf=Qr(),Vf=Qr(true),Kf=lr(function(n,t){return function(r){return Dt(r,n,t)}}),Gf=lr(function(n,t){return function(r){return Dt(n,r,t)}}),Hf=re(l),Jf=re(o),Yf=re(_),Qf=ie(),Xf=ie(true),nc=te(function(n,t){return n+t},0),tc=ce("ceil"),rc=te(function(n,t){
return n/t},1),ec=ce("floor"),uc=te(function(n,t){return n*t},1),ic=ce("round"),oc=te(function(n,t){return n-t},0);return On.after=function(n,t){if(typeof t!="function")throw new ei("Expected a function");return n=Ou(n),function(){if(1>--n)return t.apply(this,arguments)}},On.ary=iu,On.assign=bf,On.assignIn=xf,On.assignInWith=jf,On.assignWith=wf,On.at=mf,On.before=ou,On.bind=Yo,On.bindAll=Zf,On.bindKey=Qo,On.castArray=function(){if(!arguments.length)return[];var n=arguments[0];return af(n)?n:[n]},
On.chain=Xe,On.chunk=function(n,t,r){if(t=(r?ze(n,t,r):t===F)?1:Di(Ou(t),0),r=null==n?0:n.length,!r||1>t)return[];for(var e=0,u=0,i=Hu(Ri(r/t));e<r;)i[u++]=vr(n,e,e+=t);return i},On.compact=function(n){for(var t=-1,r=null==n?0:n.length,e=0,u=[];++t<r;){var i=n[t];i&&(u[e++]=i)}return u},On.concat=function(){var n=arguments.length;if(!n)return[];for(var t=Hu(n-1),r=arguments[0];n--;)t[n-1]=arguments[n];return s(af(r)?Mr(r):[r],kt(t,1))},On.cond=function(n){var t=null==n?0:n.length,e=je();return n=t?l(n,function(n){
if("function"!=typeof n[1])throw new ei("Expected a function");return[e(n[0]),n[1]]}):[],lr(function(e){for(var u=-1;++u<t;){var i=n[u];if(r(i[0],this,e))return r(i[1],this,e)}})},On.conforms=function(n){return yt(dt(n,1))},On.constant=Fu,On.countBy=No,On.create=function(n,t){var r=io(n);return null==t?r:ht(r,t)},On.curry=fu,On.curryRight=cu,On.debounce=au,On.defaults=Af,On.defaultsDeep=kf,On.defer=Xo,On.delay=nf,On.difference=Ao,On.differenceBy=ko,On.differenceWith=Eo,On.drop=function(n,t,r){var e=null==n?0:n.length;
return e?(t=r||t===F?1:Ou(t),vr(n,0>t?0:t,e)):[]},On.dropRight=function(n,t,r){var e=null==n?0:n.length;return e?(t=r||t===F?1:Ou(t),t=e-t,vr(n,0,0>t?0:t)):[]},On.dropRightWhile=function(n,t){return n&&n.length?Ar(n,je(t,3),true,true):[]},On.dropWhile=function(n,t){return n&&n.length?Ar(n,je(t,3),true):[]},On.fill=function(n,t,r,e){var u=null==n?0:n.length;if(!u)return[];for(r&&typeof r!="number"&&ze(n,t,r)&&(r=0,e=u),u=n.length,r=Ou(r),0>r&&(r=-r>u?0:u+r),e=e===F||e>u?u:Ou(e),0>e&&(e+=u),e=r>e?0:Su(e);r<e;)n[r++]=t;
return n},On.filter=function(n,t){return(af(n)?f:At)(n,je(t,3))},On.flatMap=function(n,t){return kt(uu(n,t),1)},On.flatMapDeep=function(n,t){return kt(uu(n,t),N)},On.flatMapDepth=function(n,t,r){return r=r===F?1:Ou(r),kt(uu(n,t),r)},On.flatten=Ve,On.flattenDeep=function(n){return(null==n?0:n.length)?kt(n,N):[]},On.flattenDepth=function(n,t){return null!=n&&n.length?(t=t===F?1:Ou(t),kt(n,t)):[]},On.flip=function(n){return le(n,512)},On.flow=qf,On.flowRight=Vf,On.fromPairs=function(n){for(var t=-1,r=null==n?0:n.length,e={};++t<r;){
var u=n[t];e[u[0]]=u[1]}return e},On.functions=function(n){return null==n?[]:St(n,Lu(n))},On.functionsIn=function(n){return null==n?[]:St(n,Uu(n))},On.groupBy=qo,On.initial=function(n){return(null==n?0:n.length)?vr(n,0,-1):[]},On.intersection=Oo,On.intersectionBy=So,On.intersectionWith=Io,On.invert=Ef,On.invertBy=Of,On.invokeMap=Vo,On.iteratee=Pu,On.keyBy=Ko,On.keys=Lu,On.keysIn=Uu,On.map=uu,On.mapKeys=function(n,t){var r={};return t=je(t,3),Et(n,function(n,e,u){_t(r,t(n,e,u),n)}),r},On.mapValues=function(n,t){
var r={};return t=je(t,3),Et(n,function(n,e,u){_t(r,e,t(n,e,u))}),r},On.matches=function(n){return Qt(dt(n,1))},On.matchesProperty=function(n,t){return Xt(n,dt(t,1))},On.memoize=lu,On.merge=If,On.mergeWith=Rf,On.method=Kf,On.methodOf=Gf,On.mixin=Zu,On.negate=su,On.nthArg=function(n){return n=Ou(n),lr(function(t){return tr(t,n)})},On.omit=zf,On.omitBy=function(n,t){return Cu(n,su(je(t)))},On.once=function(n){return ou(2,n)},On.orderBy=function(n,t,r,e){return null==n?[]:(af(t)||(t=null==t?[]:[t]),
r=e?F:r,af(r)||(r=null==r?[]:[r]),rr(n,t,r))},On.over=Hf,On.overArgs=tf,On.overEvery=Jf,On.overSome=Yf,On.partial=rf,On.partialRight=ef,On.partition=Go,On.pick=Wf,On.pickBy=Cu,On.property=Vu,On.propertyOf=function(n){return function(t){return null==n?F:It(n,t)}},On.pull=Ro,On.pullAll=He,On.pullAllBy=function(n,t,r){return n&&n.length&&t&&t.length?or(n,t,je(r,2)):n},On.pullAllWith=function(n,t,r){return n&&n.length&&t&&t.length?or(n,t,F,r):n},On.pullAt=zo,On.range=Qf,On.rangeRight=Xf,On.rearg=uf,On.reject=function(n,t){
return(af(n)?f:At)(n,su(je(t,3)))},On.remove=function(n,t){var r=[];if(!n||!n.length)return r;var e=-1,u=[],i=n.length;for(t=je(t,3);++e<i;){var o=n[e];t(o,e,n)&&(r.push(o),u.push(e))}return fr(n,u),r},On.rest=function(n,t){if(typeof n!="function")throw new ei("Expected a function");return t=t===F?t:Ou(t),lr(n,t)},On.reverse=Je,On.sampleSize=function(n,t,r){return t=(r?ze(n,t,r):t===F)?1:Ou(t),(af(n)?ot:hr)(n,t)},On.set=function(n,t,r){return null==n?n:pr(n,t,r)},On.setWith=function(n,t,r,e){return e=typeof e=="function"?e:F,
null==n?n:pr(n,t,r,e)},On.shuffle=function(n){return(af(n)?ft:_r)(n)},On.slice=function(n,t,r){var e=null==n?0:n.length;return e?(r&&typeof r!="number"&&ze(n,t,r)?(t=0,r=e):(t=null==t?0:Ou(t),r=r===F?e:Ou(r)),vr(n,t,r)):[]},On.sortBy=Ho,On.sortedUniq=function(n){return n&&n.length?br(n):[]},On.sortedUniqBy=function(n,t){return n&&n.length?br(n,je(t,2)):[]},On.split=function(n,t,r){return r&&typeof r!="number"&&ze(n,t,r)&&(t=r=F),r=r===F?4294967295:r>>>0,r?(n=zu(n))&&(typeof t=="string"||null!=t&&!_f(t))&&(t=jr(t),
!t&&Bn.test(n))?zr($(n),0,r):n.split(t,r):[]},On.spread=function(n,t){if(typeof n!="function")throw new ei("Expected a function");return t=null==t?0:Di(Ou(t),0),lr(function(e){var u=e[t];return e=zr(e,0,t),u&&s(e,u),r(n,this,e)})},On.tail=function(n){var t=null==n?0:n.length;return t?vr(n,1,t):[]},On.take=function(n,t,r){return n&&n.length?(t=r||t===F?1:Ou(t),vr(n,0,0>t?0:t)):[]},On.takeRight=function(n,t,r){var e=null==n?0:n.length;return e?(t=r||t===F?1:Ou(t),t=e-t,vr(n,0>t?0:t,e)):[]},On.takeRightWhile=function(n,t){
return n&&n.length?Ar(n,je(t,3),false,true):[]},On.takeWhile=function(n,t){return n&&n.length?Ar(n,je(t,3)):[]},On.tap=function(n,t){return t(n),n},On.throttle=function(n,t,r){var e=true,u=true;if(typeof n!="function")throw new ei("Expected a function");return bu(r)&&(e="leading"in r?!!r.leading:e,u="trailing"in r?!!r.trailing:u),au(n,t,{leading:e,maxWait:t,trailing:u})},On.thru=nu,On.toArray=ku,On.toPairs=Bf,On.toPairsIn=Lf,On.toPath=function(n){return af(n)?l(n,$e):Au(n)?[n]:Mr(mo(zu(n)))},On.toPlainObject=Ru,
On.transform=function(n,t,r){var e=af(n),i=e||sf(n)||gf(n);if(t=je(t,4),null==r){var o=n&&n.constructor;r=i?e?new o:[]:bu(n)&&gu(o)?io(bi(n)):{}}return(i?u:Et)(n,function(n,e,u){return t(r,n,e,u)}),r},On.unary=function(n){return iu(n,1)},On.union=Wo,On.unionBy=Bo,On.unionWith=Lo,On.uniq=function(n){return n&&n.length?wr(n):[]},On.uniqBy=function(n,t){return n&&n.length?wr(n,je(t,2)):[]},On.uniqWith=function(n,t){return t=typeof t=="function"?t:F,n&&n.length?wr(n,F,t):[]},On.unset=function(n,t){return null==n||mr(n,t);
},On.unzip=Ye,On.unzipWith=Qe,On.update=function(n,t,r){return null==n?n:pr(n,t,Ir(r)(It(n,t)),void 0)},On.updateWith=function(n,t,r,e){return e=typeof e=="function"?e:F,null!=n&&(n=pr(n,t,Ir(r)(It(n,t)),e)),n},On.values=Du,On.valuesIn=function(n){return null==n?[]:I(n,Uu(n))},On.without=Uo,On.words=$u,On.wrap=function(n,t){return rf(Ir(t),n)},On.xor=Co,On.xorBy=Do,On.xorWith=Mo,On.zip=To,On.zipObject=function(n,t){return Or(n||[],t||[],at)},On.zipObjectDeep=function(n,t){return Or(n||[],t||[],pr);
},On.zipWith=$o,On.entries=Bf,On.entriesIn=Lf,On.extend=xf,On.extendWith=jf,Zu(On,On),On.add=nc,On.attempt=Pf,On.camelCase=Uf,On.capitalize=Mu,On.ceil=tc,On.clamp=function(n,t,r){return r===F&&(r=t,t=F),r!==F&&(r=Iu(r),r=r===r?r:0),t!==F&&(t=Iu(t),t=t===t?t:0),gt(Iu(n),t,r)},On.clone=function(n){return dt(n,4)},On.cloneDeep=function(n){return dt(n,5)},On.cloneDeepWith=function(n,t){return t=typeof t=="function"?t:F,dt(n,5,t)},On.cloneWith=function(n,t){return t=typeof t=="function"?t:F,dt(n,4,t)},
On.conformsTo=function(n,t){return null==t||bt(n,t,Lu(t))},On.deburr=Tu,On.defaultTo=function(n,t){return null==n||n!==n?t:n},On.divide=rc,On.endsWith=function(n,t,r){n=zu(n),t=jr(t);var e=n.length,e=r=r===F?e:gt(Ou(r),0,e);return r-=t.length,0<=r&&n.slice(r,e)==t},On.eq=hu,On.escape=function(n){return(n=zu(n))&&Y.test(n)?n.replace(H,et):n},On.escapeRegExp=function(n){return(n=zu(n))&&fn.test(n)?n.replace(on,"\\$&"):n},On.every=function(n,t,r){var e=af(n)?o:wt;return r&&ze(n,t,r)&&(t=F),e(n,je(t,3));
},On.find=Po,On.findIndex=Ze,On.findKey=function(n,t){return v(n,je(t,3),Et)},On.findLast=Zo,On.findLastIndex=qe,On.findLastKey=function(n,t){return v(n,je(t,3),Ot)},On.floor=ec,On.forEach=ru,On.forEachRight=eu,On.forIn=function(n,t){return null==n?n:co(n,je(t,3),Uu)},On.forInRight=function(n,t){return null==n?n:ao(n,je(t,3),Uu)},On.forOwn=function(n,t){return n&&Et(n,je(t,3))},On.forOwnRight=function(n,t){return n&&Ot(n,je(t,3))},On.get=Wu,On.gt=of,On.gte=ff,On.has=function(n,t){return null!=n&&ke(n,t,Bt);
},On.hasIn=Bu,On.head=Ke,On.identity=Nu,On.includes=function(n,t,r,e){return n=pu(n)?n:Du(n),r=r&&!e?Ou(r):0,e=n.length,0>r&&(r=Di(e+r,0)),mu(n)?r<=e&&-1<n.indexOf(t,r):!!e&&-1<d(n,t,r)},On.indexOf=function(n,t,r){var e=null==n?0:n.length;return e?(r=null==r?0:Ou(r),0>r&&(r=Di(e+r,0)),d(n,t,r)):-1},On.inRange=function(n,t,r){return t=Eu(t),r===F?(r=t,t=0):r=Eu(r),n=Iu(n),n>=Mi(t,r)&&n<Di(t,r)},On.invoke=Sf,On.isArguments=cf,On.isArray=af,On.isArrayBuffer=lf,On.isArrayLike=pu,On.isArrayLikeObject=_u,
On.isBoolean=function(n){return true===n||false===n||xu(n)&&"[object Boolean]"==zt(n)},On.isBuffer=sf,On.isDate=hf,On.isElement=function(n){return xu(n)&&1===n.nodeType&&!wu(n)},On.isEmpty=function(n){if(null==n)return true;if(pu(n)&&(af(n)||typeof n=="string"||typeof n.splice=="function"||sf(n)||gf(n)||cf(n)))return!n.length;var t=yo(n);if("[object Map]"==t||"[object Set]"==t)return!n.size;if(Le(n))return!Ht(n).length;for(var r in n)if(ci.call(n,r))return false;return true},On.isEqual=function(n,t){return Ft(n,t);
},On.isEqualWith=function(n,t,r){var e=(r=typeof r=="function"?r:F)?r(n,t):F;return e===F?Ft(n,t,F,r):!!e},On.isError=vu,On.isFinite=function(n){return typeof n=="number"&&Li(n)},On.isFunction=gu,On.isInteger=du,On.isLength=yu,On.isMap=pf,On.isMatch=function(n,t){return n===t||Pt(n,t,me(t))},On.isMatchWith=function(n,t,r){return r=typeof r=="function"?r:F,Pt(n,t,me(t),r)},On.isNaN=function(n){return ju(n)&&n!=+n},On.isNative=function(n){if(bo(n))throw new Yu("Unsupported core-js use. Try https://npms.io/search?q=ponyfill.");
return Zt(n)},On.isNil=function(n){return null==n},On.isNull=function(n){return null===n},On.isNumber=ju,On.isObject=bu,On.isObjectLike=xu,On.isPlainObject=wu,On.isRegExp=_f,On.isSafeInteger=function(n){return du(n)&&-9007199254740991<=n&&9007199254740991>=n},On.isSet=vf,On.isString=mu,On.isSymbol=Au,On.isTypedArray=gf,On.isUndefined=function(n){return n===F},On.isWeakMap=function(n){return xu(n)&&"[object WeakMap]"==yo(n)},On.isWeakSet=function(n){return xu(n)&&"[object WeakSet]"==zt(n)},On.join=function(n,t){
return null==n?"":Ui.call(n,t)},On.kebabCase=Cf,On.last=Ge,On.lastIndexOf=function(n,t,r){var e=null==n?0:n.length;if(!e)return-1;var u=e;if(r!==F&&(u=Ou(r),u=0>u?Di(e+u,0):Mi(u,e-1)),t===t){for(r=u+1;r--&&n[r]!==t;);n=r}else n=g(n,b,u,true);return n},On.lowerCase=Df,On.lowerFirst=Mf,On.lt=df,On.lte=yf,On.max=function(n){return n&&n.length?mt(n,Nu,Wt):F},On.maxBy=function(n,t){return n&&n.length?mt(n,je(t,2),Wt):F},On.mean=function(n){return x(n,Nu)},On.meanBy=function(n,t){return x(n,je(t,2))},On.min=function(n){
return n&&n.length?mt(n,Nu,Jt):F},On.minBy=function(n,t){return n&&n.length?mt(n,je(t,2),Jt):F},On.stubArray=Ku,On.stubFalse=Gu,On.stubObject=function(){return{}},On.stubString=function(){return""},On.stubTrue=function(){return true},On.multiply=uc,On.nth=function(n,t){return n&&n.length?tr(n,Ou(t)):F},On.noConflict=function(){return Zn._===this&&(Zn._=pi),this},On.noop=qu,On.now=Jo,On.pad=function(n,t,r){n=zu(n);var e=(t=Ou(t))?T(n):0;return!t||e>=t?n:(t=(t-e)/2,ee(zi(t),r)+n+ee(Ri(t),r))},On.padEnd=function(n,t,r){
n=zu(n);var e=(t=Ou(t))?T(n):0;return t&&e<t?n+ee(t-e,r):n},On.padStart=function(n,t,r){n=zu(n);var e=(t=Ou(t))?T(n):0;return t&&e<t?ee(t-e,r)+n:n},On.parseInt=function(n,t,r){return r||null==t?t=0:t&&(t=+t),$i(zu(n).replace(an,""),t||0)},On.random=function(n,t,r){if(r&&typeof r!="boolean"&&ze(n,t,r)&&(t=r=F),r===F&&(typeof t=="boolean"?(r=t,t=F):typeof n=="boolean"&&(r=n,n=F)),n===F&&t===F?(n=0,t=1):(n=Eu(n),t===F?(t=n,n=0):t=Eu(t)),n>t){var e=n;n=t,t=e}return r||n%1||t%1?(r=Fi(),Mi(n+r*(t-n+$n("1e-"+((r+"").length-1))),t)):cr(n,t);
},On.reduce=function(n,t,r){var e=af(n)?h:m,u=3>arguments.length;return e(n,je(t,4),r,u,oo)},On.reduceRight=function(n,t,r){var e=af(n)?p:m,u=3>arguments.length;return e(n,je(t,4),r,u,fo)},On.repeat=function(n,t,r){return t=(r?ze(n,t,r):t===F)?1:Ou(t),ar(zu(n),t)},On.replace=function(){var n=arguments,t=zu(n[0]);return 3>n.length?t:t.replace(n[1],n[2])},On.result=function(n,t,r){t=Rr(t,n);var e=-1,u=t.length;for(u||(u=1,n=F);++e<u;){var i=null==n?F:n[$e(t[e])];i===F&&(e=u,i=r),n=gu(i)?i.call(n):i;
}return n},On.round=ic,On.runInContext=w,On.sample=function(n){return(af(n)?tt:sr)(n)},On.size=function(n){if(null==n)return 0;if(pu(n))return mu(n)?T(n):n.length;var t=yo(n);return"[object Map]"==t||"[object Set]"==t?n.size:Ht(n).length},On.snakeCase=Tf,On.some=function(n,t,r){var e=af(n)?_:gr;return r&&ze(n,t,r)&&(t=F),e(n,je(t,3))},On.sortedIndex=function(n,t){return dr(n,t)},On.sortedIndexBy=function(n,t,r){return yr(n,t,je(r,2))},On.sortedIndexOf=function(n,t){var r=null==n?0:n.length;if(r){
var e=dr(n,t);if(e<r&&hu(n[e],t))return e}return-1},On.sortedLastIndex=function(n,t){return dr(n,t,true)},On.sortedLastIndexBy=function(n,t,r){return yr(n,t,je(r,2),true)},On.sortedLastIndexOf=function(n,t){if(null==n?0:n.length){var r=dr(n,t,true)-1;if(hu(n[r],t))return r}return-1},On.startCase=$f,On.startsWith=function(n,t,r){return n=zu(n),r=null==r?0:gt(Ou(r),0,n.length),t=jr(t),n.slice(r,r+t.length)==t},On.subtract=oc,On.sum=function(n){return n&&n.length?k(n,Nu):0},On.sumBy=function(n,t){return n&&n.length?k(n,je(t,2)):0;
},On.template=function(n,t,r){var e=On.templateSettings;r&&ze(n,t,r)&&(t=F),n=zu(n),t=jf({},t,e,se),r=jf({},t.imports,e.imports,se);var u,i,o=Lu(r),f=I(r,o),c=0;r=t.interpolate||An;var a="__p+='";r=ti((t.escape||An).source+"|"+r.source+"|"+(r===nn?gn:An).source+"|"+(t.evaluate||An).source+"|$","g");var l="sourceURL"in t?"//# sourceURL="+t.sourceURL+"\n":"";if(n.replace(r,function(t,r,e,o,f,l){return e||(e=o),a+=n.slice(c,l).replace(kn,B),r&&(u=true,a+="'+__e("+r+")+'"),f&&(i=true,a+="';"+f+";\n__p+='"),
e&&(a+="'+((__t=("+e+"))==null?'':__t)+'"),c=l+t.length,t}),a+="';",(t=t.variable)||(a="with(obj){"+a+"}"),a=(i?a.replace(q,""):a).replace(V,"$1").replace(K,"$1;"),a="function("+(t||"obj")+"){"+(t?"":"obj||(obj={});")+"var __t,__p=''"+(u?",__e=_.escape":"")+(i?",__j=Array.prototype.join;function print(){__p+=__j.call(arguments,'')}":";")+a+"return __p}",t=Pf(function(){return Qu(o,l+"return "+a).apply(F,f)}),t.source=a,vu(t))throw t;return t},On.times=function(n,t){if(n=Ou(n),1>n||9007199254740991<n)return[];
var r=4294967295,e=Mi(n,4294967295);for(t=je(t),n-=4294967295,e=E(e,t);++r<n;)t(r);return e},On.toFinite=Eu,On.toInteger=Ou,On.toLength=Su,On.toLower=function(n){return zu(n).toLowerCase()},On.toNumber=Iu,On.toSafeInteger=function(n){return n?gt(Ou(n),-9007199254740991,9007199254740991):0===n?n:0},On.toString=zu,On.toUpper=function(n){return zu(n).toUpperCase()},On.trim=function(n,t,r){return(n=zu(n))&&(r||t===F)?n.replace(cn,""):n&&(t=jr(t))?(n=$(n),r=$(t),t=z(n,r),r=W(n,r)+1,zr(n,t,r).join("")):n;
},On.trimEnd=function(n,t,r){return(n=zu(n))&&(r||t===F)?n.replace(ln,""):n&&(t=jr(t))?(n=$(n),t=W(n,$(t))+1,zr(n,0,t).join("")):n},On.trimStart=function(n,t,r){return(n=zu(n))&&(r||t===F)?n.replace(an,""):n&&(t=jr(t))?(n=$(n),t=z(n,$(t)),zr(n,t).join("")):n},On.truncate=function(n,t){var r=30,e="...";if(bu(t))var u="separator"in t?t.separator:u,r="length"in t?Ou(t.length):r,e="omission"in t?jr(t.omission):e;n=zu(n);var i=n.length;if(Bn.test(n))var o=$(n),i=o.length;if(r>=i)return n;if(i=r-T(e),1>i)return e;
if(r=o?zr(o,0,i).join(""):n.slice(0,i),u===F)return r+e;if(o&&(i+=r.length-i),_f(u)){if(n.slice(i).search(u)){var f=r;for(u.global||(u=ti(u.source,zu(dn.exec(u))+"g")),u.lastIndex=0;o=u.exec(f);)var c=o.index;r=r.slice(0,c===F?i:c)}}else n.indexOf(jr(u),i)!=i&&(u=r.lastIndexOf(u),-1<u&&(r=r.slice(0,u)));return r+e},On.unescape=function(n){return(n=zu(n))&&J.test(n)?n.replace(G,ut):n},On.uniqueId=function(n){var t=++ai;return zu(n)+t},On.upperCase=Ff,On.upperFirst=Nf,On.each=ru,On.eachRight=eu,On.first=Ke,
Zu(On,function(){var n={};return Et(On,function(t,r){ci.call(On.prototype,r)||(n[r]=t)}),n}(),{chain:false}),On.VERSION="4.17.4",u("bind bindKey curry curryRight partial partialRight".split(" "),function(n){On[n].placeholder=On}),u(["drop","take"],function(n,t){Mn.prototype[n]=function(r){r=r===F?1:Di(Ou(r),0);var e=this.__filtered__&&!t?new Mn(this):this.clone();return e.__filtered__?e.__takeCount__=Mi(r,e.__takeCount__):e.__views__.push({size:Mi(r,4294967295),type:n+(0>e.__dir__?"Right":"")}),e},Mn.prototype[n+"Right"]=function(t){
return this.reverse()[n](t).reverse()}}),u(["filter","map","takeWhile"],function(n,t){var r=t+1,e=1==r||3==r;Mn.prototype[n]=function(n){var t=this.clone();return t.__iteratees__.push({iteratee:je(n,3),type:r}),t.__filtered__=t.__filtered__||e,t}}),u(["head","last"],function(n,t){var r="take"+(t?"Right":"");Mn.prototype[n]=function(){return this[r](1).value()[0]}}),u(["initial","tail"],function(n,t){var r="drop"+(t?"":"Right");Mn.prototype[n]=function(){return this.__filtered__?new Mn(this):this[r](1);
}}),Mn.prototype.compact=function(){return this.filter(Nu)},Mn.prototype.find=function(n){return this.filter(n).head()},Mn.prototype.findLast=function(n){return this.reverse().find(n)},Mn.prototype.invokeMap=lr(function(n,t){return typeof n=="function"?new Mn(this):this.map(function(r){return Dt(r,n,t)})}),Mn.prototype.reject=function(n){return this.filter(su(je(n)))},Mn.prototype.slice=function(n,t){n=Ou(n);var r=this;return r.__filtered__&&(0<n||0>t)?new Mn(r):(0>n?r=r.takeRight(-n):n&&(r=r.drop(n)),
t!==F&&(t=Ou(t),r=0>t?r.dropRight(-t):r.take(t-n)),r)},Mn.prototype.takeRightWhile=function(n){return this.reverse().takeWhile(n).reverse()},Mn.prototype.toArray=function(){return this.take(4294967295)},Et(Mn.prototype,function(n,t){var r=/^(?:filter|find|map|reject)|While$/.test(t),e=/^(?:head|last)$/.test(t),u=On[e?"take"+("last"==t?"Right":""):t],i=e||/^find/.test(t);u&&(On.prototype[t]=function(){function t(n){return n=u.apply(On,s([n],f)),e&&h?n[0]:n}var o=this.__wrapped__,f=e?[1]:arguments,c=o instanceof Mn,a=f[0],l=c||af(o);
l&&r&&typeof a=="function"&&1!=a.length&&(c=l=false);var h=this.__chain__,p=!!this.__actions__.length,a=i&&!h,c=c&&!p;return!i&&l?(o=c?o:new Mn(this),o=n.apply(o,f),o.__actions__.push({func:nu,args:[t],thisArg:F}),new zn(o,h)):a&&c?n.apply(this,f):(o=this.thru(t),a?e?o.value()[0]:o.value():o)})}),u("pop push shift sort splice unshift".split(" "),function(n){var t=ui[n],r=/^(?:push|sort|unshift)$/.test(n)?"tap":"thru",e=/^(?:pop|shift)$/.test(n);On.prototype[n]=function(){var n=arguments;if(e&&!this.__chain__){
var u=this.value();return t.apply(af(u)?u:[],n)}return this[r](function(r){return t.apply(af(r)?r:[],n)})}}),Et(Mn.prototype,function(n,t){var r=On[t];if(r){var e=r.name+"";(Ji[e]||(Ji[e]=[])).push({name:t,func:r})}}),Ji[Xr(F,2).name]=[{name:"wrapper",func:F}],Mn.prototype.clone=function(){var n=new Mn(this.__wrapped__);return n.__actions__=Mr(this.__actions__),n.__dir__=this.__dir__,n.__filtered__=this.__filtered__,n.__iteratees__=Mr(this.__iteratees__),n.__takeCount__=this.__takeCount__,n.__views__=Mr(this.__views__),
n},Mn.prototype.reverse=function(){if(this.__filtered__){var n=new Mn(this);n.__dir__=-1,n.__filtered__=true}else n=this.clone(),n.__dir__*=-1;return n},Mn.prototype.value=function(){var n,t=this.__wrapped__.value(),r=this.__dir__,e=af(t),u=0>r,i=e?t.length:0;n=i;for(var o=this.__views__,f=0,c=-1,a=o.length;++c<a;){var l=o[c],s=l.size;switch(l.type){case"drop":f+=s;break;case"dropRight":n-=s;break;case"take":n=Mi(n,f+s);break;case"takeRight":f=Di(f,n-s)}}if(n={start:f,end:n},o=n.start,f=n.end,n=f-o,
o=u?f:o-1,f=this.__iteratees__,c=f.length,a=0,l=Mi(n,this.__takeCount__),!e||!u&&i==n&&l==n)return kr(t,this.__actions__);e=[];n:for(;n--&&a<l;){for(o+=r,u=-1,i=t[o];++u<c;){var h=f[u],s=h.type,h=(0,h.iteratee)(i);if(2==s)i=h;else if(!h){if(1==s)continue n;break n}}e[a++]=i}return e},On.prototype.at=Fo,On.prototype.chain=function(){return Xe(this)},On.prototype.commit=function(){return new zn(this.value(),this.__chain__)},On.prototype.next=function(){this.__values__===F&&(this.__values__=ku(this.value()));
var n=this.__index__>=this.__values__.length;return{done:n,value:n?F:this.__values__[this.__index__++]}},On.prototype.plant=function(n){for(var t,r=this;r instanceof Sn;){var e=Pe(r);e.__index__=0,e.__values__=F,t?u.__wrapped__=e:t=e;var u=e,r=r.__wrapped__}return u.__wrapped__=n,t},On.prototype.reverse=function(){var n=this.__wrapped__;return n instanceof Mn?(this.__actions__.length&&(n=new Mn(this)),n=n.reverse(),n.__actions__.push({func:nu,args:[Je],thisArg:F}),new zn(n,this.__chain__)):this.thru(Je);
},On.prototype.toJSON=On.prototype.valueOf=On.prototype.value=function(){return kr(this.__wrapped__,this.__actions__)},On.prototype.first=On.prototype.head,Ai&&(On.prototype[Ai]=tu),On}();typeof define=="function"&&typeof define.amd=="object"&&define.amd?(Zn._=it, define(function(){return it})):Vn?((Vn.exports=it)._=it,qn._=it):Zn._=it}).call(this);

/*************************
 * Croppie
 * Copyright 2016
 * Foliotek
 * Version: 2.4.0
 *************************/
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports'], factory);
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports);
    } else {
        // Browser globals
        factory((root.commonJsStrict = {}));
    }
}(this, function (exports) {

    /* Polyfills */
    if (typeof Promise !== 'function') {
        /*! promise-polyfill 3.1.0 */
        !function(a){function b(a,b){return function(){a.apply(b,arguments)}}function c(a){if("object"!=typeof this)throw new TypeError("Promises must be constructed via new");if("function"!=typeof a)throw new TypeError("not a function");this._state=null,this._value=null,this._deferreds=[],i(a,b(e,this),b(f,this))}function d(a){var b=this;return null===this._state?void this._deferreds.push(a):void k(function(){var c=b._state?a.onFulfilled:a.onRejected;if(null===c)return void(b._state?a.resolve:a.reject)(b._value);var d;try{d=c(b._value)}catch(e){return void a.reject(e)}a.resolve(d)})}function e(a){try{if(a===this)throw new TypeError("A promise cannot be resolved with itself.");if(a&&("object"==typeof a||"function"==typeof a)){var c=a.then;if("function"==typeof c)return void i(b(c,a),b(e,this),b(f,this))}this._state=!0,this._value=a,g.call(this)}catch(d){f.call(this,d)}}function f(a){this._state=!1,this._value=a,g.call(this)}function g(){for(var a=0,b=this._deferreds.length;b>a;a++)d.call(this,this._deferreds[a]);this._deferreds=null}function h(a,b,c,d){this.onFulfilled="function"==typeof a?a:null,this.onRejected="function"==typeof b?b:null,this.resolve=c,this.reject=d}function i(a,b,c){var d=!1;try{a(function(a){d||(d=!0,b(a))},function(a){d||(d=!0,c(a))})}catch(e){if(d)return;d=!0,c(e)}}var j=setTimeout,k="function"==typeof setImmediate&&setImmediate||function(a){j(a,1)},l=Array.isArray||function(a){return"[object Array]"===Object.prototype.toString.call(a)};c.prototype["catch"]=function(a){return this.then(null,a)},c.prototype.then=function(a,b){var e=this;return new c(function(c,f){d.call(e,new h(a,b,c,f))})},c.all=function(){var a=Array.prototype.slice.call(1===arguments.length&&l(arguments[0])?arguments[0]:arguments);return new c(function(b,c){function d(f,g){try{if(g&&("object"==typeof g||"function"==typeof g)){var h=g.then;if("function"==typeof h)return void h.call(g,function(a){d(f,a)},c)}a[f]=g,0===--e&&b(a)}catch(i){c(i)}}if(0===a.length)return b([]);for(var e=a.length,f=0;f<a.length;f++)d(f,a[f])})},c.resolve=function(a){return a&&"object"==typeof a&&a.constructor===c?a:new c(function(b){b(a)})},c.reject=function(a){return new c(function(b,c){c(a)})},c.race=function(a){return new c(function(b,c){for(var d=0,e=a.length;e>d;d++)a[d].then(b,c)})},c._setImmediateFn=function(a){k=a},"undefined"!=typeof module&&module.exports?module.exports=c:a.Promise||(a.Promise=c)}(this);
    }

    if ( typeof window.CustomEvent !== "function" ) {
        (function(){
            function CustomEvent ( event, params ) {
                params = params || { bubbles: false, cancelable: false, detail: undefined };
                var evt = document.createEvent( 'CustomEvent' );
                evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
                return evt;
            }
            CustomEvent.prototype = window.Event.prototype;
            window.CustomEvent = CustomEvent;
        }());
    }

    if (!HTMLCanvasElement.prototype.toBlob) {
        Object.defineProperty(HTMLCanvasElement.prototype, 'toBlob', {
            value: function (callback, type, quality) {
                var binStr = atob( this.toDataURL(type, quality).split(',')[1] ),
                len = binStr.length,
                arr = new Uint8Array(len);

                for (var i=0; i<len; i++ ) {
                    arr[i] = binStr.charCodeAt(i);
                }

                callback( new Blob( [arr], {type: type || 'image/png'} ) );
            }
        });
    }
    /* End Polyfills */

    var cssPrefixes = ['Webkit', 'Moz', 'ms'],
        emptyStyles = document.createElement('div').style,
        CSS_TRANS_ORG,
        CSS_TRANSFORM,
        CSS_USERSELECT;

    function vendorPrefix(prop) {
        if (prop in emptyStyles) {
            return prop;
        }

        var capProp = prop[0].toUpperCase() + prop.slice(1),
            i = cssPrefixes.length;

        while (i--) {
            prop = cssPrefixes[i] + capProp;
            if (prop in emptyStyles) {
                return prop;
            }
        }
    }

    CSS_TRANSFORM = vendorPrefix('transform');
    CSS_TRANS_ORG = vendorPrefix('transformOrigin');
    CSS_USERSELECT = vendorPrefix('userSelect');

    // Credits to : Andrew Dupont - http://andrewdupont.net/2009/08/28/deep-extending-objects-in-javascript/
    function deepExtend(destination, source) {
        destination = destination || {};
        for (var property in source) {
            if (source[property] && source[property].constructor && source[property].constructor === Object) {
                destination[property] = destination[property] || {};
                deepExtend(destination[property], source[property]);
            } else {
                destination[property] = source[property];
            }
        }
        return destination;
    }

    function debounce(func, wait, immediate) {
        var timeout;
        return function () {
            var context = this, args = arguments;
            var later = function () {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            var callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    }

    function dispatchChange(element) {
        if ("createEvent" in document) {
            var evt = document.createEvent("HTMLEvents");
            evt.initEvent("change", false, true);
            element.dispatchEvent(evt);
        }
        else {
            element.fireEvent("onchange");
        }
    }

    //http://jsperf.com/vanilla-css
    function css(el, styles, val) {
        if (typeof (styles) === 'string') {
            var tmp = styles;
            styles = {};
            styles[tmp] = val;
        }

        for (var prop in styles) {
            el.style[prop] = styles[prop];
        }
    }

    function addClass(el, c) {
        if (el.classList) {
            el.classList.add(c);
        }
        else {
            el.className += ' ' + c;
        }
    }

    function removeClass(el, c) {
        if (el.classList) {
            el.classList.remove(c);
        }
        else {
            el.className = el.className.replace(c, '');
        }
    }

    function num(v) {
        return parseInt(v, 10);
    }

    /* Utilities */
    function loadImage(src, imageEl, useCanvas) {
        var img = imageEl || new Image(),
            prom;

        if (img.src === src) {
            // If image source hasn't changed, return a promise that resolves immediately
            prom = new Promise(function (resolve, reject) {
                resolve(img);
            });
        } else {
            prom = new Promise(function (resolve, reject) {
                if (useCanvas && src.substring(0,4).toLowerCase() === 'http') {
                    img.setAttribute('crossOrigin', 'anonymous');
                }
                img.onload = function () {
                    setTimeout(function () {
                        resolve(img);
                    }, 1);
                };
            });

            img.src = src;
        }

        img.style.opacity = 0;

        return prom;
    }

    /* CSS Transform Prototype */
    var _TRANSLATE = 'translate3d',
        _TRANSLATE_SUFFIX = ', 0px';
    var Transform = function (x, y, scale) {
        this.x = parseFloat(x);
        this.y = parseFloat(y);
        this.scale = parseFloat(scale);
    };

    Transform.parse = function (v) {
        if (v.style) {
            return Transform.parse(v.style[CSS_TRANSFORM]);
        }
        else if (v.indexOf('matrix') > -1 || v.indexOf('none') > -1) {
            return Transform.fromMatrix(v);
        }
        else {
            return Transform.fromString(v);
        }
    };

    Transform.fromMatrix = function (v) {
        var vals = v.substring(7).split(',');
        if (!vals.length || v === 'none') {
            vals = [1, 0, 0, 1, 0, 0];
        }

        return new Transform(num(vals[4]), num(vals[5]), parseFloat(vals[0]));
    };

    Transform.fromString = function (v) {
        var values = v.split(') '),
            translate = values[0].substring(_TRANSLATE.length + 1).split(','),
            scale = values.length > 1 ? values[1].substring(6) : 1,
            x = translate.length > 1 ? translate[0] : 0,
            y = translate.length > 1 ? translate[1] : 0;

        return new Transform(x, y, scale);
    };

    Transform.prototype.toString = function () {
        return _TRANSLATE + '(' + this.x + 'px, ' + this.y + 'px' + _TRANSLATE_SUFFIX + ') scale(' + this.scale + ')';
    };

    var TransformOrigin = function (el) {
        if (!el || !el.style[CSS_TRANS_ORG]) {
            this.x = 0;
            this.y = 0;
            return;
        }
        var css = el.style[CSS_TRANS_ORG].split(' ');
        this.x = parseFloat(css[0]);
        this.y = parseFloat(css[1]);
    };

    TransformOrigin.prototype.toString = function () {
        return this.x + 'px ' + this.y + 'px';
    };

    function getExifOrientation (img, cb) {
        if (!window.EXIF) {
            cb(0);
        }

        EXIF.getData(img, function () {
            var orientation = EXIF.getTag(this, 'Orientation');
            cb(orientation);
        });
    }

    function drawCanvas(canvas, img, orientation) {
        var width = img.width,
            height = img.height,
            ctx = canvas.getContext('2d');

        canvas.width = img.width;
        canvas.height = img.height;

        ctx.save();
        switch (orientation) {
          case 2:
             ctx.translate(width, 0);
             ctx.scale(-1, 1);
             break;

          case 3:
              ctx.translate(width, height);
              ctx.rotate(180*Math.PI/180);
              break;

          case 4:
              ctx.translate(0, height);
              ctx.scale(1, -1);
              break;

          case 5:
              canvas.width = height;
              canvas.height = width;
              ctx.rotate(90*Math.PI/180);
              ctx.scale(1, -1);
              break;

          case 6:
              canvas.width = height;
              canvas.height = width;
              ctx.rotate(90*Math.PI/180);
              ctx.translate(0, -height);
              break;

          case 7:
              canvas.width = height;
              canvas.height = width;
              ctx.rotate(-90*Math.PI/180);
              ctx.translate(-width, height);
              ctx.scale(1, -1);
              break;

          case 8:
              canvas.width = height;
              canvas.height = width;
              ctx.translate(0, width);
              ctx.rotate(-90*Math.PI/180);
              break;
        }
        ctx.drawImage(img, 0,0, width, height);
        ctx.restore();
    }

    /* Private Methods */
    function _create() {
        var self = this,
            contClass = 'croppie-container',
            customViewportClass = self.options.viewport.type ? 'cr-vp-' + self.options.viewport.type : null,
            boundary, img, viewport, overlay, canvas, bw, bh;

        self.options.useCanvas = self.options.enableOrientation || _hasExif.call(self);
        // Properties on class
        self.data = {};
        self.elements = {};

        // Generating Markup
        boundary = self.elements.boundary = document.createElement('div');
        viewport = self.elements.viewport = document.createElement('div');
        img = self.elements.img = document.createElement('img');
        overlay = self.elements.overlay = document.createElement('div');

        if (self.options.useCanvas) {
            self.elements.canvas = document.createElement('canvas');
            self.elements.preview = self.elements.canvas;
        }
        else {
            self.elements.preview = self.elements.img;
        }

        addClass(boundary, 'cr-boundary');
        bw = self.options.boundary.width;
        bh = self.options.boundary.height;
        css(boundary, {
            width: (bw + (isNaN(bw) ? '' : 'px')),
            height: (bh + (isNaN(bh) ? '' : 'px'))
        });

        addClass(viewport, 'cr-viewport');
        if (customViewportClass) {
            addClass(viewport, customViewportClass);
        }
        css(viewport, {
            width: self.options.viewport.width + 'px',
            height: self.options.viewport.height + 'px'
        });
        viewport.setAttribute('tabindex', 0);

        addClass(self.elements.preview, 'cr-image');
        addClass(overlay, 'cr-overlay');

        self.element.appendChild(boundary);
        boundary.appendChild(self.elements.preview);
        boundary.appendChild(viewport);
        boundary.appendChild(overlay);

        addClass(self.element, contClass);
        if (self.options.customClass) {
            addClass(self.element, self.options.customClass);
        }

        // Initialize drag & zoom
        _initDraggable.call(this);

        if (self.options.enableZoom) {
            _initializeZoom.call(self);
        }

        // if (self.options.enableOrientation) {
        //     _initRotationControls.call(self);
        // }
    }

    function _initRotationControls () {
        // TODO - Not a fan of these controls
        return;
        var self = this,
            wrap, btnLeft, btnRight, iLeft, iRight;

        wrap = document.createElement('div');
        self.elements.orientationBtnLeft = btnLeft = document.createElement('button');
        self.elements.orientationBtnRight = btnRight = document.createElement('button');

        wrap.appendChild(btnLeft);
        wrap.appendChild(btnRight);

        iLeft = document.createElement('i');
        iRight = document.createElement('i');
        btnLeft.appendChild(iLeft);
        btnRight.appendChild(iRight);

        addClass(wrap, 'cr-rotate-controls');
        addClass(btnLeft, 'cr-rotate-l');
        addClass(btnRight, 'cr-rotate-r');

        self.elements.boundary.appendChild(wrap);

        btnLeft.addEventListener('click', function () {
            self.rotate(-90);
        });
        btnRight.addEventListener('click', function () {
            self.rotate(90);
        });
    }

    function _hasExif() {
        // todo - remove options.exif after deprecation
        return this.options.enableExif && window.EXIF;
    }

    function _setZoomerVal(v) {
        if (this.options.enableZoom) {
            var z = this.elements.zoomer,
                val = fix(v, 4);

            z.value = Math.max(z.min, Math.min(z.max, val));
        }
    }

    function _initializeZoom() {
        var self = this,
            wrap = self.elements.zoomerWrap = document.createElement('div'),
            zoomer = self.elements.zoomer = document.createElement('input');

        addClass(wrap, 'cr-slider-wrap');
        addClass(zoomer, 'cr-slider');
        zoomer.type = 'range';
        zoomer.step = '0.0001';
        zoomer.value = 1;
        zoomer.style.display = self.options.showZoomer ? '' : 'none';

        self.element.appendChild(wrap);
        wrap.appendChild(zoomer);

        self._currentZoom = 1;

        function change() {
            _onZoom.call(self, {
                value: parseFloat(zoomer.value),
                origin: new TransformOrigin(self.elements.preview),
                viewportRect: self.elements.viewport.getBoundingClientRect(),
                transform: Transform.parse(self.elements.preview)
            });
        }

        function scroll(ev) {
            var delta, targetZoom;

            if (ev.wheelDelta) {
                delta = ev.wheelDelta / 1200; //wheelDelta min: -120 max: 120 // max x 10 x 2
            } else if (ev.deltaY) {
                delta = ev.deltaY / 1060; //deltaY min: -53 max: 53 // max x 10 x 2
            } else if (ev.detail) {
                delta = ev.detail / -60; //delta min: -3 max: 3 // max x 10 x 2
            } else {
                delta = 0;
            }

            targetZoom = self._currentZoom + (delta * self._currentZoom);

            ev.preventDefault();
            _setZoomerVal.call(self, targetZoom);
            change.call(self);
        }

        self.elements.zoomer.addEventListener('input', change);// this is being fired twice on keypress
        self.elements.zoomer.addEventListener('change', change);

        if (self.options.mouseWheelZoom) {
            self.elements.boundary.addEventListener('mousewheel', scroll);
            self.elements.boundary.addEventListener('DOMMouseScroll', scroll);
        }
    }

    function _onZoom(ui) {
        var self = this,
            transform = ui ? ui.transform : Transform.parse(self.elements.preview),
            vpRect = ui ? ui.viewportRect : self.elements.viewport.getBoundingClientRect(),
            origin = ui ? ui.origin : new TransformOrigin(self.elements.preview),
            transCss = {};

        function applyCss() {
            var transCss = {};
            transCss[CSS_TRANSFORM] = transform.toString();
            transCss[CSS_TRANS_ORG] = origin.toString();
            css(self.elements.preview, transCss);
        }

        self._currentZoom = ui ? ui.value : self._currentZoom;
        transform.scale = self._currentZoom;
        applyCss();


        if (self.options.enforceBoundary) {
            var boundaries = _getVirtualBoundaries.call(self, vpRect),
                transBoundaries = boundaries.translate,
                oBoundaries = boundaries.origin;

            if (transform.x >= transBoundaries.maxX) {
                origin.x = oBoundaries.minX;
                transform.x = transBoundaries.maxX;
            }

            if (transform.x <= transBoundaries.minX) {
                origin.x = oBoundaries.maxX;
                transform.x = transBoundaries.minX;
            }

            if (transform.y >= transBoundaries.maxY) {
                origin.y = oBoundaries.minY;
                transform.y = transBoundaries.maxY;
            }

            if (transform.y <= transBoundaries.minY) {
                origin.y = oBoundaries.maxY;
                transform.y = transBoundaries.minY;
            }
        }
        applyCss();
        _debouncedOverlay.call(self);
        _triggerUpdate.call(self);
    }

    function _getVirtualBoundaries(viewport) {
        var self = this,
            scale = self._currentZoom,
            vpWidth = viewport.width,
            vpHeight = viewport.height,
            centerFromBoundaryX = self.elements.boundary.clientWidth / 2,
            centerFromBoundaryY = self.elements.boundary.clientHeight / 2,
            imgRect = self.elements.preview.getBoundingClientRect(),
            curImgWidth = imgRect.width,
            curImgHeight = imgRect.height,
            halfWidth = vpWidth / 2,
            halfHeight = vpHeight / 2;

        var maxX = ((halfWidth / scale) - centerFromBoundaryX) * -1;
        var minX = maxX - ((curImgWidth * (1 / scale)) - (vpWidth * (1 / scale)));

        var maxY = ((halfHeight / scale) - centerFromBoundaryY) * -1;
        var minY = maxY - ((curImgHeight * (1 / scale)) - (vpHeight * (1 / scale)));

        var originMinX = (1 / scale) * halfWidth;
        var originMaxX = (curImgWidth * (1 / scale)) - originMinX;

        var originMinY = (1 / scale) * halfHeight;
        var originMaxY = (curImgHeight * (1 / scale)) - originMinY;

        return {
            translate: {
                maxX: maxX,
                minX: minX,
                maxY: maxY,
                minY: minY
            },
            origin: {
                maxX: originMaxX,
                minX: originMinX,
                maxY: originMaxY,
                minY: originMinY
            }
        };
    }

    function _updateCenterPoint() {
        var self = this,
            scale = self._currentZoom,
            data = self.elements.preview.getBoundingClientRect(),
            vpData = self.elements.viewport.getBoundingClientRect(),
            transform = Transform.parse(self.elements.preview.style[CSS_TRANSFORM]),
            pc = new TransformOrigin(self.elements.preview),
            top = (vpData.top - data.top) + (vpData.height / 2),
            left = (vpData.left - data.left) + (vpData.width / 2),
            center = {},
            adj = {};

        center.y = top / scale;
        center.x = left / scale;

        adj.y = (center.y - pc.y) * (1 - scale);
        adj.x = (center.x - pc.x) * (1 - scale);

        transform.x -= adj.x;
        transform.y -= adj.y;

        var newCss = {};
        newCss[CSS_TRANS_ORG] = center.x + 'px ' + center.y + 'px';
        newCss[CSS_TRANSFORM] = transform.toString();
        css(self.elements.preview, newCss);
    }

    function _initDraggable() {
        var self = this,
            isDragging = false,
            originalX,
            originalY,
            originalDistance,
            vpRect,
            transform;

        function assignTransformCoordinates(deltaX, deltaY) {
            var imgRect = self.elements.preview.getBoundingClientRect(),
                top = transform.y + deltaY,
                left = transform.x + deltaX;

            if (self.options.enforceBoundary) {
                if (vpRect.top > imgRect.top + deltaY && vpRect.bottom < imgRect.bottom + deltaY) {
                    transform.y = top;
                }

                if (vpRect.left > imgRect.left + deltaX && vpRect.right < imgRect.right + deltaX) {
                    transform.x = left;
                }
            }
            else {
                transform.y = top;
                transform.x = left;
            }
        }

        function keyDown(ev) {
            var LEFT_ARROW  = 37,
                UP_ARROW    = 38,
                RIGHT_ARROW = 39,
                DOWN_ARROW  = 40;

            if (ev.shiftKey && (ev.keyCode == UP_ARROW || ev.keyCode == DOWN_ARROW)) {
                var zoom = 0.0;
                if (ev.keyCode == UP_ARROW) {
                    zoom = parseFloat(self.elements.zoomer.value, 10) + parseFloat(self.elements.zoomer.step, 10)
                }
                else {
                    zoom = parseFloat(self.elements.zoomer.value, 10) - parseFloat(self.elements.zoomer.step, 10)
                }
                self.setZoom(zoom);
            }
            else if (ev.keyCode >= 37 && ev.keyCode <= 40) {
                ev.preventDefault();
                var movement = parseKeyDown(ev.keyCode);

                transform = Transform.parse(self.elements.preview);
                document.body.style[CSS_USERSELECT] = 'none';
                vpRect = self.elements.viewport.getBoundingClientRect();
                keyMove(movement);
            };

            function parseKeyDown(key) {
                switch (key) {
                    case LEFT_ARROW:
                        return [1, 0];
                    case UP_ARROW:
                        return [0, 1];
                    case RIGHT_ARROW:
                        return [-1, 0];
                    case DOWN_ARROW:
                        return [0, -1];
                };
            };
        }

        function keyMove(movement) {
            var deltaX = movement[0],
                deltaY = movement[1],
                newCss = {};

            assignTransformCoordinates(deltaX, deltaY);

            newCss[CSS_TRANSFORM] = transform.toString();
            css(self.elements.preview, newCss);
            _updateOverlay.call(self);
            document.body.style[CSS_USERSELECT] = '';
            _updateCenterPoint.call(self);
            _triggerUpdate.call(self);
            originalDistance = 0;
        }

        function mouseDown(ev) {
            ev.preventDefault();
            if (isDragging) return;
            isDragging = true;
            originalX = ev.pageX;
            originalY = ev.pageY;

            if (ev.touches) {
                var touches = ev.touches[0];
                originalX = touches.pageX;
                originalY = touches.pageY;
            }

            transform = Transform.parse(self.elements.preview);
            window.addEventListener('mousemove', mouseMove);
            window.addEventListener('touchmove', mouseMove);
            window.addEventListener('mouseup', mouseUp);
            window.addEventListener('touchend', mouseUp);
            document.body.style[CSS_USERSELECT] = 'none';
            vpRect = self.elements.viewport.getBoundingClientRect();
        }

        function mouseMove(ev) {
            ev.preventDefault();
            var pageX = ev.pageX,
                pageY = ev.pageY;

            if (ev.touches) {
                var touches = ev.touches[0];
                pageX = touches.pageX;
                pageY = touches.pageY;
            }

            var deltaX = pageX - originalX,
                deltaY = pageY - originalY,
                newCss = {};

            if (ev.type == 'touchmove') {
                if (ev.touches.length > 1) {
                    var touch1 = ev.touches[0];
                    var touch2 = ev.touches[1];
                    var dist = Math.sqrt((touch1.pageX - touch2.pageX) * (touch1.pageX - touch2.pageX) + (touch1.pageY - touch2.pageY) * (touch1.pageY - touch2.pageY));

                    if (!originalDistance) {
                        originalDistance = dist / self._currentZoom;
                    }

                    var scale = dist / originalDistance;

                    _setZoomerVal.call(self, scale);
                    dispatchChange(self.elements.zoomer);
                    return;
                }
            }

            assignTransformCoordinates(deltaX, deltaY);

            newCss[CSS_TRANSFORM] = transform.toString();
            css(self.elements.preview, newCss);
            _updateOverlay.call(self);
            originalY = pageY;
            originalX = pageX;
        }

        function mouseUp() {
            isDragging = false;
            window.removeEventListener('mousemove', mouseMove);
            window.removeEventListener('touchmove', mouseMove);
            window.removeEventListener('mouseup', mouseUp);
            window.removeEventListener('touchend', mouseUp);
            document.body.style[CSS_USERSELECT] = '';
            _updateCenterPoint.call(self);
            _triggerUpdate.call(self);
            originalDistance = 0;
        }

        self.elements.overlay.addEventListener('mousedown', mouseDown);
        self.elements.viewport.addEventListener('keydown', keyDown);
        self.elements.overlay.addEventListener('touchstart', mouseDown);
    }

    function _updateOverlay() {
        var self = this,
            boundRect = self.elements.boundary.getBoundingClientRect(),
            imgData = self.elements.preview.getBoundingClientRect();

        css(self.elements.overlay, {
            width: imgData.width + 'px',
            height: imgData.height + 'px',
            top: (imgData.top - boundRect.top) + 'px',
            left: (imgData.left - boundRect.left) + 'px'
        });
    }
    var _debouncedOverlay = debounce(_updateOverlay, 500);

    function _triggerUpdate() {
        var self = this,
            data = self.get(),
            ev; 

        if (!_isVisible.call(self)) {
            return;
        }

        self.options.update.call(self, data);
        if (self.$) {
            self.$(self.element).trigger('update', data)
        }
        else {
            var ev;
            if (window.CustomEvent) {
                try {
                ev = new CustomEvent('update', { detail: data });
                self.element.dispatchEvent(ev);
            }
            catch (err) {}
         
            } else {
                ev = document.createEvent('CustomEvent');
                ev.initCustomEvent('update', true, true, data);
                self.element.dispatchEvent(ev);
            }
        }
    }

    function _isVisible() {
        return this.elements.preview.offsetHeight > 0 && this.elements.preview.offsetWidth > 0;
    }

    function _updatePropertiesFromImage() {
        var self = this,
            minZoom = 0,
            maxZoom = 1.5,
            initialZoom = 1,
            cssReset = {},
            img = self.elements.preview,
            zoomer = self.elements.zoomer,
            transformReset = new Transform(0, 0, initialZoom),
            originReset = new TransformOrigin(),
            isVisible = _isVisible.call(self),
            imgData,
            vpData,
            boundaryData,
            minW,
            minH;

        if (!isVisible || self.data.bound) {
            // if the croppie isn't visible or it doesn't need binding
            return;
        }

        self.data.bound = true;
        cssReset[CSS_TRANSFORM] = transformReset.toString();
        cssReset[CSS_TRANS_ORG] = originReset.toString();
        cssReset['opacity'] = 1;
        css(img, cssReset);

        imgData = img.getBoundingClientRect();
        vpData = self.elements.viewport.getBoundingClientRect();
        boundaryData = self.elements.boundary.getBoundingClientRect();
        self._originalImageWidth = imgData.width;
        self._originalImageHeight = imgData.height;

        if (self.options.enableZoom) {
            if (self.options.enforceBoundary) {
                minW = vpData.width / imgData.width;
                minH = vpData.height / imgData.height;
                minZoom = Math.max(minW, minH);
            }

            if (minZoom >= maxZoom) {
                maxZoom = minZoom + 1;
            }

            zoomer.min = fix(minZoom, 4);
            zoomer.max = fix(maxZoom, 4);
            var defaultInitialZoom = Math.max((boundaryData.width / imgData.width), (boundaryData.height / imgData.height));
            initialZoom = self.data.boundZoom !== null ? self.data.boundZoom : defaultInitialZoom;
            _setZoomerVal.call(self, initialZoom);
            dispatchChange(zoomer);
        }
        else {
            self._currentZoom = initialZoom;
        }
        
        transformReset.scale = self._currentZoom;
        cssReset[CSS_TRANSFORM] = transformReset.toString();
        css(img, cssReset);

        if (self.data.points.length) {
            _bindPoints.call(self, self.data.points);
        }
        else {
            _centerImage.call(self);
        }

        _updateCenterPoint.call(self);
        _updateOverlay.call(self);
    }

    function _bindPoints(points) {
        if (points.length != 4) {
            throw "Croppie - Invalid number of points supplied: " + points;
        }
        var self = this,
            pointsWidth = points[2] - points[0],
            // pointsHeight = points[3] - points[1],
            vpData = self.elements.viewport.getBoundingClientRect(),
            boundRect = self.elements.boundary.getBoundingClientRect(),
            vpOffset = {
                left: vpData.left - boundRect.left,
                top: vpData.top - boundRect.top
            },
            scale = vpData.width / pointsWidth,
            originTop = points[1],
            originLeft = points[0],
            transformTop = (-1 * points[1]) + vpOffset.top,
            transformLeft = (-1 * points[0]) + vpOffset.left,
            newCss = {};

        newCss[CSS_TRANS_ORG] = originLeft + 'px ' + originTop + 'px';
        newCss[CSS_TRANSFORM] = new Transform(transformLeft, transformTop, scale).toString();
        css(self.elements.preview, newCss);

        _setZoomerVal.call(self, scale);
        self._currentZoom = scale;
    }

    function _centerImage() {
        var self = this,
            imgDim = self.elements.preview.getBoundingClientRect(),
            vpDim = self.elements.viewport.getBoundingClientRect(),
            boundDim = self.elements.boundary.getBoundingClientRect(),
            vpLeft = vpDim.left - boundDim.left,
            vpTop = vpDim.top - boundDim.top,
            w = vpLeft - ((imgDim.width - vpDim.width) / 2),
            h = vpTop - ((imgDim.height - vpDim.height) / 2),
            transform = new Transform(w, h, self._currentZoom);

        css(self.elements.preview, CSS_TRANSFORM, transform.toString());
    }

    function _transferImageToCanvas(customOrientation) {
        var self = this,
            canvas = self.elements.canvas,
            img = self.elements.img,
            ctx = canvas.getContext('2d'),
            exif = _hasExif.call(self),
            customOrientation = self.options.enableOrientation && customOrientation;

        ctx.clearRect(0, 0, canvas.width, canvas.height);
        canvas.width = img.width;
        canvas.height = img.height;

        if (exif) {
            getExifOrientation(img, function (orientation) {
                drawCanvas(canvas, img, num(orientation, 10));
                if (customOrientation) {
                    drawCanvas(canvas, img, customOrientation);
                }
            });
        } else if (customOrientation) {
            drawCanvas(canvas, img, customOrientation);
        }
    }

    function _getCanvas(data) {
        var self = this,
            points = data.points,
            left = num(points[0]),
            top = num(points[1]),
            width = (points[2] - points[0]),
            height = (points[3] - points[1]),
            circle = data.circle,
            canvas = document.createElement('canvas'),
            ctx = canvas.getContext('2d'),
            outWidth = width,
            outHeight = height,
            startX = 0,
            startY = 0;

        if (data.outputWidth && data.outputHeight) {
            outWidth = data.outputWidth;
            outHeight = data.outputHeight;
        }

        canvas.width = outWidth;
        canvas.height = outHeight;

        if (data.backgroundColor) {
            ctx.fillStyle = data.backgroundColor;
            ctx.fillRect(0, 0, outWidth, outHeight);
        }
        // start fixing data to send to draw image for enforceBoundary: false
        if (left < 0) {
            startX = Math.abs(left);
            left = 0;
        }
        if (top < 0) {
            startY = Math.abs(top);
            top = 0;
        }
        if ((left + width) > self._originalImageWidth) {
            width = self._originalImageWidth - left;
            outWidth = width;
        }
        if ((top + height) > self._originalImageHeight) {
            height = self._originalImageHeight - top;
            outHeight = height;
        }

        ctx.drawImage(this.elements.preview, left, top, width, height, startX, startY, outWidth, outHeight);
        if (circle) {
            ctx.fillStyle = '#fff';
            ctx.globalCompositeOperation = 'destination-in';
            ctx.beginPath();
            ctx.arc(outWidth / 2, outHeight / 2, outWidth / 2, 0, Math.PI * 2, true);
            ctx.closePath();
            ctx.fill();
        }
        return canvas;
    }

    function _getHtmlResult(data) {
        var points = data.points,
            div = document.createElement('div'),
            img = document.createElement('img'),
            width = points[2] - points[0],
            height = points[3] - points[1];

        addClass(div, 'croppie-result');
        div.appendChild(img);
        css(img, {
            left: (-1 * points[0]) + 'px',
            top: (-1 * points[1]) + 'px'
        });
        img.src = data.url;
        css(div, {
            width: width + 'px',
            height: height + 'px'
        });

        return div;
    }

    function _getBase64Result(data) {
        return _getCanvas.call(this, data).toDataURL(data.format, data.quality);
    }

    function _getBlobResult(data) {
        var self = this;
        return new Promise(function (resolve, reject) {
            _getCanvas.call(self, data).toBlob(function (blob) {
                resolve(blob);
            }, data.format, data.quality);
        });
    }

    function _bind(options, cb) {
        var self = this,
            url,
            points = [],
            zoom = null;

        if (typeof (options) === 'string') {
            url = options;
            options = {};
        }
        else if (Array.isArray(options)) {
            points = options.slice();
        }
        else if (typeof (options) == 'undefined' && self.data.url) { //refreshing
            _updatePropertiesFromImage.call(self);
            _triggerUpdate.call(self);
            return null;
        }
        else {
            url = options.url;
            points = options.points || [];
            zoom = typeof(options.zoom) === 'undefined' ? null : options.zoom;
        }

        self.data.bound = false;
        self.data.url = url || self.data.url;
        self.data.points = (points || self.data.points).map(function (p) {
            return parseFloat(p);
        });
        self.data.boundZoom = zoom;
        var prom = loadImage(url, self.elements.img, self.options.useCanvas);
        prom.then(function () {
            if (self.options.useCanvas) {
                self.elements.img.exifdata = null;
                _transferImageToCanvas.call(self, options.orientation || 1);
            }
            _updatePropertiesFromImage.call(self);
            _triggerUpdate.call(self);
            if (cb) {
                cb();
            }
        });
        return prom;
    }

    function fix(v, decimalPoints) {
        return parseFloat(v).toFixed(decimalPoints || 0);
    }

    function _get() {
        var self = this,
            imgData = self.elements.preview.getBoundingClientRect(),
            vpData = self.elements.viewport.getBoundingClientRect(),
            x1 = vpData.left - imgData.left,
            y1 = vpData.top - imgData.top,
            widthDiff = (vpData.width - self.elements.viewport.offsetWidth) / 2,
            heightDiff = (vpData.height - self.elements.viewport.offsetHeight) / 2,
            x2 = x1 + self.elements.viewport.offsetWidth + widthDiff,
            y2 = y1 + self.elements.viewport.offsetHeight + heightDiff,
            scale = self._currentZoom;

        if (scale === Infinity || isNaN(scale)) {
            scale = 1;
        }

        var max = self.options.enforceBoundary ? 0 : Number.NEGATIVE_INFINITY;
        x1 = Math.max(max, x1 / scale);
        y1 = Math.max(max, y1 / scale);
        x2 = Math.max(max, x2 / scale);
        y2 = Math.max(max, y2 / scale);

        return {
            points: [fix(x1), fix(y1), fix(x2), fix(y2)],
            zoom: scale
        };
    }

    var RESULT_DEFAULTS = {
            type: 'canvas',
            format: 'png',
            quality: 1
        },
        RESULT_FORMATS = ['jpeg', 'webp', 'png'];

    function _result(options) {
        var self = this,
            data = _get.call(self),
            opts = deepExtend(RESULT_DEFAULTS, deepExtend({}, options)),
            resultType = (typeof (options) === 'string' ? options : (opts.type || 'base64')),
            size = opts.size,
            format = opts.format,
            quality = opts.quality,
            backgroundColor = opts.backgroundColor,
            circle = typeof opts.circle === 'boolean' ? opts.circle : (self.options.viewport.type === 'circle'),
            vpRect = self.elements.viewport.getBoundingClientRect(),
            ratio = vpRect.width / vpRect.height,
            prom;

        if (size === 'viewport') {
            data.outputWidth = vpRect.width;
            data.outputHeight = vpRect.height;
        } else if (typeof size === 'object') {
            if (size.width && size.height) {
                data.outputWidth = size.width;
                data.outputHeight = size.height;
            } else if (size.width) {
                data.outputWidth = size.width;
                data.outputHeight = size.width / ratio;
            } else if (size.height) {
                data.outputWidth = size.height * ratio;
                data.outputHeight = size.height;
            }
        }

        if (RESULT_FORMATS.indexOf(format) > -1) {
            data.format = 'image/' + format;
            data.quality = quality;
        }

        data.circle = circle;
        data.url = self.data.url;
        data.backgroundColor = backgroundColor;

        prom = new Promise(function (resolve, reject) {
            switch(resultType.toLowerCase())
            {
                case 'rawcanvas': 
                    resolve(_getCanvas.call(self, data));
                    break;
                case 'canvas':
                case 'base64':
                    resolve(_getBase64Result.call(self, data));
                    break;
                case 'blob':
                    _getBlobResult.call(self, data).then(resolve);
                    break;
                default: 
                    resolve(_getHtmlResult.call(self, data));
                    break;
            }
        });
        return prom;
    }

    function _refresh() {
        _updatePropertiesFromImage.call(this);
    }

    function _rotate(deg) {
        if (!this.options.useCanvas) {
            throw 'Croppie: Cannot rotate without enableOrientation';
        }

        var self = this,
            canvas = self.elements.canvas,
            img = self.elements.img,
            copy = document.createElement('canvas'),
            ornt = 1;

        copy.width = canvas.width;
        copy.height = canvas.height;
        var ctx = copy.getContext('2d');
        ctx.drawImage(canvas, 0, 0);

        if (deg === 90 || deg === -270) ornt = 6;
        if (deg === -90 || deg === 270) ornt = 8;
        if (deg === 180 || deg === -180) ornt = 3;

        drawCanvas(canvas, copy, ornt);
        _onZoom.call(self);
    }

    function _destroy() {
        var self = this;
        self.element.removeChild(self.elements.boundary);
        removeClass(self.element, 'croppie-container');
        if (self.options.enableZoom) {
            self.element.removeChild(self.elements.zoomerWrap);
        }
        delete self.elements;
    }

    if (window.jQuery) {
        var $ = window.jQuery;
        $.fn.croppie = function (opts) {
            var ot = typeof opts;

            if (ot === 'string') {
                var args = Array.prototype.slice.call(arguments, 1);
                var singleInst = $(this).data('croppie');

                if (opts === 'get') {
                    return singleInst.get();
                }
                else if (opts === 'result') {
                    return singleInst.result.apply(singleInst, args);
                }
                else if (opts === 'bind') {
                    return singleInst.bind.apply(singleInst, args);
                }

                return this.each(function () {
                    var i = $(this).data('croppie');
                    if (!i) return;

                    var method = i[opts];
                    if ($.isFunction(method)) {
                        method.apply(i, args);
                        if (opts === 'destroy') {
                            $(this).removeData('croppie');
                        }
                    }
                    else {
                        throw 'Croppie ' + opts + ' method not found';
                    }
                });
            }
            else {
                return this.each(function () {
                    var i = new Croppie(this, opts);
                    i.$ = $;
                    $(this).data('croppie', i);
                });
            }
        };
    }

    function Croppie(element, opts) {
        this.element = element;
        this.options = deepExtend(deepExtend({}, Croppie.defaults), opts);

        if (this.element.tagName.toLowerCase() === 'img') {
            var origImage = this.element;
            addClass(origImage, 'cr-original-image');
            var replacementDiv = document.createElement('div');
            this.element.parentNode.appendChild(replacementDiv);
            replacementDiv.appendChild(origImage);
            this.element = replacementDiv;
            this.options.url = this.options.url || origImage.src;
        }
        
        _create.call(this);
        if (this.options.url) {
            var bindOpts = {
                url: this.options.url,
                points: this.options.points
            };
            delete this.options['url'];
            delete this.options['points'];
            _bind.call(this, bindOpts);
        }
    }

    Croppie.defaults = {
        viewport: {
            width: 100,
            height: 100,
            type: 'square'
        },
        boundary: { },
        orientationControls: {
            enabled: true,
            leftClass: '',
            rightClass: ''
        },
        customClass: '',
        showZoomer: true,
        enableZoom: true,
        mouseWheelZoom: true,
        enableExif: false,
        enforceBoundary: true,
        enableOrientation: false,
        update: function () { }
    };

    deepExtend(Croppie.prototype, {
        bind: function (options, cb) {
            return _bind.call(this, options, cb);
        },
        get: function () {
            return _get.call(this);
        },
        result: function (type) {
            return _result.call(this, type);
        },
        refresh: function () {
            return _refresh.call(this);
        },
        setZoom: function (v) {
            _setZoomerVal.call(this, v);
            dispatchChange(this.elements.zoomer);
        },
        rotate: function (deg) {
            _rotate.call(this, deg);
        },
        destroy: function () {
            return _destroy.call(this);
        }
    });

    exports.Croppie = window.Croppie = Croppie;

    if (typeof module === 'object' && !!module.exports) {
        module.exports = Croppie;
    }
}));


/*
* iziToast | v1.1.1
* http://izitoast.marcelodolce.com
* by Marcelo Dolce.
*/
!function(t,e){"function"==typeof define&&define.amd?define([],e(t)):"object"==typeof exports?module.exports=e(t):t.iziToast=e(t)}("undefined"!=typeof global?global:this.window||this.global,function(t){"use strict";var e={},n="iziToast",o=(document.querySelector("body"),!!/Mobi/.test(navigator.userAgent)),i=/Chrome/.test(navigator.userAgent)&&/Google Inc/.test(navigator.vendor),s="undefined"!=typeof InstallTrigger,r="ontouchstart"in document.documentElement,a=["bottomRight","bottomLeft","bottomCenter","topRight","topLeft","topCenter","center"],l={info:{color:"blue",icon:"ico-info"},success:{color:"green",icon:"ico-check"},warning:{color:"yellow",icon:"ico-warning"},error:{color:"red",icon:"ico-error"}},d=568,c={},u={"class":"",title:"",titleColor:"",message:"",messageColor:"",backgroundColor:"",color:"",icon:"",iconText:"",iconColor:"",image:"",imageWidth:50,zindex:99999,layout:1,balloon:!1,close:!0,rtl:!1,position:"bottomRight",target:"",targetFirst:!0,timeout:5e3,drag:!0,pauseOnHover:!0,resetOnHover:!1,progressBar:!0,progressBarColor:"",animateInside:!0,buttons:{},transitionIn:"fadeInUp",transitionOut:"fadeOut",transitionInMobile:"fadeInUp",transitionOutMobile:"fadeOutDown",onOpen:function(){},onClose:function(){}};"remove"in Element.prototype||(Element.prototype.remove=function(){this.parentNode&&this.parentNode.removeChild(this)});var p=function(t,e,n){if("[object Object]"===Object.prototype.toString.call(t))for(var o in t)Object.prototype.hasOwnProperty.call(t,o)&&e.call(n,t[o],o,t);else if(t)for(var i=0,s=t.length;s>i;i++)e.call(n,t[i],i,t)},m=function(t,e){var n={};return p(t,function(e,o){n[o]=t[o]}),p(e,function(t,o){n[o]=e[o]}),n},v=function(t){var e=document.createDocumentFragment(),n=document.createElement("div");for(n.innerHTML=t;n.firstChild;)e.appendChild(n.firstChild);return e},f=function(t){return"#"==t.substring(0,1)||"rgb"==t.substring(0,3)||"hsl"==t.substring(0,3)},h=function(){return{move:function(t,e,n,o){var r,a=.3,l=180;t.style.transform="translateX("+o+"px)",o>0?(r=(l-o)/l,a>r&&e.hide(m(n,{transitionOut:"fadeOutRight",transitionOutMobile:"fadeOutRight"}),t,"drag")):(r=(l+o)/l,a>r&&e.hide(m(n,{transitionOut:"fadeOutLeft",transitionOutMobile:"fadeOutLeft"}),t,"drag")),t.style.opacity=r,a>r&&((i||s)&&(t.style.left=o+"px"),t.parentNode.style.opacity=a,this.stopMoving(t,null))},startMoving:function(t,e,n,o){o=o||window.event;var i=r?o.touches[0].clientX:o.clientX,s=t.style.transform.replace("px)","");s=s.replace("translateX(","");var a=i-s;t.classList.remove(n.transitionIn),t.classList.remove(n.transitionInMobile),t.style.transition="",r?document.ontouchmove=function(o){o.preventDefault(),o=o||window.event;var i=o.touches[0].clientX,s=i-a;h.move(t,e,n,s)}:document.onmousemove=function(o){o.preventDefault(),o=o||window.event;var i=o.clientX,s=i-a;h.move(t,e,n,s)}},stopMoving:function(t,e){r?document.ontouchmove=function(){}:document.onmousemove=function(){},t.style.transition="transform 0.4s ease, opacity 0.4s ease",t.style.opacity="",t.style.transform="",window.setTimeout(function(){t.style.transition=""},400)}}}(),g=function(t,e,o){var i=!1,s=!1,r=!1,a=null,l=t.querySelector("."+n+"-progressbar div"),d={hideEta:null,maxHideTime:null,currentTime:(new Date).getTime(),updateProgress:function(){if(i=!!t.classList.contains(n+"-paused"),s=!!t.classList.contains(n+"-reseted"),r=!!t.classList.contains(n+"-closed"),s&&(clearTimeout(a),l.style.width="100%",g(t,e,o),t.classList.remove(n+"-reseted")),r&&(clearTimeout(a),t.classList.remove(n+"-closed")),!i&&!s&&!r){d.currentTime=d.currentTime+10;var c=(d.hideEta-d.currentTime)/d.maxHideTime*100;l.style.width=c+"%",(Math.round(c)<0||"object"!=typeof t)&&(clearTimeout(a),o.apply())}}};e.timeout>0&&(d.maxHideTime=parseFloat(e.timeout),d.hideEta=(new Date).getTime()+d.maxHideTime,a=setInterval(d.updateProgress,10))};return e.destroy=function(){p(document.querySelectorAll("."+n+"-wrapper"),function(t,e){t.remove()}),p(document.querySelectorAll("."+n),function(t,e){t.remove()}),document.removeEventListener(n+"-open",{},!1),document.removeEventListener(n+"-close",{},!1),c={}},e.settings=function(t){e.destroy(),c=t,u=m(u,t||{})},p(l,function(t,n){e[n]=function(e){var n=m(c,e||{});n=m(t,n||{}),this.show(n)}}),e.hide=function(t,e,i){var s=m(u,t||{});i=i||!1,"object"!=typeof e&&(e=document.querySelector(e)),e.classList.add(n+"-closed"),(s.transitionIn||s.transitionInMobile)&&(e.classList.remove(s.transitionIn),e.classList.remove(s.transitionInMobile)),o||window.innerWidth<=d?s.transitionOutMobile&&e.classList.add(s.transitionOutMobile):s.transitionOut&&e.classList.add(s.transitionOut);var r=e.parentNode.offsetHeight;if(e.parentNode.style.height=r+"px",e.style.pointerEvents="none",(!o||window.innerWidth>d)&&(e.parentNode.style.transitionDelay="0.2s"),setTimeout(function(){e.parentNode.style.height="0px",e.parentNode.style.overflow="",window.setTimeout(function(){e.parentNode.remove()},1e3)},200),s["class"])try{var a;window.CustomEvent?a=new CustomEvent(n+"-close",{detail:{"class":s["class"]}}):(a=document.createEvent("CustomEvent"),a.initCustomEvent(n+"-close",!0,!0,{"class":s["class"]})),document.dispatchEvent(a)}catch(l){console.warn(l)}"undefined"!=typeof s.onClose&&s.onClose.apply(null,[s,e,i])},e.show=function(t){var e=this,i=m(c,t||{});i=m(u,i);var s=document.createElement("div");s.classList.add(n+"-capsule");var l=document.createElement("div");if(l.classList.add(n),o||window.innerWidth<=d?i.transitionInMobile.length>0&&l.classList.add(i.transitionInMobile):i.transitionIn.length>0&&l.classList.add(i.transitionIn),i.rtl&&l.classList.add(n+"-rtl"),i.color.length>0&&(f(i.color)?l.style.background=i.color:l.classList.add(n+"-color-"+i.color)),i.backgroundColor.length>0&&(l.style.background=i.backgroundColor),i["class"]&&l.classList.add(i["class"]),i.image){var y=document.createElement("div");y.classList.add(n+"-cover"),y.style.width=i.imageWidth+"px",y.style.backgroundImage="url("+i.image+")",l.appendChild(y)}var b;if(i.close?(b=document.createElement("button"),b.classList.add(n+"-close"),l.appendChild(b)):i.rtl?l.style.paddingLeft="30px":l.style.paddingRight="30px",i.progressBar){var w=document.createElement("div");w.classList.add(n+"-progressbar");var L=document.createElement("div");L.style.background=i.progressBarColor,w.appendChild(L),l.appendChild(w),setTimeout(function(){g(l,i,function(){e.hide(i,l)})},300)}else i.progressBar===!1&&i.timeout>0&&setTimeout(function(){e.hide(i,l)},i.timeout);var C=document.createElement("div");if(C.classList.add(n+"-body"),i.image&&(i.rtl?C.style.marginRight=i.imageWidth+10+"px":C.style.marginLeft=i.imageWidth+10+"px"),i.icon){var E=document.createElement("i");E.setAttribute("class",n+"-icon "+i.icon),i.iconText&&E.appendChild(document.createTextNode(i.iconText)),i.rtl?C.style.paddingRight="33px":C.style.paddingLeft="33px",i.iconColor&&(E.style.color=i.iconColor),C.appendChild(E)}var I=document.createElement("strong");i.titleColor.length>0&&(I.style.color=i.titleColor),I.appendChild(v(i.title));var T=document.createElement("p");i.messageColor.length>0&&(T.style.color=i.messageColor),T.appendChild(v(i.message)),i.layout>1&&l.classList.add(n+"-layout"+i.layout),i.balloon&&l.classList.add(n+"-balloon"),C.appendChild(I),C.appendChild(T);var x;if(i.buttons.length>0){x=document.createElement("div"),x.classList.add(n+"-buttons"),T.style.marginRight="15px";var O=0;p(i.buttons,function(t,n){x.appendChild(v(t[0]));var o=x.childNodes;o[O].addEventListener("click",function(n){n.preventDefault();var o=t[1];return new o(e,l)}),O++}),C.appendChild(x)}l.appendChild(C),s.style.visibility="hidden",s.appendChild(l),setTimeout(function(){var t=l.offsetHeight,e=l.currentStyle||window.getComputedStyle(l),n=e.marginTop;n=n.split("px"),n=parseInt(n[0]);var o=e.marginBottom;o=o.split("px"),o=parseInt(o[0]),s.style.visibility="",s.style.height=t+o+n+"px",setTimeout(function(){s.style.height="auto",i.target&&(s.style.overflow="visible")},1e3)},100);var M,N=i.position;if(i.target)M=document.querySelector(i.target),M.classList.add(n+"-target"),i.targetFirst?M.insertBefore(s,M.firstChild):M.appendChild(s);else{if(-1==a.indexOf(i.position))return void console.warn("["+n+"] Incorrect position.\nIt can be › "+a);N=o||window.innerWidth<=d?"bottomLeft"==i.position||"bottomRight"==i.position||"bottomCenter"==i.position?n+"-wrapper-bottomCenter":"topLeft"==i.position||"topRight"==i.position||"topCenter"==i.position?n+"-wrapper-topCenter":n+"-wrapper-center":n+"-wrapper-"+N,M=document.querySelector("."+n+"-wrapper."+N),M||(M=document.createElement("div"),M.classList.add(n+"-wrapper"),M.classList.add(N),document.body.appendChild(M)),"topLeft"==i.position||"topCenter"==i.position||"topRight"==i.position?M.insertBefore(s,M.firstChild):M.appendChild(s)}isNaN(i.zindex)?console.warn("["+n+"] Invalid zIndex."):M.style.zIndex=i.zindex,i.onOpen.apply(null,[i,l]);try{var R;window.CustomEvent?R=new CustomEvent(n+"-open",{detail:{"class":i["class"]}}):(R=document.createEvent("CustomEvent"),R.initCustomEvent(n+"-open",!0,!0,{"class":i["class"]})),document.dispatchEvent(R)}catch(H){console.warn(H)}if(i.animateInside){l.classList.add(n+"-animateInside");var k=200,D=100,S=300;if("bounceInLeft"==i.transitionIn&&(k=400,D=200,S=400),window.setTimeout(function(){I.classList.add("slideIn")},k),window.setTimeout(function(){T.classList.add("slideIn")},D),i.icon&&window.setTimeout(function(){E.classList.add("revealIn")},S),i.buttons.length>0&&x){var B=150;p(x.childNodes,function(t,e){window.setTimeout(function(){t.classList.add("revealIn")},B),B+=B})}}b&&b.addEventListener("click",function(t){t.target;e.hide(i,l,"button")}),i.pauseOnHover&&(l.addEventListener("mouseenter",function(t){this.classList.add(n+"-paused")}),l.addEventListener("mouseleave",function(t){this.classList.remove(n+"-paused")})),i.resetOnHover&&(l.addEventListener("mouseenter",function(t){this.classList.add(n+"-reseted")}),l.addEventListener("mouseleave",function(t){this.classList.remove(n+"-reseted")})),i.drag&&(r?(l.addEventListener("touchstart",function(t){h.startMoving(this,e,i,t)},!1),l.addEventListener("touchend",function(t){h.stopMoving(this,t)},!1)):(l.addEventListener("mousedown",function(t){t.preventDefault(),h.startMoving(this,e,i,t)},!1),l.addEventListener("mouseup",function(t){t.preventDefault(),h.stopMoving(this,t)},!1)))},e});
