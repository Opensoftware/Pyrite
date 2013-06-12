// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function fetch_blocks(fetch_timetable_url, params) {
  $.ajax({
      url: fetch_timetable_url,
      dataType: 'script',
      data: params,
      type: "GET",
      complete: function(jqXHR) {
          if(jqXHR.status == 500 || jqXHR.status == 404 || jqXHR.status == 403) {
              errorHandling(jqXHR.status);
          }
      }
  });
}

$(document).ready(function() {
  $("#block_group_ids").on("change", function() {
    var fetch_timetable_url = $(this).data("timetable-url");
    var group_ids_value = $(this).val();
    var params = {group_ids: group_ids_value };
    busyBoxOn($("#group-timetable"));
    fetch_blocks(fetch_timetable_url, params);
    busyBoxOff($("#group-timetable"));
  });

  $("#block_room_id").on("change", function() {
    var fetch_timetable_url = $(this).data("timetable-url");
    var room_id_value = $(this).val();
    var params = {id: room_id_value };
    busyBoxOn($("#room-timetable"));
    fetch_blocks(fetch_timetable_url, params);
    busyBoxOff($("#room-timetable"));
  });

  $("#block_event").on("change", function() {
    alert("refresh both plans");
  });
});
