var requirePassword = false;

$(function(){
  $(document).on('click','.new-user-login-button',function(event){
    passwordValidator(event);
  });
  $(document).on('keyup','.password-input',function(event){
    passwordValidator(event);
  });
  $(document).on('change','.create-account-checkbox',function(event) {
    passwordValidator(event);
    event.preventDefault();
    if($(this).prop("checked")) {
      $('#password').show('slow');
      requirePassword = true;
    } else {
      $('#password').hide('slow');
      requirePassword = false;
    }
  });
});

function parsleyInit() {
  $('.login-component-form').parsley();
}

function passwordValidator(event) {
  var passwordInput = $('.password-input');
  var parsleyPasswordObj = passwordInput.parsley();
  window.ParsleyUI.removeError(parsleyPasswordObj,"passwordValidationError");
  if (requirePassword) {
    if (requirePassword && passwordInput.val().length < 8) {
      event.preventDefault();
      window.ParsleyUI.addError(parsleyPasswordObj, "passwordValidationError",parsleyInvalidPasswordMessage);
    }
  }
}
function userAlreadyExistsAlert(userAlreadyExists) {
  var specificField = $('.email-guest-new-user').parsley();
  if (userAlreadyExists) {
    swal({
        title: userExistsTitle,
        text: userExistsMessage,
        type: "error",
        showCancelButton: true,
        confirmButtonColor: primary_color,
        confirmButtonText: swalConfirmButtonText,
        cancelButtonText: swalCancelButtonText,
        closeOnConfirm: true,
        closeOnCancel: true
      },
      function(isConfirm){
        if (isConfirm) {
          location.reload(true);
        } else {
          $(".email-guest-new-user").focus();
          $(".email-guest-new-user").select();
          window.ParsleyUI.removeError(specificField,"emailExistsError");
          window.ParsleyUI.addError(specificField,"emailExistsError",parsleyEmailExistsMessage);
        }
      });
  } else {
    window.ParsleyUI.removeError(specificField, "emailExistsError");
  }
}

//Animation for positioning after collapse
$(function () {
    $('#accordionCheckout').on('shown.bs.collapse', function (e) {
        var offset = $('.panel.panel-default > .panel-collapse.in').offset();
        if(offset) {
            $('html,body').animate({
                scrollTop: $('.panel-heading > .panel-title').offset().top -50
            }, 250);
        }
    });
});

$(function() {
  $('#newDirectDebit, #existingDirectDebit').click(function() {
    var cb1 = $('#newDirectDebit').is(':checked');
    var cb2 = $('#existingDirectDebit').is(':checked');
    $('#newName, #newEmail, #newAccountNumber, #newSortCode, #newFullAddress, #newDate, #instructions, label[for="instructions"], label[for="newName"], label[for="newEmail"], label[for="newAccountNumber"], label[for="newName"], label[for="newSortCode"], label[for="newFullAddress"], label[for="newDate"]').toggleClass("disable").prop('disabled', !cb1);
    $('#existingAccount, label[for="existingAccount"]').toggleClass("disable").prop('disabled', !cb2);
  });
});

$('input#quantity').keypress(function(e) {
    var a = [];
    var k = e.which;

    for (i = 48; i < 58; i++)
        a.push(i);

    if (!($.inArray(k,a)>=0))
        e.preventDefault();
});
