function toggleDayInput() {
  // if event is empty we allow for setting date for block
  // if event is present the the block will be added to the date range from
  // event for choosen day.
  var event_id_value = $("#block_event_id").val();
  if ( event_id_value.length > 0 ) {
    $("#block_day").show();
    $("#block_day_with_date").hide();
  } else {
    $("#block_day").hide();
    $("#block_day_with_date").show();
  }
  reloadDatepicker();
}

$(document).ready(function() {
  toggleDayInput();
  refresh_timetables();

  $("#block_event_id").on("change", function() {
    toggleDayInput();
    refresh_timetables();
  });

  $("#block_room_id, #block_day_with_date").on("change", function() {
    refresh_room_if_value_exists();
  });

  $("#edit-block-submit-button").on("click", function() {
    $("#modal-edit-block form").submit();
    $("#modal-edit-block").modal("hide");
    return false;
  });

});

function prepareRoomParams() {
  var room_id_value = $("#block_room_id").val();
  var event_id = $("#block_event_id").val();
  var params = {id: room_id_value, event_id: event_id};
  if(room_id_value.length > 0) {
    return params
  } else {
    return null
  }
}

function refresh_room_if_value_exists() {
  var params = prepareRoomParams();
  if ( params != null ) {
    refresh_room_timetable(params);
  }
}

function refresh_timetables() {
  refresh_room_if_value_exists();
}
