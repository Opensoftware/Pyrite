function refresh_groups_timetable(params) {
  var fetch_timetable_url = $("#block_group_ids").data("timetable-url");
  busyBoxOn($("#groups-timetable"));
  fetch_blocks(fetch_timetable_url, params);
  busyBoxOff($("#groups-timetable"));
}

function refresh_room_timetable(params) {
  var fetch_timetable_url = $("#block_room_id").data("timetable-url");
  busyBoxOn($("#room-timetable"));
  fetch_blocks(fetch_timetable_url, params);
  busyBoxOff($("#room-timetable"));
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
