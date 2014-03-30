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
//= require jquery-1.10.2
//= require jquery-ui-1.10.4.custom
//= require bootstrap/js/bootstrap
//= require fullcalendar/fullcalendar.min
//= require jquery.busybox

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
  $(".datepicker, .datetimepicker, .timepicker").datepicker("destroy");
  $(".datepicker").datepicker({ dateFormat: "yy-mm-dd" });
  $(".datetimepicker").datetimepicker({ dateFormat: "yy-mm-dd, HH:mm", stepMinute: 15 });
  $(".timepicker").timepicker({ timeFormat: "HH:mm", stepMinute: 15 });
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

