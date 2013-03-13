// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require jquery.ui.slider
//= require jquery.ui.datepicker-pl
//= require jquery-ui-timepicker-addon
//= require localization/jquery-ui-timepicker-pl
//= require twitter/bootstrap
//= require_tree .


$(document).ready(function() {

  $(".datepicker").datepicker({ dateFormat: "dd/mm/yy" });
  $(".datetimepicker").datetimepicker({ dateFormat: "dd/mm/yy" });
  $("#reservation-form").change(function() {
    var params = $(this).serialize();
    var fetch_rooms_url = $(this).data("room-url");
    $.ajax({
        url: fetch_rooms_url,
        dataType: 'script',
        data: params,
        type: "GET",
        complete: function(jqXHR) {
            if(jqXHR.status == 500 || jqXHR.status == 404 || jqXHR.status == 403) {
                errorHandling(jqXHR.status);
            } else {
              $("#available-rooms-container").html(jqXHR.responseText);
            }
        }
    });
  });
  $("#new-block-form").change(function() {
    var params = $(this).serialize();
    var fetch_rooms_url = $(this).data("preview-url");
    $.ajax({
        url: fetch_rooms_url,
        dataType: 'script',
        data: params,
        type: "GET",
        complete: function(jqXHR) {
            if(jqXHR.status == 500 || jqXHR.status == 404 || jqXHR.status == 403) {
                errorHandling(jqXHR.status);
            } else {
              $("#schedules-container").html(jqXHR.responseText);
            }
        }
    });
  });
});

function errorHandling(error) {
    // TODO improve it a bit for example own modal with some help info.
    alert(error);
}
