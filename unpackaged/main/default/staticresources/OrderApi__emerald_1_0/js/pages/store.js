var $checkout   = $(".checkout-footer"),
    $window    = $(window),
    offset     = $checkout.offset();

$window.scroll(function() {
    if ($window.scrollTop() > offset.top-($window.height()/4)) {
        $checkout.addClass('checkout-reveal');
    } else {
        $checkout.removeClass('checkout-reveal');
    }
});
