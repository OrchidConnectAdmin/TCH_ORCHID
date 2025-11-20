

var pageLoader,
    pleaseWaitImg,
    pleaseWaitBgColor;

var showPageLoader = function() {
  if (typeof logo_image !== 'undefined') {
    pleaseWaitImg = logo_image;
  } else {
    pleaseWaitImg = '../../img/please-wait/logo.png';
  }
  if (typeof body_bg_color !== 'undefined') {
    pleaseWaitBgColor = body_bg_color;
  } else {
    pleaseWaitBgColor = '#f3f4f5';
  }
  pageLoader = pleaseWait({
    logo: pleaseWaitImg,
    backgroundColor: pleaseWaitBgColor,
    loadingHtml: "<div class='sk-spinner sk-spinner-wave'><div class='sk-rect1'></div><div class='sk-rect2'></div><div class='sk-rect3'></div><div class='sk-rect4'></div><div class='sk-rect5'></div></div>"
  });
};

var hidePageLoader = function() {
  pageLoader.finish();
};



// Custom prototype extension for string comparables
// used for active navigation highlighting
if (typeof String.prototype.endsWith !== 'function') {
  String.prototype.endsWith = function(suffix) {
      return this.indexOf(suffix, this.length - suffix.length) !== -1;
  };
}



// Reserved for future use


em.button = function(el) {
  if (typeof ladda !== 'undefined') {
    return Ladda.create(el);
  }
  console.log('WARNING!!! Missing Ladda Plugin Include!');
  return el;
};


var absurd = Absurd();

var darkenHexColor = function(color,value) {
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
};

var lightenHexColor = function(color,value) {
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
};

var writeBrandStyles = function() {

  if ( typeof primary_color !== 'undefined' && typeof secondary_color !== 'undefined' ) {

    var brand_primary_light_hex = lightenHexColor(primary_color,0.025); //primary_color.brighter(0.075).toString();
    var brand_primary_hex = primary_color;
    var brand_primary_dark_hex = darkenHexColor(primary_color,0.025); //primary_color.darker(0.075).toString();
    var brand_secondary_light_hex = lightenHexColor(secondary_color,0.025); //secondary_color.brighter(0.075).toString();
    var brand_secondary_hex = secondary_color;
    var brand_secondary_dark_hex = darkenHexColor(secondary_color,0.025); //secondary_color.darker(0.075).toString();

		//test


    absurd.component("BrandStyles", {
      css: {

					'.sk-spinner-wave': {
						'div' : {
							backgroundColor: brand_primary_hex
						},
					},

					'.navbar-inverse': {
						backgroundColor: brand_secondary_hex,
						borderColor: brand_secondary_dark_hex
					},

					'.pagination > li > a, .pagination > li > span': {
						color: brand_secondary_hex
					},

					'.dropdown-menu > .active > a, .dropdown-menu > .active > a:hover, .dropdown-menu > .active > a:focus': {
						backgroundColor: brand_secondary_hex,
					},
					'.pagination > .active > a, .pagination > .active > a:hover, .pagination > .active > a:focus, .pagination > .active > span, .pagination > .active > span:hover, .pagination > .active > span:focus':{
						background: brand_secondary_hex,
						borderColor: brand_secondary_hex
					},

					'.btn-checkbox .btn': {
						background: '#999',
						'&:hover' : {
							background: brand_primary_hex,
							opacity: '.85'
						},
						'&.active' : {
							background: brand_primary_hex,
							opacity: '1'
						},
					},

					'.btn.action-true': {
					  backgroundColor: brand_primary_hex,
						'&.active': {
							backgroundColor: brand_primary_hex
						},
					},

					'.btn-checkbox .btn.action-true': {
					  backgroundColor: brand_primary_hex,
						'&.active': {
							backgroundColor: brand_primary_hex
						},
					},

					'.btn.btn-primary, .sweetalert .confirm': {
						backgroundColor: brand_primary_light_hex,
						borderColor: brand_primary_light_hex,
						'&:hover, &:focus, &:active, &.active' : {
							backgroundColor: brand_primary_dark_hex,
							borderColor: brand_primary_dark_hex
						},
					},

          '.btn.btn-info, .sweetalert .cancel': {
						backgroundColor: brand_secondary_light_hex,
            borderColor: brand_secondary_light_hex,
            '&:hover, &:focus, &:active, &.active' : {
              backgroundColor: brand_secondary_dark_hex,
              borderColor: brand_secondary_dark_hex
            },
          },

					'.carousel .slick-prev, .carousel .slick-next' : {
						backgroundColor: brand_secondary_light_hex + '!important',
						borderColor: brand_secondary_light_hex,
						'&:hover, &:focus, &:active, &.active' : {
							backgroundColor: brand_secondary_dark_hex +'!important',
							borderColor: brand_secondary_dark_hex
						},
					},

					'.btn.btn-info.outline': {
						color: brand_secondary_hex,
					},
					'.btn.btn-primary.outline': {
						color: brand_primary_hex,
					},
					'.modal-header': {
						background: brand_secondary_hex
					},

					'.btn.btn-registration.active': {
						background: brand_primary_hex
					},

					'.btn-registration': {
						background :'rgba(' + brand_primary_hex + ',.6)',
						color: 'white',
						'&:focus,&:hover': {
							background: 'rgba(' + brand_primary_hex + ',1)'
						},
					},

					'.btn-title': {
						background: 'white',
						'&:hover': {
							background: brand_primary_hex,
							color: 'white',
						},
						'&:focus':{
							background: 'darken(' + brand_primary_hex + ',20%)',
							color: 'white'
						},
					},
					'.event-date': {
						background: 'rgba(' + brand_primary_hex + ',.7)',
						'&:hover': {
							background: 'rgba(' + brand_primary_hex + ',1)'
						},
					},
          '.panel-primary': {
            '> .panel-heading ' : {
              gradient: brand_primary_hex + '/' + brand_primary_light_hex,
              borderColor: brand_primary_dark_hex
            },
          },
          '.panel-info': {
            '> .panel-heading ' : {
              gradient: brand_secondary_hex + '/' + brand_secondary_light_hex,
              borderColor: brand_secondary_dark_hex
            },
          },
          '.bg-primary, .badge-primary, .label-primary': {
            gradient: brand_primary_light_hex + '/' + brand_primary_light_hex
          },
          '.bg-info, .badge-info, .label-info, .chosen-container-multi .chosen-choices .search-choice': {
            gradient: brand_secondary_hex + '/' + brand_secondary_light_hex
          },
          '.text-primary' : {
            color: brand_primary_hex,
          },
          '.text-info' : {
            color: brand_secondary_hex,
          },
          'legend' : {
            color: brand_secondary_hex,
          },
          '.section-heading' : {
            bg: brand_secondary_hex
          },
					'.heading' : {
						background: brand_primary_hex
					},
          '.nav-pills > li.active > a, .nav-pills > li.active > a:hover, .nav-pills > li.active > a:focus' : {
            bg: brand_primary_hex,
            borderColor: brand_primary_dark_hex
          },
          '.dropdown-menu > .active > a' : {
            '&:hover,&:active,&:focus' : {
              bg: brand_primary_hex,
              borderColor: brand_primary_dark_hex
            },
          },

          '.list-group-item.active, .list-group-item.active:hover, .list-group-item.active:focus' : {
            background: brand_primary_hex,
            borderColor: brand_primary_dark_hex
          },

					'.event-calendar': {
						'button': {
							color: brand_primary_hex,
						},
						'button:hover,button:focus,button:active': {
							color: 'white'
						},
					},

					'.list-group-item.active>.badge, .nav-pills>.active>a>.badge' : {
							color: brand_primary_hex
					},

      },
      constructor : function() {
          this.populate();
      }
    })();
  }
};

var writeCoreStyles = function() {
  if ( typeof body_bg_color !== 'undefined' && typeof text_color !== 'undefined' && typeof link_color !== 'undefined') {

    var body_bg_color_hex = body_bg_color;
    var text_color_hex = text_color;
    var link_color_hex = link_color;
    var link_color_hover_hex = darkenHexColor(link_color,0.025); //link_color.darker(0.075).toString();

    absurd.component("CoreStyles", {
      css: {
          'body': {
            background: body_bg_color_hex,
						backgroundColor: body_bg_color_hex,
            color: text_color_hex
          },
          'a, .nav-pills > li > a, a:focus': {
            color: link_color_hex
          },
          'a:hover': {
            color: link_color_hover_hex
          },
					'.btn-link, .btn-link:focus': {
						color: link_color_hex
					},

					'.btn-link:hover': {
						color: link_color_hover_hex
					},
      },
      constructor : function() {
          this.populate();
      }
    })();
  }
};

var isDarkColor = function(a) {
	var r,g,b,hsp;
  if (a.match(/^rgb/)) {
    a = a.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+(?:\.\d+)?))?\)$/);
    r = a[1];
    b = a[2];
    g = a[3];
  } else {
    a = +("0x" + a.slice(1).replace( // thanks to jed : http://gist.github.com/983661
        a.length < 5 && /./g, '$&$&'
      )
    );
    r = a >> 16;
    b = a >> 8 & 255;
    g = a & 255;
  }
  hsp = Math.sqrt( // HSP equation from http://alienryderflex.com/hsp.html
    0.299 * (r * r) +
    0.587 * (g * g) +
    0.114 * (b * b)
  );
  if (hsp > 127.5) {
    return false;
  } else {
  	return true;
  }
};

var writeNavbarStyles = function() {
  if ( typeof navbar_bg_color !== 'undefined' && typeof navbar_link_color !== 'undefined' && typeof supernav_bg_color !== 'undefined' && typeof supernav_link_color !== 'undefined' ) {

		var supernav_bg_color_light_hex = lightenHexColor(supernav_bg_color,0.025);
    var supernav_bg_color_hex = supernav_bg_color;
    var supernav_bg_color_dark_hex = darkenHexColor(supernav_bg_color,0.025);
    var supernav_text_color_hex = supernav_text_color;
		var supernav_link_color_hex = supernav_link_color;
		var supernav_link_color_hover_hex = lightenHexColor(supernav_link_color,0.025);
		var supernav_border_color_hex = darkenHexColor(supernav_bg_color,0.045);

		if (isDarkColor(supernav_bg_color)) {
			supernav_border_color_hex = lightenHexColor(supernav_bg_color,0.045);
		}

    var navbar_bg_color_light_hex = lightenHexColor(navbar_bg_color,0.025);
    var navbar_bg_color_hex = navbar_bg_color;
    var navbar_bg_color_dark_hex = darkenHexColor(navbar_bg_color,0.025);
    var navbar_link_color_hex = navbar_link_color;
		var navbar_link_color_hover_hex = lightenHexColor(navbar_link_color,0.025);

    absurd.component("NavbarStyles", {
      css: {

					'#wrapper .em-topbar, .em-topbar': {
						backgroundColor: supernav_bg_color_hex,
						color: supernav_text_color_hex,
						borderColor: supernav_bg_color_dark_hex,
						'.topbar-list>li': {
							borderColor: supernav_border_color_hex
						},
						'.topbar-list:last-child': {
							borderColor: supernav_border_color_hex
						},
						'a': {
							color: supernav_link_color_hex,
							'&:hover,&:focus': {
								color: supernav_link_color_hover_hex
							}
						}
					},
					'.navbar.em-navbar .navbar-toggle .icon-bar, .em-navbar .navbar-toggle .icon-bar' :{
						backgroundColor: navbar_link_color_hex
					},

          '.navbar.em-navbar, .em-navbar, .navbar-inverse': {
            background: navbar_bg_color_hex,
						backgroundColor : navbar_bg_color_hex,
            color: navbar_link_color_hex,
            borderColor: navbar_bg_color_dark_hex
          },

					'.navbar.em-navbar .navbar-nav > li > a, .em-navbar .navbar-nav > li > a, .navbar-inverse .navbar-nav > li > a': {
						color: navbar_link_color_hex,
						'&:hover,&:focus': {
							color: navbar_link_color_hover_hex
						}
					},

          '.navbar.em-navbar .navbar-collapse, .em-navbar .navbar-collapse, .em-navbar .navbar-form, .navbar.em-navbar .navbar-form, .navbar-inverse .navbar-collapse, .navbar-inverse .navbar-form ' : {
            borderColor: navbar_bg_color_dark_hex
          },

					'.navbar.em-navbar .navbar-search .navbar-search-input + i, .em-navbar .navbar-search .navbar-search-input + i': {
            color: navbar_link_color_hex
          },
      },
      constructor : function() {
          this.populate();
      }
    })();
  }
};


em.theme = function() {
	writeCoreStyles();
  writeNavbarStyles();
  writeBrandStyles();
};


em.setFrameHeight = function(iframe) {
  iframe.height = iframe.contentWindow.document.body.scrollHeight + "px";
  iframe.contentWindow.document.body.style.padding = 0;
  iframe.contentWindow.document.body.style.margin = 0;
};


em.inputfile = {
  inputElement : null
};

em.loader = {
    start : function(targetElement) {
        var l = Ladda.create(targetElement);
        l.start();
    },
    stop : function(targetElement) {
        var l = Ladda.create(targetElement);
        l.stop();
    },
    stopAll : function() {
        Ladda.stopAll();
    }
};

/**
 * Removes salesforce lookup links and preserves
 * the value of the link anchor - typically the
 * name of the record referenced. This function helps
 * prevent the need to use custom selectors that select
 * the name of parent fields in the member portal.
 */
em.removeLookupHoverLinks = function() {
  $("a[id^='lookup']").each(function(){
    var lookup = $(this);
    var anchor = $(this).text();
    var parent = $(this).parent();
    lookup.remove();
    parent.append(anchor);
  });
};


// PROPERTIES FOR em.message objects
// Argument	               Default value	       Description
// ========================|=====================|=================================
// title	                 null                  (required)	The title of the modal. It can either be added to the object under the key "title" or passed as the first parameter of the function.
// text	                   null	                 A description for the modal. It can either be added to the object under the key "text" or passed as the second parameter of the function.
// type                  	 null	                 The type of the modal. SweetAlert comes with 4 built-in types which will show a corresponding icon animation: "warning", "error", "success" and "info". You can also set it as "input" to get a prompt modal. It can either be put in the object under the key "type" or passed as the third parameter of the function.
// allowEscapeKey	         true	                 If set to true, the user can dismiss the modal by pressing the Escape key.
// customClass	           null	                 A custom CSS class for the modal. It can be added to the object under the key "customClass".
// allowOutsideClick	     false	               If set to true, the user can dismiss the modal by clicking outside it.
// showCancelButton	       false	               If set to true, a "Cancel"-button will be shown, which the user can click on to dismiss the modal.
// showConfirmButton	     true	                 If set to false, the "OK/Confirm"-button will be hidden. Make sure you set a timer or set allowOutsideClick to true when using this, in order not to annoy the user.
// confirmButtonText	     "OK"	                 Use this to change the text on the "Confirm"-button. If showCancelButton is set as true, the confirm button will automatically show "Confirm" instead of "OK".
// confirmButtonColor	     "#AEDEF4"	           Use this to change the background color of the "Confirm"-button (must be a HEX value).
// cancelButtonText	       "Cancel"	             Use this to change the text on the "Cancel"-button.
// closeOnConfirm	         true	                 Set to false if you want the modal to stay open even if the user presses the "Confirm"-button. This is especially useful if the function attached to the "Confirm"-button is another SweetAlert.
// closeOnCancel	         true	                 Same as closeOnConfirm, but for the cancel button.
// imageUrl	               null	                 Add a customized icon for the modal. Should contain a string with the path to the image.
// imageSize	             "80x80"	             If imageUrl is set, you can specify imageSize to describes how big you want the icon to be in px. Pass in a string with two values separated by an "x". The first value is the width, the second is the height.
// timer	                 null	                 Auto close timer of the modal. Set in ms (milliseconds).
// html	                   false	               If set to true, will not escape title and text parameters. (Set to false if you're worried about XSS attacks.)
// animation	             true                	 If set to false, the modal's animation will be disabled.
// inputType	             "text"	               Change the type of the input field when using type: "input" (this can be useful if you want users to type in their password for example).
// inputPlaceholder	       null	                 When using the input-type, you can specify a placeholder to help the user.
// inputValue	             null	                 Specify a default text value that you want your input to show when using type: "input"

em.message = {
  title: null,
  text: null,
  type: "info",
  allowOutsideClick: false,
  allowEscapeKey: true,
  showCancelButton: false,
  showConfirmButton: true,
  confirmButtonText: "OK",
  confirmButtonColor: primary_color,
  cancelButtonText: "Cancel",
  closeOnConfirm: true,
  closeOnCancel: true,
  imageUrl: null,
  imageSize: "80x80",
  timer: null,
  html: false,
  animation: true,
  inputType: "text",
  inputPlaceholder: null,
  inputValue: null,
  show : function() {
    this.alert();
  },
  alert : function() {
    swal({
      title: this.title,
      text: this.text,
      type: this.type,
      allowOutsideClick: this.allowOutsideClick,
      allowEscapeKey: this.allowEscapeKey,
      showCancelButton: this.showCancelButton,
      showConfirmButton: this.showConfirmButton,
      confirmButtonText: this.confirmButtonText,
      confirmButtonColor: this.confirmButtonColor,
      cancelButtonText: this.cancelButtonText,
      closeOnConfirm: this.closeOnConfirm,
      closeOnCancel: this.closeOnCancel,
      imageUrl: this.imageUrl,
      imageSize: this.imageSize,
      timer: this.timer,
      html: this.html,
      animation: this.animation,
      inputType: this.inputType,
      inputPlaceholder: this.inputPlaceholder,
      inputValue: this.inputValue,
    });
  },
  close : function() {
    swal.close();
  }
};


em.actionStatus = Object.create(em.message);
em.actionStatus.type = "info";
em.actionStatus.title = "Processing";
em.actionStatus.text = null;
em.actionStatus.showCancelButton = false;
em.actionStatus.showConfirmButton = false;
em.actionStatus.imageUrl = 'https://package-assets.s3.amazonaws.com/media/icons/apps_bg.png';

em.info = function(msg) {
  em.alert(title,message,"info");
};

em.error = function(title,message) {
  em.alert(title,message,"error");
};

em.success = function(msg) {
  em.alert(title,message,"success");
};

em.alert = function(title,message,severity) {
  sweetAlert(title,message,severity);
};


/**
 * Returns a clean (strip out query params and hash) string
 * used for active navigation menu highlighting
 * @param str String to clean
 * @return String
 */
var stripQueryStringAndHash = function(str) {
  return (typeof str !== 'undefined') ? str.split("?")[0].split("#")[0] : str;
};

/**
 * Adds the .active class to a navigation link's parent 'li' element
 */
em.highlighter = function() {
  var currentPageUrl = stripQueryStringAndHash(window.location.pathname);
  $('ul li a').each(function(){
    var navLink = stripQueryStringAndHash($(this).attr('href'));
    if (navLink.endsWith(currentPageUrl)) {
      $(this).parent().addClass('active');
      $(this).parents('li').add(this).each(function(){
        if ($(this).hasClass('dropdown')) {
          $(this).addClass('active');
        }
      });
    }
  });
};

$('#sidenav').click(function(){
  $('body').toggleClass('push-right');
  $('#sidenav .badge').toggleClass('hidden');
  $('#sidenav .btr.bt-times').toggleClass('hidden');
});





$.fn.succinct = function(options) {

	var settings = $.extend({
			size: 240,
			omission: '...',
			ignore: true
		}, options);

	return this.each(function() {

		var textDefault,
			textTruncated,
			elements = $(this),
			regex    = /[!-\/:-@\[-`{-~]$/,
			init     = function() {
				elements.each(function() {
					textDefault = $(this).html();

					if (textDefault.length > settings.size) {
						textTruncated = $.trim(textDefault)
										.substring(0, settings.size)
										.split(' ')
										.slice(0, -1)
										.join(' ');

						if (settings.ignore) {
							textTruncated = textTruncated.replace(regex, '');
						}

						$(this).html(textTruncated + settings.omission);
					}
				});
			};
		init();
	});
};


$('.limitTopInfo').succinct({
  size: 75
});


em.plugins = function() {
  var $chosen = $('[data-init-plugin="chosen"]');
  if ($chosen.length) {
    $chosen.chosen({
      disable_search_threshold : 10
    });
  }
  var $switchery = $('[data-init-plugin="switchery"]');
  if ($switchery.length) {
    $switchery.Switchery();
  }
};


em.scroller = {
    opts : {
        theme : 'mimimal-dark',
        scrollInertia : 0
    },
    enable : function(targetElement) {
        $(targetElement).mCustomScrollbar(this.opts);
    },
    update : function(targetElement) {
      $(targetElement).mCustomScrollbar("update");
    }
};


em.spinner = {
  opts: {
    lines: 8, // The number of lines to draw
    length: 10, // The length of each line
    width: 4, // The line thickness
    radius: 5, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#FFF', // #rgb or #rrggbb or array of colors
    speed: 1.1, // Rounds per second
    trail: 74, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: '50%', // Top position relative to parent in px
    left: '50%' // Left position relative to parent in px
  },
  targetElement: null,
  spinnerObj: null,
  spin : function(targetElement) {
    this.spinnerObj = new Spinner(this.opts).spin(targetElement);
  },
  stop : function() {
    if (typeof this.spinnerObj !== 'undefined') {
      this.spinnerObj.stop();
    }
  },
  spinDark : function(targetElement) {
      this.opts.color = '#000';
      this.spinnerObj = new Spinner(this.opts).spin(targetElement);
  }
};

// Object.create(em.spinner)

em.logout = function() {
  $('#wrapper').css('display','none');
  $('body').css('background-color','#ABABAB');
  var logoutMsg = Object.create(em.message);
  logoutMsg.type = "success";
  logoutMsg.showCancelButton = false;
  logoutMsg.showConfirmButton = false;
  logoutMsg.title = 'You are now logged out';
  logoutMsg.text = 'Please close this window';
  logoutMsg.allowEscapeKey = false;
  logoutMsg.allowOutsideClick = false;
  logoutMsg.show();

  setTimeout(function() {
      window.location = site_url + '/secur/logout.jsp?retUrl='+ encodeURIComponent(window.location.href);
  },1500);
};





showPageLoader();

em.init = function() {
  em.theme();
  em.removeLookupHoverLinks();
  em.highlighter();
  em.plugins();
};

em.init();

setTimeout(function(){
  hidePageLoader();
},1000);



em.loaded = true;

em.ready = function() {
  return em.loaded;
};
