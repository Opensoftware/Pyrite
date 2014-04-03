$(document).ready(function() {
  refresh_timetables();

  $("#block_group_ids").on("change", function() {
    refresh_groups_if_value_exists();
  });

  $("#block_room_id").on("change", function() {
    refresh_room_if_value_exists();
  });

  $("#block_meeting_id").on("change", function() {
    refresh_timetables();
    refresh_days();
  });
  $("#edit-block-submit-button").on("click", function() {
    $("#modal-edit-block form").submit();
    $("#modal-edit-block").modal("hide");
    return false;
  });
});

function refresh_days() {
  var meeting_id = $("#block_meeting_id").val();
  var params = { meeting_id: meeting_id };
  $.ajax({
      url: $("#block_day_with_date").data("refresh"),
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

function prepareRoomParams() {
  var room_id_value = $("#block_room_id").val();
  var meeting_id = $("#block_meeting_id").val();
  var params = {id: room_id_value, meeting_id: meeting_id};
  if(room_id_value.length > 0) {
    return params
  } else {
    return null
  }
}

function prepareGroupsParams() {
  var group_ids_value = $("#block_group_ids").val();
  var meeting_id = $("#block_meeting_id").val();
  var params = {group_ids: group_ids_value, meeting_id: meeting_id };
  if(group_ids_value != null) {
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

function refresh_groups_if_value_exists() {
  var params = prepareGroupsParams();
  if ( params != null ) {
    refresh_groups_timetable(params);
  }
}

function refresh_timetables() {
  refresh_room_if_value_exists();
  refresh_groups_if_value_exists();
}
