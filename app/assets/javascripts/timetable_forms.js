$(document).ready(function() {
  $("#show-group-timetable-form").on("submit", function() {
    timetable_url = $("#group_id").val();
    window.location.href = timetable_url;
    return false;
  });
});
