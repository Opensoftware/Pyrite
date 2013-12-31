function refresh_room_timetable() {
  var fetch_timetable_url = $("#block_room_id").data("timetable-url");
  var room_id_value = $("#block_room_id").val();
  var event_id = $("#block_event_id").val();
  if(room_id_value.length > 0) {
    var params = {id: room_id_value, event_id: event_id};
    busyBoxOn($("#room-timetable"));
    fetch_blocks(fetch_timetable_url, params);
    busyBoxOff($("#room-timetable"));
  }
}

function refresh_group_timetable() {
  var fetch_timetable_url = $("#block_group_ids").data("timetable-url");
  var group_ids_value = $("#block_group_ids").val();
  var event_id = $("#block_event_id").val();
  if(group_ids_value != null) {
    var params = {group_ids: group_ids_value, event_id: event_id };
    busyBoxOn($("#group-timetable"));
    fetch_blocks(fetch_timetable_url, params);
    busyBoxOff($("#group-timetable"));
  }
}

function toggleEventFormForNewBlock() {
  var event_value = $("#block_event_id").val() || "";
  // if event is empty we allow for setting date for block
  // if event is present the the block will be added to the date range from
  // event.
  if(event_value.length == '' ) {
    $("#block_day").val("");
    $("#block_day").prop('disabled', true);
    $("#block_start_date, #block_end_date").removeClass("timepicker");
    $("#block_start_date, #block_end_date").addClass("datetimepicker");
  } else {
    $("#block_day").prop('disabled', false);
    $("#block_start_date, #block_end_date").toggleClass('datetimepicker timepicker');
  }
  reloadDatepicker();
}

$(document).ready(function() {
  toggleEventFormForNewBlock();
  $("#block_group_ids").on("change", function() {
    refresh_group_timetable();
  });

  $("#block_room_id").on("change", function() {
    refresh_room_timetable();
  });

  $("#block_event_id").on("change", function() {
    refresh_room_timetable();
    refresh_group_timetable();
    toggleEventFormForNewBlock();
  });
});
