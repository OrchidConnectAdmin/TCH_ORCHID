var j$ = jQuery.noConflict();

(function (j$) {

    j$('#invoices').dataTable({
        "aoColumnDefs": [{
                            'bSortable': false,
                            'aTargets': [ 0,1 ]
                        }],
        "aaSorting": [ [6,'desc'], [3,'asc'] ],
        "aLengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
        "bDestroy": true
    });

    j$.format.date.defaultShortDateFormat = "dd/MM/yyyy";
    j$.format.date.defaultLongDateFormat = "dd/MM/yyyy HH:mm:ss";

    j$('.currency').currency();

    j$(".shortDateFormat").each(function (idx, elem) {
        if (j$(elem).is(":input")) {
            j$(elem).val(j$.format.date(j$(elem).val(),j$.format.date.defaultShortDateFormat));
        }
        else {
            j$(elem).text(j$.format.date(j$(elem).text(),j$.format.date.defaultShortDateFormat));
        }
    });

    j$(".longDateFormat").each(function (idx, elem) {
        if (j$(elem).is(":input")) {
            j$(elem).val(j$.format.date(j$(elem).val(),j$.format.date.defaultLongDateFormat));
        }
        else {
            j$(elem).text(j$.format.date(j$(elem).text(),j$.format.date.defaultLongDateFormat));
        }
    });

});

function pageInit () {

    j$('#invoices').dataTable({
        "aoColumnDefs": [{
                            'bSortable': false,
                            'aTargets': [ 0,1 ]
                        }],
        "aaSorting": [ [6,'desc'], [3,'asc'] ],
        "aLengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
        "bDestroy": true
    });

    j$.format.date.defaultShortDateFormat = "dd/MM/yyyy";
    j$.format.date.defaultLongDateFormat = "dd/MM/yyyy HH:mm:ss";

    j$('.currency').currency();

    j$(".shortDateFormat").each(function (idx, elem) {
        if (j$(elem).is(":input")) {
            j$(elem).val(j$.format.date(j$(elem).val(),j$.format.date.defaultShortDateFormat));
        }
        else {
            j$(elem).text(j$.format.date(j$(elem).text(),j$.format.date.defaultShortDateFormat));
        }
    });

    j$(".longDateFormat").each(function (idx, elem) {
        if (j$(elem).is(":input")) {
            j$(elem).val(j$.format.date(j$(elem).val(),j$.format.date.defaultLongDateFormat));
        }
        else {
            j$(elem).text(j$.format.date(j$(elem).text(),j$.format.date.defaultLongDateFormat));
        }
    });

    j$("input.invoice-row:checkbox").click(function () {
        j$(this).closest("tr").toggleClass("active");
    });

    var countChecked = function () {
            var n = j$("input.invoice-row:checked").length;
            j$("#counter").text(n + (n === 1 ? " Invoice is" : " Invoices are") + " selected");
            if (n > 0) {
                if (j$("#actionpanel").is(":hidden")) {
                  j$("#actionpanel").slideDown();
                }
            }
            else {
                if (j$("#actionpanel").is(":hidden") != true) {
                  j$("#actionpanel").slideUp();
                }
            }
    };

    countChecked();

    j$("input.invoice-row[type=checkbox]").on( "change", countChecked );

    j$('input.select-all:checkbox').click(function() {

        j$("#invoices").find("input.invoice-row[type=checkbox]").prop("checked", j$(this).is(":checked"));

        j$('input.invoice-row:checkbox').each(function() {
            if (j$(this).is(":checked")) {
                j$(this).closest('tr').addClass("active");
            }
            else {
                j$(this).closest('tr').removeClass("active");
            }
        });
        countChecked();
    });
}
