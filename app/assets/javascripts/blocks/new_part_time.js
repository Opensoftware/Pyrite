$(document).ready(function() {
  refresh_room_if_value_exist();
  refresh_groups_if_value_exist();

  $("#block_group_ids").on("change", function() {
    refresh_groups_if_value_exist();
  });

  $("#block_room_id").on("change", function() {
    refresh_room_if_value_exist();
  });

  $("#block_meeting_id").on("change", function() {
    refresh_room_if_value_exist();
    refresh_groups_if_value_exist();
  });
  $("#edit-block-submit-button").on("click", function() {
    $("#modal-edit-block form").submit();
    $("#modal-edit-block").modal("hide");
    return false;
  });
});

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

function refresh_room_if_value_exist() {
  var params = prepareRoomParams();
  if ( params != null ) {
    refresh_room_timetable(params);
  }
}

function refresh_groups_if_value_exist() {
  var params = prepareGroupsParams();
  if ( params != null ) {
    refresh_groups_timetable(params);
  }
}
