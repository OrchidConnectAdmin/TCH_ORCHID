$(document).ready(function() {
	$(".drawer-content").hide();
	$(".chosen-select").chosen();
});

function toggleReceiptsHandler() {
    if( $('.drawer-content').is(':hidden') ) {
        toggleReceiptsDrawer();
    }
    else {
    	$('.drawer-content').slideToggle();
    	$('#collapse-icon').toggleClass('icon-collapse-top');
			$('#collapse-icon').toggleClass('icon-collapse');
    }
}

function toggleCallback() {
  $('.drawer-content').slideToggle();
	$('#collapse-icon').toggleClass('icon-collapse-top');
	$('#collapse-icon').toggleClass('icon-collapse');
}

function checkOutstandingInvoices() {
	if ( $('#oInvoicesTable > tbody > tr').length > 0) {
		oInvoicesPagination();
		$('#invoiceModal').modal('show');
	}
}

function oInvoicesPagination() {
	$('#oInvoicesTable').tableNav({
		itemsPerPage : 4,
		childSelector : 'tbody tr',
		showAdditionalControls : true,
		hideWhenOnePage : false
	});
}

function redrawPagination() {
	$('#receiptTable').tableNav({
	    itemsPerPage: 4,
	    childSelector: 'tbody tr',
	    showAdditionalControls: true,
	    hideWhenOnePage: false
	});
}

function fullReset() {
  $(".drawer-content").hide();
	$(".chosen-select").chosen();
}

/**
 * Old JS for validation
 */

// $('form.mainForm').bootstrapValidator({
 //        message: 'Invalid input or required field value missing',
 //        fields: {
 //            reference_number__c : {
 //                message: 'Reference number (Check or CC Transaction number) is required.',
 //                validators: {
 //                    notEmpty: {
 //                        message: 'Reference number is a required field'
 //                    }
 //                }
 //            }
 //        }
 //    });