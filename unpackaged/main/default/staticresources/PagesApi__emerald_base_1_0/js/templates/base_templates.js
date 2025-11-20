this["base"] = this["base"] || {};
this["base"]["templates"] = this["base"]["templates"] || {};
this["base"]["templates"]["input_form_accordion"] = Handlebars.template({"1":function(depth0,helpers,partials,data) {
    var stack1, helper, alias1=this.lambda, alias2=helpers.helperMissing;

  return "		<div class=\"panel panel-primary\">\n			<div class=\"panel-heading\">\n"
    + ((stack1 = helpers['if'].call(depth0,(data && data.first),{"name":"if","hash":{},"fn":this.program(2, data, 0),"inverse":this.program(4, data, 0),"data":data})) != null ? stack1 : "")
    + "				<span class=\"m-0 h4\">\n					<strong>"
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Name : stack1), depth0)) != null ? stack1 : "")
    + "</strong>\n				</span>\n			</div>\n			</div>\n			<div id=\"collapse-"
    + this.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : alias2),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\" class=\"panel-collapse collapse "
    + ((stack1 = (helpers.if_eq || (depth0 && depth0.if_eq) || alias2).call(depth0,(data && data.index),0,{"name":"if_eq","hash":{},"fn":this.program(6, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "\">\n				<div class=\"panel-body no-border p-h-0\">\n"
    + ((stack1 = helpers['if'].call(depth0,(depth0 != null ? depth0.hasInstructions : depth0),{"name":"if","hash":{},"fn":this.program(8, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "				<form data-validate-parsley=\"true\" id=\""
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\" class=\"form-pages-template\" data-multiple=\""
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Is_Multiple__c : stack1), depth0)) != null ? stack1 : "")
    + "\">\n"
    + ((stack1 = helpers['if'].call(depth0,((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Is_Multiple__c : stack1),{"name":"if","hash":{},"fn":this.program(10, data, 0),"inverse":this.program(12, data, 0),"data":data})) != null ? stack1 : "")
    + "					<div class=\"row\">\n						<div class=\"col-sm-12 text-center\">\n"
    + ((stack1 = helpers['if'].call(depth0,(data && data.first),{"name":"if","hash":{},"fn":this.program(14, data, 0),"inverse":this.program(16, data, 0),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers['if'].call(depth0,(data && data.last),{"name":"if","hash":{},"fn":this.program(18, data, 0),"inverse":this.program(20, data, 0),"data":data})) != null ? stack1 : "")
    + "						</div>\n					</div>\n				</form>\n				</div>\n			</div>\n		</div>\n";
},"2":function(depth0,helpers,partials,data) {
    var helper;

  return "					<div data-toggle=\"collapse\" data-parent=\"#accordionForm\" href=\"#collapse-"
    + this.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\" class=\"panel-title rotate-180-animate disabled\">\n";
},"4":function(depth0,helpers,partials,data) {
    var helper;

  return "						<div data-toggle=\"collapse\" data-parent=\"#accordionForm\" href=\"#collapse-"
    + this.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\" class=\"panel-title rotate-180-animate collapsed disabled\">\n";
},"6":function(depth0,helpers,partials,data) {
    return " in";
},"8":function(depth0,helpers,partials,data) {
    var stack1;

  return "					<div class=\"row\">\n						<div class=\"col-md-12\">\n							<pre class=\"clean-formatted-text line-breaks well p-0\">"
    + ((stack1 = this.lambda(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Instructions__c : stack1), depth0)) != null ? stack1 : "")
    + "</pre>\n						</div>\n					</div>\n";
},"10":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = this.invokePartial(partials['types/input_form_multiple.js'],depth0,{"name":"types/input_form_multiple.js","data":data,"indent":"\t\t\t\t\t\t","helpers":helpers,"partials":partials})) != null ? stack1 : "");
},"12":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = this.invokePartial(partials['types/input_form_basic.js'],depth0,{"name":"types/input_form_basic.js","data":data,"indent":"\t\t\t\t\t\t\t","helpers":helpers,"partials":partials})) != null ? stack1 : "");
},"14":function(depth0,helpers,partials,data) {
    return "";
},"16":function(depth0,helpers,partials,data) {
    var stack1, helper;

  return "									<button data-toggle=\"collapse\" data-parent=\"#accordionForm\" href=\"javascript:void(0)\" role=\"button\" data-index=\""
    + this.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\" class=\"btn btn-default previous-step-form-accordion\" data-id=\""
    + ((stack1 = this.lambda(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\">\n										Previous\n									</button>\n";
},"18":function(depth0,helpers,partials,data) {
    var stack1;

  return "								<button data-toggle=\"collapse\" data-parent=\"#accordionForm\" href=\"javascript:void(0)\" role=\"button\" class=\"btn btn-info complete-form-accordion ladda-button\" data-style=\"expand-right\" data-id=\""
    + ((stack1 = this.lambda(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\">\n									<span class=\"ladda-label\">Submit</span>\n								</button>\n";
},"20":function(depth0,helpers,partials,data) {
    var stack1, helper, alias1=this.lambda;

  return "								<button data-toggle=\"collapse\" data-ismultiple=\""
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Is_Multiple__c : stack1), depth0)) != null ? stack1 : "")
    + "\" data-parent=\"#accordionForm\" href=\"javascript:void(0)\" role=\"button\" data-index=\""
    + this.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\" class=\"btn btn-info next-step-form-accordion\" data-id=\""
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\">\n									Next\n								</button>\n";
},"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
    var stack1;

  return "\n<div class=\"panel-group\" id=\"accordionForm\" role=\"tablist\" aria-multiselectable=\"true\">\n"
    + ((stack1 = helpers.each.call(depth0,depth0,{"name":"each","hash":{},"fn":this.program(1, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "</div>\n";
},"usePartial":true,"useData":true});
this["base"]["templates"]["input_form_main"] = Handlebars.template({"1":function(depth0,helpers,partials,data) {
    var stack1;

  return "		<legend>"
    + this.escapeExpression(this.lambda(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Name : stack1), depth0))
    + "</legend>\n"
    + ((stack1 = helpers['if'].call(depth0,(depth0 != null ? depth0.hasInstructions : depth0),{"name":"if","hash":{},"fn":this.program(2, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers.unless.call(depth0,(depth0 != null ? depth0.doNotShowForm : depth0),{"name":"unless","hash":{},"fn":this.program(4, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers['if'].call(depth0,((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Is_Multiple__c : stack1),{"name":"if","hash":{},"fn":this.program(6, data, 0),"inverse":this.program(8, data, 0),"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers.unless.call(depth0,(depth0 != null ? depth0.doNotShowForm : depth0),{"name":"unless","hash":{},"fn":this.program(10, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "");
},"2":function(depth0,helpers,partials,data) {
    var stack1;

  return "			<div class=\"row\">\n				<div class=\"col-md-12\">\n					<pre class=\"clean-formatted-text line-breaks well well-default\">"
    + ((stack1 = this.lambda(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Instructions__c : stack1), depth0)) != null ? stack1 : "")
    + "</pre>\n				</div>\n			</div>\n";
},"4":function(depth0,helpers,partials,data) {
    var stack1, alias1=this.lambda;

  return "		 <form data-validate-parsley=\"true\" id=\""
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\" class=\"form-pages-template\" data-multiple=\""
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Is_Multiple__c : stack1), depth0)) != null ? stack1 : "")
    + "\">\n";
},"6":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = this.invokePartial(partials['types/input_form_multiple.js'],depth0,{"name":"types/input_form_multiple.js","data":data,"indent":"\t\t\t\t","helpers":helpers,"partials":partials})) != null ? stack1 : "")
    + "			";
},"8":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = this.invokePartial(partials['types/input_form_basic.js'],depth0,{"name":"types/input_form_basic.js","data":data,"helpers":helpers,"partials":partials})) != null ? stack1 : "")
    + "\n";
},"10":function(depth0,helpers,partials,data) {
    return "		 </form>\n";
},"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
    var stack1;

  return "<div class=\"well well--default\">\n"
    + ((stack1 = helpers.each.call(depth0,depth0,{"name":"each","hash":{},"fn":this.program(1, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "</div>\n";
},"usePartial":true,"useData":true});
this["base"]["templates"]["input_form_wizard"] = Handlebars.template({"1":function(depth0,helpers,partials,data) {
    var stack1, helper, alias1=helpers.helperMissing, alias2="function", alias3=this.escapeExpression, alias4=this.lambda;

  return "								<li id=\"li-"
    + alias3(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : alias1),(typeof helper === alias2 ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\" data-id=\""
    + ((stack1 = alias4(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\">\n									<a href=\"#tab-"
    + alias3(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : alias1),(typeof helper === alias2 ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\" data-toggle=\"tab\" class=\"disabled\" data-id=\""
    + ((stack1 = alias4(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\">\n"
    + ((stack1 = helpers['if'].call(depth0,(data && data.first),{"name":"if","hash":{},"fn":this.program(2, data, 0),"inverse":this.program(4, data, 0),"data":data})) != null ? stack1 : "")
    + "										  <span class=\"step\">"
    + alias3((helpers.add || (depth0 && depth0.add) || alias1).call(depth0,(data && data.index),1,{"name":"add","hash":{},"data":data}))
    + "</span>\n										  <span class=\"step-description\">\n										    "
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Name : stack1), depth0))
    + "\n										  </span>\n										</div>\n									</a>\n								</li>\n";
},"2":function(depth0,helpers,partials,data) {
    var helper;

  return "											<div class=\"col-sm-12 wizard-progression bg-primary\" data-progress=\"step-"
    + this.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\">\n";
},"4":function(depth0,helpers,partials,data) {
    var helper;

  return "													<div class=\"col-sm-12 wizard-progression default\" data-progress=\"step-"
    + this.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\">\n";
},"6":function(depth0,helpers,partials,data) {
    var stack1, helper, alias1=this.escapeExpression, alias2=this.lambda;

  return "									<div class=\"tab-pane fade in\" id=\"tab-"
    + alias1(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\">\n\n										<legend>"
    + alias1(alias2(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Name : stack1), depth0))
    + "</legend>\n"
    + ((stack1 = helpers['if'].call(depth0,(depth0 != null ? depth0.hasInstructions : depth0),{"name":"if","hash":{},"fn":this.program(7, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "										<form data-validate-parsley=\"true\" id=\""
    + ((stack1 = alias2(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\" class=\"form-pages-template\" data-multiple=\""
    + ((stack1 = alias2(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Is_Multiple__c : stack1), depth0)) != null ? stack1 : "")
    + "\">\n"
    + ((stack1 = helpers['if'].call(depth0,((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Is_Multiple__c : stack1),{"name":"if","hash":{},"fn":this.program(9, data, 0),"inverse":this.program(11, data, 0),"data":data})) != null ? stack1 : "")
    + "										</form>\n									</div>\n";
},"7":function(depth0,helpers,partials,data) {
    var stack1;

  return "											<div class=\"row\">\n												<div class=\"col-md-12\">\n													<pre class=\"clean-formatted-text line-breaks well p-0\">"
    + ((stack1 = this.lambda(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Instructions__c : stack1), depth0)) != null ? stack1 : "")
    + "</pre>\n												</div>\n											</div>\n";
},"9":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = this.invokePartial(partials['types/input_form_multiple.js'],depth0,{"name":"types/input_form_multiple.js","data":data,"indent":"\t\t\t\t\t\t\t\t\t\t\t\t","helpers":helpers,"partials":partials})) != null ? stack1 : "");
},"11":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = this.invokePartial(partials['types/input_form_basic.js'],depth0,{"name":"types/input_form_basic.js","data":data,"indent":"\t\t\t\t\t\t\t\t\t\t\t\t","helpers":helpers,"partials":partials})) != null ? stack1 : "");
},"13":function(depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return "										<div class=\"row\">\n											<div class=\"col-md-12\">\n												<pre class=\"clean-formatted-text well well-default m-b-30\">"
    + ((stack1 = (helpers.showInstructions || (depth0 && depth0.showInstructions) || helpers.helperMissing).call(depth0,depths[1],{"name":"showInstructions","hash":{},"data":data})) != null ? stack1 : "")
    + "</pre>\n											</div>\n										</div>\n";
},"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=helpers.helperMissing, alias2=this.escapeExpression;

  return "<div class=\"row\">\n	<div class=\"col-sm-12  well well--form-wizard\">\n		<div class=\"row\">\n			<div id=\"formBSWizard\">\n				<div class=\"col-sm-3 col-md-2 col-xs-12\">\n					<div class=\"row\">\n						<div class=\"col-sm-12 visible-xs\">\n							<div class=\"step--line\">\n						    <div class=\"line\"></div>\n						  </div>\n						</div>\n						<ul>\n"
    + ((stack1 = helpers.each.call(depth0,depth0,{"name":"each","hash":{},"fn":this.program(1, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "							<li id=\"li-review\" data-id=\"li-review\">\n								<a href=\"#tab-review\" data-toggle=\"tab\" class=\"disabled\" data-id=\"form-review\">\n									<div class=\"col-sm-12 wizard-progression default\" data-progress=\"step-"
    + alias2(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : alias1),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\">\n										<span class=\"step\">"
    + alias2((helpers.add || (depth0 && depth0.add) || alias1).call(depth0,(depth0 != null ? depth0.length : depth0),1,{"name":"add","hash":{},"data":data}))
    + "</span>\n										<span class=\"step-description\">\n											Review\n										</span>\n									</div>\n								</a>\n							</li>\n						</ul>\n					</div>\n				</div>\n				<div class=\"col-sm-9 col-md-10 col-xs-12\">\n					<div class=\"row\">\n						<div class=\"col-sm-12\">\n							<div class=\"tab-content well p-t-0\">\n"
    + ((stack1 = helpers.each.call(depth0,depth0,{"name":"each","hash":{},"fn":this.program(6, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "								<div class=\"tab-pane fade\" id=\"tab-review\">\n									<div class=\"row\">\n										<div class=\"col-sm-12\">\n										    <legend class=\"legend-h1\">Review</legend>\n										</div>\n									</div>\n"
    + ((stack1 = (helpers.if_instructions || (depth0 && depth0.if_instructions) || alias1).call(depth0,depth0,{"name":"if_instructions","hash":{},"fn":this.program(13, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "									<span id=\"wizard-results\">\n									</span>\n								</div>\n								<ul class=\"pager wizard\">\n									<li class=\"previous\"><a href=\"#\" class=\"btn btn-default\">Previous</a></li	>\n							  	<li class=\"next\"><a href=\"#\" class=\"btn btn-info\">Next</a></li>\n									<li class=\"next finish\">\n										<button class=\"btn btn-success ladda-button\" role=\"button\" data-style=\"expand-right\"><span class=\"ladda-label\">Submit</span></button>\n									</li>\n								</ul>\n							</div>\n						</div>\n					</div>\n				</div>\n			</div>\n		</div>\n	</div>\n</div>\n\n<script>\nvar currentIndex;\nvar indexSubmitted = null;\n$(document).ready(function() {\n	$(document).on('click','.jump-tabs',function(e){\n		$('#formBSWizard').bootstrapWizard('show',$(this).data(\"index\"));\n	});\n	$('#formBSWizard').bootstrapWizard({\n        onNext: function (tab, navigation, index) {\n            if ($('#formBSWizard').bootstrapWizard.results) {\n                if ($('#formBSWizard').bootstrapWizard.results.errors.length === 0) {\n                    var previous = index - 1;\n                    $('#li-' + previous + ' .wizard-progression').removeClass('bg-primary').addClass('bg-success');\n                    $('#li-' + index + ' .wizard-progression').removeClass('default').addClass('bg-primary');\n                    return true;\n                }\n                else {\n                    return false;\n                }\n            }\n						currentIndex = index;\n						if (indexSubmitted != null && currentIndex === indexSubmitted) {\n							   //TODO\n						}\n						else {\n            var formId = tab[0].attributes['data-id'].value;\n            var formObj = $('#' + formId);\n            if (!formObj.data('multiple')) {\n                var parsleyForm = formObj.parsley({ excluded: \"input[type=button], input[type=submit], input[type=reset], input[type=hidden], input:hidden, textarea:hidden, select:hidden\"});\n                if (parsleyForm.validate()) {\n                    formObj.serializeObject(formId, function (err, result) {\n                        if (formObj[0].id !== 'li-review') {\n                            formResults[formObj[0].id] = result;\n                        }\n\n                        saveResponsesFromWizard($('#formBSWizard'));\n												indexSubmitted = index;\n                    });\n                    return false;\n                }\n                else {\n                    return false;\n                }\n            } else {\n                var previous = index - 1;\n                $('#li-' + previous + ' .wizard-progression').removeClass('bg-primary').addClass('bg-success');\n                $('#li-' + index + ' .wizard-progression').removeClass('default').addClass('bg-primary');\n            }\n					}\n        },\n        onInit : function(tab, navigation, index) {\n			total = navigation.find('li').length\n			if (total >= 6) {\n				$('.wizard-progression').addClass('truncate');\n				$('.well.well--form-wizard .step--line .line').css({\"border-width\": \"3px\", \"height\": \"3px\"})\n			}\n		},\n		onFinish : function(tab,navigation,index) {\n			var formId = tab[0].attributes['data-id'].value;\n			var formObj = $('#'+formId);\n			if (!formObj.data('multiple')) {\n				var parsleyForm = formObj.parsley({ excluded: \"input[type=button], input[type=submit], input[type=reset], input[type=hidden], input:hidden, textarea:hidden, select:hidden\"});\n				if (parsleyForm.validate()) {\n					formObj.serializeObject(formId,function(err,result){\n						if (formObj[0].id !== 'li-review') {\n							formResults[formObj[0].id] = result;\n						}\n						wizardComplete = true;\n						saveResponsesFromWizard(undefined, true);\n					});\n				}\n			}\n			$('#li-review .wizard-progression').removeClass('bg-primary').addClass('bg-success');\n		},\n		onPrevious: function(tab, navigation, index) {\n			var count = index+1;\n			$('#li-'+index+' .wizard-progression').removeClass('bg-success').addClass('bg-primary');\n			$('#li-'+count+' .wizard-progression').removeClass('bg-primary').addClass('default');\n		},\n		onTabShow: function(tab, navigation, index) {\n			var $total = navigation.find('li').length;\n			var $current = index+1;\n			if($current >= $total) {\n				$('#li-review .wizard-progression').removeClass('default').addClass('bg-primary');\n				$('#formBSWizard').find('.pager .next').hide();\n				$('#formBSWizard').find('.pager .finish').show();\n				$('#formBSWizard').find('.pager .finish').removeClass('disabled');\n				var template = base.templates['input_form_wizard_review'];\n				console.log(componentNamespace[wizardNamespace].formGroupObj);\n				var resultsObj = {\n					fieldGroups : componentNamespace[wizardNamespace].formGroupObj,\n					formResults : formResults\n				};\n				$('#wizard-results').html(template(resultsObj));\n			} else {\n				$('#li-review .wizard-progression').removeClass('bg-primary').addClass('default');\n				$('#formBSWizard').find('.pager .next').show();\n				$('#formBSWizard').find('.pager .finish').hide();\n			}\n		}\n	});\n});\n</script>\n";
},"usePartial":true,"useData":true,"useDepths":true});
this["base"]["templates"]["input_form_wizard_review"] = Handlebars.template({"1":function(depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=this.escapeExpression, alias2=helpers.helperMissing;

  return "    <div class=\"row\">\n        <div class=\"col-xs-8 col-sm-9\">\n            <legend class=\"no-border\">"
    + alias1(this.lambda(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Name : stack1), depth0))
    + "</legend>\n"
    + ((stack1 = (helpers.eachInMap || (depth0 && depth0.eachInMap) || alias2).call(depth0,((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1),(depths[1] != null ? depths[1].formResults : depths[1]),{"name":"eachInMap","hash":{},"fn":this.program(2, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = (helpers.eachInMapMultiple || (depth0 && depth0.eachInMapMultiple) || alias2).call(depth0,((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1),(depths[1] != null ? depths[1].formResults : depths[1]),{"name":"eachInMapMultiple","hash":{},"fn":this.program(6, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "        </div>\n        <div class=\"col-xs-4 col-sm-3 text-right\">\n            <button class=\"btn btn-default jump-tabs\" data-index=\""
    + alias1(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : alias2),(typeof helper === "function" ? helper.call(depth0,{"name":"index","hash":{},"data":data}) : helper)))
    + "\">\n                Edit\n            </button>\n        </div>\n        <div class=\"col-sm-12\">\n            <hr class=\"m-t-5\" />\n        </div>\n    </div>\n";
},"2":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = helpers.each.call(depth0,depth0,{"name":"each","hash":{},"fn":this.program(3, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "");
},"3":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = helpers.unless.call(depth0,(depth0 != null ? depth0.isHidden : depth0),{"name":"unless","hash":{},"fn":this.program(4, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "");
},"4":function(depth0,helpers,partials,data) {
    var stack1, alias1=this.lambda;

  return "                    <div class=\"m-b-5\">\n                        <p class=\"m-0\">"
    + ((stack1 = alias1((depth0 != null ? depth0.fieldName : depth0), depth0)) != null ? stack1 : "")
    + "</p>\n                        <p class=\"m-0\"><label>"
    + this.escapeExpression(alias1((depth0 != null ? depth0.value : depth0), depth0))
    + "</label></p>\n                    </div>\n";
},"6":function(depth0,helpers,partials,data) {
    var stack1, alias1=this.lambda;

  return "            <div class=\"row\">\n    <div class=\"col-sm-12 m-t-15\">\n        <div class=\"table-responsive no-border\">\n            <table class=\"table table-default\" id=\"multiple-entries-table-"
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\">\n                <tbody id=\"multiple-entries-"
    + ((stack1 = alias1(((stack1 = (depth0 != null ? depth0.sobj : depth0)) != null ? stack1.Id : stack1), depth0)) != null ? stack1 : "")
    + "\">\n\n\n"
    + ((stack1 = helpers.each.call(depth0,(depth0 != null ? depth0.multiple : depth0),{"name":"each","hash":{},"fn":this.program(7, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "                     </tbody>\n                            </table>\n        </div>\n    </div>\n</div>\n";
},"7":function(depth0,helpers,partials,data) {
    var stack1;

  return "                <tr>\n                    <td class=\"col-sm-8\">\n"
    + ((stack1 = helpers.each.call(depth0,(depth0 != null ? depth0.responses : depth0),{"name":"each","hash":{},"fn":this.program(8, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "                    </td>\n                </tr>\n";
},"8":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = helpers.unless.call(depth0,(depth0 != null ? depth0.isHidden : depth0),{"name":"unless","hash":{},"fn":this.program(9, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "");
},"9":function(depth0,helpers,partials,data) {
    var stack1, alias1=this.lambda;

  return "                                <div class=\"row m-b-10\">\n                                    <div class=\"col-sm-12 col-md-3\">\n                                        <strong>"
    + ((stack1 = alias1((depth0 != null ? depth0.fieldName : depth0), depth0)) != null ? stack1 : "")
    + "</strong>\n                                    </div>\n                                    <div class=\"col-sm-12 col-md-9\">\n                                        "
    + ((stack1 = alias1((depth0 != null ? depth0.value : depth0), depth0)) != null ? stack1 : "")
    + "\n                                    </div>\n                                </div>\n";
},"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = helpers.each.call(depth0,(depth0 != null ? depth0.fieldGroups : depth0),{"name":"each","hash":{},"fn":this.program(1, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "");
},"useData":true,"useDepths":true});
this["base"]["templates"]["input_multiple_table"] = Handlebars.template({"1":function(depth0,helpers,partials,data,blockParams,depths) {
    var stack1, alias1=this.lambda;

  return "	<tr>\n		<td class=\"col-sm-8\">\n"
    + ((stack1 = helpers.each.call(depth0,(depth0 != null ? depth0.responses : depth0),{"name":"each","hash":{},"fn":this.program(2, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "")
    + "		</td>\n		<td class=\"col-sm-4 text-right\">\n			<a href=\"#\" class=\"btn btn-default btn-icon edit-multiple-entry\" data-fieldGroupId=\""
    + ((stack1 = alias1((depths[1] != null ? depths[1].fieldGroupId : depths[1]), depth0)) != null ? stack1 : "")
    + "\" data-id=\""
    + ((stack1 = alias1((depth0 != null ? depth0.id : depth0), depth0)) != null ? stack1 : "")
    + "\">\n				<i class=\"btr bt-pencil\"></i>\n			</a>\n	    <a href=\"#\" class=\"btn btn-default btn-icon delete-multiple-entry\" data-fieldGroupId=\""
    + ((stack1 = alias1((depths[1] != null ? depths[1].fieldGroupId : depths[1]), depth0)) != null ? stack1 : "")
    + "\" data-id=\""
    + ((stack1 = alias1((depth0 != null ? depth0.id : depth0), depth0)) != null ? stack1 : "")
    + "\">\n				<i class=\"btr bt-trash\"></i>\n			</a>\n		</td>\n	</tr>\n";
},"2":function(depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = helpers.unless.call(depth0,(depth0 != null ? depth0.isHidden : depth0),{"name":"unless","hash":{},"fn":this.program(3, data, 0),"inverse":this.noop,"data":data})) != null ? stack1 : "");
},"3":function(depth0,helpers,partials,data) {
    var stack1, alias1=this.lambda;

  return "				 	<div class=\"row m-b-10\">\n						<div class=\"col-sm-12 col-md-3\">\n							<strong>"
    + ((stack1 = alias1((depth0 != null ? depth0.fieldName : depth0), depth0)) != null ? stack1 : "")
    + "</strong>\n						</div>\n						<div class=\"col-sm-12 col-md-9\">\n							"
    + ((stack1 = alias1((depth0 != null ? depth0.value : depth0), depth0)) != null ? stack1 : "")
    + "\n						</div>\n					</div>\n";
},"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = helpers.each.call(depth0,(depth0 != null ? depth0.multiple : depth0),{"name":"each","hash":{},"fn":this.program(1, data, 0, blockParams, depths),"inverse":this.noop,"data":data})) != null ? stack1 : "");
},"useData":true,"useDepths":true});