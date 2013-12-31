function refresh_group_timetable() {
  var fetch_timetable_url = $("#block_group_ids").data("timetable-url");
  var group_ids_value = $("#block_group_ids").val();
  if(group_ids_value != null) {
    var params = {group_ids: group_ids_value };
    busyBoxOn($("#group-timetable"));
    fetch_blocks(fetch_timetable_url, params);
    busyBoxOff($("#group-timetable"));
  }
}

$(document).ready(function() {
  refresh_group_timetable();
  $("#block_group_ids").on("change", function() {
    refresh_group_timetable();
  });
});
