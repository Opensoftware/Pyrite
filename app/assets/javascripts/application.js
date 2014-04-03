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
//= require jquery-1.11.0
//= require jquery-ui-1.10.4.custom
//= require rails
//= require bootstrap/js/bootstrap
//= require fullcalendar/fullcalendar
//= require jquery.busybox
//= require bootstrap-datetimepicker
//= require localization/bootstrap-datetimepicker.pl.js

$(document).ready(function() {
  reloadDatepicker();
});

function errorHandling(error) {
    // TODO improve it a bit for example own modal with some help info.
    alert(error);
}

function busyBoxOn(element) {
 var loading = element.busyBox({
   spinner:  '<img src="/assets/loading.gif">'
 });
}

function busyBoxOff(element) {
  element.busyBox('close');
}

function reloadDatepicker() {
  $(".datepicker, .timepicker").datetimepicker("remove");
  $(".datepicker").datetimepicker({ format: "yyyy/mm/dd", startView: 4, minView: 2, autoclose: true, language: 'pl' });
  $(".timepicker").datetimepicker({ format: "hh:ii", minuteStep: 15, autoclose: true, startView: 1, language: 'pl', formatViewType: "time", showMeridian: true });
}

// Defaults for fullcalendar
// TODO: make it configurable from the panel
var fc_defaults = {
  editable: false,
  firstDay: 1,
	header: {
		left: 'prev,next',
		center: '',
		right: ''
	},
	defaultView: 'agendaWeek',
  allDaySlot: false,
  timeFormat: 'H:mm { - H:mm}',
  axisFormat: 'H:mm',
  minTime: 6,
  maxTime: 22,
  slotMinutes: 15,
  contentHeight: 1400
}

$.fn.fullCalendar_with_defaults = function(options) {
  var settings = $.extend({}, fc_defaults, options);
  this.fullCalendar(settings);
};

$('.modal').on('hidden', function() {
  $(this).data('modal').$element.removeData();
})

