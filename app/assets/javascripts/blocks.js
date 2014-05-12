function refresh_groups_timetable(params) {
  var fetch_timetable_url = $("#block_group_ids").data("timetable-url");
  busyBoxOn($("#groups-timetable-container"));
  fetch_blocks(fetch_timetable_url, params);
  busyBoxOff($("#groups-timetable-container"));
}

function refresh_room_timetable(params) {
  var fetch_timetable_url = $("#block_room_id").data("timetable-url");
  busyBoxOn($("#room-timetable-container"));
  fetch_blocks(fetch_timetable_url, params);
  busyBoxOff($("#room-timetable-container"));
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

function update_block_position(url, params) {
  $.ajax({
      url: url,
      dataType: 'script',
      data: params,
      type: "PATCH",
      complete: function(jqXHR) {
        if(jqXHR.status == 500 || jqXHR.status == 404 || jqXHR.status == 403) {
            errorHandling(jqXHR.status);
        }
        refresh_timetables();
      }
  });
}

$(document).ready(function() {
  /* bind staff related with modal for edit block */
  $("body").on("shown.bs.modal", ".modal", function() {
    bindChosen();
  });

  /* Edit Block */
  $("#edit-block-submit-button").on("click", function() {
    $("#modal-edit-block form").on('ajax:success', function() {
      $("#modal-edit-block").modal("hide");
    })
    $("#modal-edit-block form").submit();
    return false;
  });
});
