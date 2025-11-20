/**
 * Custom Code Editor using ACE editor
 */

 var ace_footer,
    ace_header,
    ace_html_head,
    ace_css,
    ace_supernav1,
    ace_supernav2,
    ace_supernav3;

ace_footer = ace.edit("ace-footer");
ace_footer.setTheme("ace/theme/github");
ace_footer.getSession().setMode("ace/mode/xml");
ace_footer.setValue(ace_footer_val);

ace_header = ace.edit("ace-header");
ace_header.setTheme("ace/theme/github");
ace_header.getSession().setMode("ace/mode/xml");
ace_header.setValue(ace_header_val);

ace_html_head = ace.edit("ace-html-head");
ace_html_head.setTheme("ace/theme/github");
ace_html_head.getSession().setMode("ace/mode/xml");
ace_html_head.setValue(ace_html_head_val);

ace_css = ace.edit("ace-css");
ace_css.setTheme("ace/theme/github");
ace_css.getSession().setMode("ace/mode/xml");
ace_css.setValue(ace_custom_css_val);

if (typeof document.getElementById("ace-supernav1") !== 'undefined') {
  ace_supernav1 = ace.edit("ace-supernav1");
  ace_supernav1.setTheme("ace/theme/github");
  ace_supernav1.getSession().setMode("ace/mode/xml");
  ace_supernav1.setValue(ace_supernav1_val);
}

if (typeof document.getElementById("ace-supernav2") !== 'undefined') {
  ace_supernav2 = ace.edit("ace-supernav2");
  ace_supernav2.setTheme("ace/theme/github");
  ace_supernav2.getSession().setMode("ace/mode/xml");
  ace_supernav2.setValue(ace_supernav2_val);
}

if (typeof document.getElementById("ace-supernav3") !== 'undefined') {
  ace_supernav3 = ace.edit("ace-supernav3");
  ace_supernav3.setTheme("ace/theme/github");
  ace_supernav3.getSession().setMode("ace/mode/xml");
  ace_supernav3.setValue(ace_supernav3_val);
}

function saveAceEditorContent() {

  if (typeof ace_supernav1 !== 'undefined') {
    var supernav1_val = ace_supernav1.getValue();
    $(".supernav1-editor").val(supernav1_val);
  }

  if (typeof ace_supernav2 !== 'undefined') {
    var supernav2_val = ace_supernav2.getValue();
    $(".supernav2-editor").val(supernav2_val);
  }

  if (typeof ace_supernav3 !== 'undefined') {
    var supernav3_val = ace_supernav3.getValue();
    $(".supernav3-editor").val(supernav3_val);
  }

  var footer_val = ace_footer.getValue();
  $(".footer-editor").val(footer_val);

  var header_val = ace_header.getValue();
  $(".header-editor").val(header_val);

  var html_head_val = ace_html_head.getValue();
  $(".html-head-editor").val(html_head_val);

  var custom_css = ace_css.getValue();
  $(".css-editor").val(custom_css);

  saveTheme();
}

/**
 * ColorPicker object and database binding scripts
 * ===============================================
 */
 $(".js-colorpicker").ColorPicker({
   flat: false,
   onSubmit: function(hsb, hex, rgb, el) {
     $(el).val("#"+hex);
     $(el).next().attr("style","background-color: #"+hex);
     $(el).ColorPickerHide();
   },
   onBeforeShow: function () {
     $(this).ColorPickerSetColor(this.value);
   },
   onChange: function (hsb, hex, rgb) {
   }
 }).bind('keyup', function(){
   $(this).ColorPickerSetColor(this.value);
 });
