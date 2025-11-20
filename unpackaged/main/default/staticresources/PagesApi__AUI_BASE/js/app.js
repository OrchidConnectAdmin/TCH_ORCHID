/*!
 * AUI.JS
 * Core scripts supporting aui (Admin User Interface) for Fonteva.
 * @author Mac Anderson
 */
var aui = aui || {};
// calcs layout based on viewport size
aui.layout = function() {
  var page = $("#aui-main");
  var pageMain = $("#aui-main > td:not('.aui-sidebar')");
  var wrapper =  $("#aui-wrapper");
  var pageMainWidth = pageMain.innerWidth();
  var sidebar = $(".aui-sidebar");
  var sidebarWidth = 0;
  var action = $("#aui-action");
  if (typeof action !== "undefined") {
    action.css("width",pageMainWidth);
    if (typeof sidebar !== "undefined") {
      sidebarWidth = sidebar.innerWidth();
      if (sidebarWidth !== null) {
        action.css("left",sidebarWidth + 1);
      }
    }
  }
};

aui.layout();

aui.toggle_fullscreen = function () {
  var toggle = $(".fullscreen-toggle");
  var main_layout = $("#aui-layout");
  var content_layout = $(".aui-flex");
  main_layout.toggleClass('fullscreen');
  if (main_layout.hasClass('fullscreen')) {
    main_layout.css('position','fixed');
    main_layout.css('top','0');
    main_layout.css('bottom','0');
    main_layout.css('right','0');
    main_layout.css('left','0');
    main_layout.css('z-index','100');
    content_layout.css('height','100vh');
  } else {
    main_layout.css('position','relative');
    main_layout.css('z-index','1');
    content_layout.css('height','80vh');
  }
};


// recalc layout when the window is resized
var onResizeTimeDelay;
$(window).resize(function() {
    clearTimeout(onResizeTimeDelay);
    onResizeTimeDelay = setTimeout(aui.layout(),150);
});




aui.initPluginSelect = function(els) {
  els.select2();
};

// primary init function for plugins
aui.initPlugins = function() {
  var enhanced_selectlists = $("[data-init-plugin='chosen']");
  if (enhanced_selectlists.length) {
    enhanced_selectlists.chosen();
  }
  var select2_selectlists = $("[data-plugin='select2']");
  if (select2_selectlists.length) {
      select2_selectlists.select2();
  }
  var select_plugin_elements = $("[data-aui-plugin='select']");
  if (select_plugin_elements.length) {
    aui.initPluginSelect(select_plugin_elements);
  }
};




aui.registerEventHandlers = function() {


  // fullscreen toggle
  var aui_fullscreen_toggle = $(".toggle-fullscreen");

  if (aui_fullscreen_toggle.length) {
    $('.toggle-fullscreen').click(function() {
      aui.toggle_fullscreen();
      aui.layout();
    });
  }

};

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

aui.loader = {
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


$(document).ready(function(){
  aui.registerEventHandlers();
  aui.initPlugins();
});
