$('#session-days.carousel').slick({
    arrows: true,
    slidesToShow: 2,
    slidesToScroll: 1,
    responsive: [
    {
      breakpoint: 480,
      settings: {
        slidesToShow: 1,
        slidesToScroll: 1
      }
    }
  ]
});

$(document).ready(function(){
    $(document).on('shown.bs.tab','#my_agenda_tab,#agenda_tab,#agenda', function(e) {
       $('#session-days').resize();
    });
});

//Single



$('#btnRSVPClose').on('click',function(){
    if($('#rsvp-default').css('display')!='none'){
     $('#rsvp-success').show().siblings('div').hide();
   }else if($('#rsvp-success').css('display')!='none'){
        $('#rsvp-default').show().siblings('div').hide();
    }
});

$('#btnRSVPContactClose').on('click',function(){
    $('#rsvpContactsModal').modal('toggle')
    if($('#rsvp-default').css('display')!='none'){
     $('#rsvp-group-success').show().siblings('div').hide();
   }else if($('#rsvp-group-success').css('display')!='none'){
        $('#rsvp-default').show().siblings('div').hide();
    }
});

$('#btnRSVPSingleContactClose').on('click',function(){
    $('#rsvpSingleContactsModal').modal('toggle')
    if($('#rsvp-default').css('display')!='none'){
     $('#rsvp-success').show().siblings('div').hide();
   }else if($('#rsvp-success').css('display')!='none'){
        $('#rsvp-default').show().siblings('div').hide();
    }
});


//Multiple

$('#btnContactListConfirm').on('click',function(){
    if($('#rsvpContactList').css('display')!='none'){
     $('#rsvpContactConfirmReadOnly').show().siblings('div').hide();
     $('#rsvpContactList > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpContactConfirmReadOnly').css('display')!='none'){
        $('#rsvpContactList').show().siblings('div').hide();
        $('#rsvpContactList > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnContactListEdit').on('click',function(){
    if($('#rsvpContactList').css('display')!='none'){
     $('#rsvpContactConfirmReadOnly').show().siblings('div').hide();
     $('#rsvpContactConfirmReadOnly > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpContactConfirmReadOnly').css('display')!='none'){
        $('#rsvpContactList').show().siblings('div').hide();
        $('#rsvpContactList > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnFollowupClose').on('click',function(){
    $('#rsvpContactsModal').modal('toggle')
    if($('#rsvp-default').css('display')!='none'){
     $('#rsvp-success').show().siblings('div').hide();
   }else if($('#rsvp-success').css('display')!='none'){
        $('#rsvp-default').show().siblings('div').hide();
    }
});

//Others

$('#btnContactListOthers').on('click',function(){
    if($('#rsvpContactAddOthers').css('display')!='none'){
     $('#rsvpContactList').show().siblings('div').hide();
     $('#rsvpContactList > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpContactList').css('display')!='none'){
        $('#rsvpContactAddOthers').show().siblings('div').hide();
        $('#rsvpContactAddOthers > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnContactOthersBack').on('click',function(){
    if($('#rsvpContactList').css('display')!='none'){
     $('#rsvpContactAddOthers').show().siblings('div').hide();
     $('#rsvpContactAddOthers > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpContactAddOthers').css('display')!='none'){
        $('#rsvpContactList').show().siblings('div').hide();
        $('#rsvpContactList > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnContactOthersConfirm').on('click',function(){
    if($('#rsvpContactAddOthers').css('display')!='none'){
     $('#rsvpContactOthersReadOnly').show().siblings('div').hide();
     $('#rsvpContactOthersReadOnly > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpContactOthersReadOnly').css('display')!='none'){
        $('#rsvpContactAddOthers').show().siblings('div').hide();
        $('#rsvpContactAddOthers > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnContactOthersEdit').on('click',function(){
    if($('#rsvpContactAddOthers').css('display')!='none'){
     $('#rsvpContactOthersReadOnly').show().siblings('div').hide();
     $('#rsvpContactOthersReadOnly > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpContactOthersReadOnly').css('display')!='none'){
        $('#rsvpContactAddOthers').show().siblings('div').hide();
        $('#rsvpContactAddOthers > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnFollowupOthersSummaryClose').on('click',function(){
    $('#rsvpContactsModal').modal('toggle')
    if($('#rsvp-default').css('display')!='none'){
     $('#rsvp-success').show().siblings('div').hide();
   }else if($('#rsvp-success').css('display')!='none'){
        $('#rsvp-default').show().siblings('div').hide();
    }
});


//Schedule


$('#btnRSVPSchedule').on('click',function(){
    if($('#rsvpContactList').css('display')!='none'){
     $('#rsvpSchedule').show().siblings('div').hide();
     $('#rsvpSchedule > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpSchedule').css('display')!='none'){
        $('#rsvpContactList').show().siblings('div').hide();
        $('#rsvpContactList > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnRSVPScheduleBack').on('click',function(){
    if($('#rsvpContactList').css('display')!='none'){
     $('#rsvpSchedule').show().siblings('div').hide();
     $('#rsvpSchedule > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpSchedule').css('display')!='none'){
        $('#rsvpContactList').show().siblings('div').hide();
        $('#rsvpContactList > .modal-body').addClass('animated fadeIn');
    }
});



$('#btnRSVPReview').on('click',function(){
    if($('#rsvpSchedule').css('display')!='none'){
     $('#rsvpScheduleReview').show().siblings('div').hide();
     $('#rsvpScheduleReview > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpScheduleReview').css('display')!='none'){
        $('#rsvpSchedule').show().siblings('div').hide();
        $('#rsvpSchedule > .modal-body').addClass('animated fadeIn');
    }
});

////////////////

$('#btnRSVPReviewBack').on('click',function(){
    if($('#rsvpScheduleReview').css('display')!='none'){
     $('#rsvpSchedule').show().siblings('div').hide();
     $('#rsvpSchedule > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpSchedule').css('display')!='none'){
        $('#rsvpScheduleReview').show().siblings('div').hide();
        $('#rsvpScheduleReview > .modal-body').addClass('animated fadeIn');
    }
});


$('#btnContactOthersSchedule').on('click',function(){
    if($('#rsvpContactAddOthers').css('display')!='none'){
     $('#rsvpSchedule').show().siblings('div').hide();
     $('#rsvpSchedule > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpSchedule').css('display')!='none'){
        $('#rsvpContactAddOthers').show().siblings('div').hide();
        $('#rsvpContactAddOthers > .modal-body').addClass('animated fadeIn');
    }
});

////////////////


$('#btnRSVPSingleSchedule').on('click',function(){
    if($('#rsvpSingleContactList').css('display')!='none'){
     $('#rsvpSingleSchedule').show().siblings('div').hide();
     $('#rsvpSingleSchedule > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpSingleSchedule').css('display')!='none'){
        $('#rsvpSingleContactList').show().siblings('div').hide();
        $('#rsvpSingleContactList > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnRSVPSingleScheduleBack').on('click',function(){
    if($('#rsvpSingleContactList').css('display')!='none'){
     $('#rsvpSingleSchedule').show().siblings('div').hide();
     $('#rsvpSingleSchedule > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpSingleSchedule').css('display')!='none'){
        $('#rsvpSingleContactList').show().siblings('div').hide();
        $('#rsvpSingleContactList > .modal-body').addClass('animated fadeIn');
    }
});


////////

$('#btnRSVPSingleReview').on('click',function(){
    if($('#rsvpSingleSchedule').css('display')!='none'){
     $('#rsvpSingleScheduleReview').show().siblings('div').hide();
     $('#rsvpSingleScheduleReview > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpScheduleReview').css('display')!='none'){
        $('#rsvpSchedule').show().siblings('div').hide();
        $('#rsvpSchedule > .modal-body').addClass('animated fadeIn');
    }
});

$('#btnRSVPSingleReviewBack').on('click',function(){
    if($('#rsvpSingleScheduleReview').css('display')!='none'){
     $('#rsvpSingleSchedule').show().siblings('div').hide();
     $('#rsvpSingleSchedule > .modal-body').addClass('animated fadeIn');
   }else if($('#rsvpSingleSchedule').css('display')!='none'){
        $('#rsvpSingleScheduleReview').show().siblings('div').hide();
        $('#rsvpSingleScheduleReview > .modal-body').addClass('animated fadeIn');
    }
});
