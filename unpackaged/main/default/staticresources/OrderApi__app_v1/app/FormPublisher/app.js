Messenger.options = {
    extraClasses: 'fonteva-messenger messenger-fixed messenger-on-bottom',
    theme: 'block',
    maxMessages: 1
}

function msgSuccess(success) {
    Messenger().post({
        message: success,
        hideAfter: 2,
        hideOnNavigate: true
    });
}

function msgError(error) {
    Messenger().post({
        message: error,
        hideAfter: 2,
        hideOnNavigate: true
    });
}

function refreshSort() {
    window.location.reload();
}

$(function() {
    $(".fieldList").sortable({
        connectWith: ".connectedFieldList",
        forceHelperSize: true,
        forcePlaceHolderSize: true,
        placeholder: "field-placeholder",
        items: "li:not(.state-disabled)",
        stop: function(event, ui) {
            updateOrder();
        }
    });
});

$(function() {
    $("#fieldGroupSort").sortable({
        forceHelperSize: true,
        forcePlaceHolderSize: true,
        placeholder: "group-placeholder",
        stop: function(event, ui) {
            updateOrder();
        }
    });
});

$("#fieldGroupSort li, .fieldList li").disableSelection();

(function($) {
    $.fn.serial = function() {
        var array = [];
        var $elem = $(this);
        $elem.each(function(i) {
            var menu = this.id;
            $('li', this).each(function(e) {
                array.push(i + '=' + menu + '/' + i + e + '=' + this.id);
            });
        });
        return array.join('&');
    }
})(jQuery);

function confirmFieldGroupDelete() {      
    return confirm('You are about to delete the field group and all fields contained in the field group! Please confirm you would like to proceed.');
}

function confirmFieldDelete() {      
    return confirm('Are you sure you want to delete this field?');
}