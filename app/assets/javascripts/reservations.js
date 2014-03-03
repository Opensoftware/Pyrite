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
  refresh_room_timetable();

  $("#block_event_id").on("change", function() {
    toggleDayInput();
    refresh_room_timetable();
  });

  $("#block_room_id, #block_day_with_date").on("change", function() {
    refresh_room_timetable();
  });

  $("#edit-block-submit-button").on("click", function() {
    $("#modal-edit-block form").submit();
    $("#modal-edit-block").modal("hide");
    return false;
  });

});

