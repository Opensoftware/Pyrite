function refresh_group_timetable() {
  var fetch_timetable_url = $("#block_group_ids").data("timetable-url");
  var group_ids_value = $("#block_group_ids").val();
  var event_id = $("#block_event_id").val();
  if(group_ids_value != null) {
    var params = {group_ids: group_ids_value, event_id: event_id };
    busyBoxOn($("#groups-timetable"));
    fetch_blocks(fetch_timetable_url, params);
    busyBoxOff($("#groups-timetable"));
  }
}

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
