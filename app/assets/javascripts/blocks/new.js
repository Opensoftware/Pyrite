$(document).ready(function() {
  refresh_room_timetable();
  refresh_group_timetable();

  $("#block_group_ids").on("change", function() {
    refresh_group_timetable();
  });

  $("#block_room_id").on("change", function() {
    refresh_room_timetable();
  });

  $("#block_event_id").on("change", function() {
    refresh_room_timetable();
    refresh_group_timetable();
  });
  $("#edit-block-submit-button").on("click", function() {
    $("#modal-edit-block form").submit();
    $("#modal-edit-block").modal("hide");
    return false;
  });
});
