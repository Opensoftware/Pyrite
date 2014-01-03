$(document).ready(function() {
  $("#show-group-timetable-form, #show-room-timetable-form").on("submit", function() {
    timetable_url = $(this).find("select:first").val();
    window.location.href = timetable_url;
    return false;
  });
});
