$(document).ready(function() {
  refresh_timetables();

  $("#block_group_ids").on("change", function() {
    refresh_groups_if_value_exists();
  });

  $("#block_room_id").on("change", function() {
    refresh_room_if_value_exists();
  });

  $("#block_event_id").on("change", function() {
    refresh_timetables();
  });

  $("#block_meeting_id").on("change", function() {
    refresh_timetables();
  });

  $("#new-block-submit-button").on("click", function() {
    sendRequestToCreateNewBlock();
  });

  $("#new-block-form-modal").submit(function(e) {
    e.preventDefault();
  });
});

function sendRequestToCreateNewBlock() {
  form_params = $("#new-block-form-modal").serializeArray();
  form_basic_params = $("#new_block").serializeArray();
  form_basic_params.shift();
  $.ajax({
      url: $("#new_block").attr("action"),
      dataType: 'script',
      data: form_params.concat(form_basic_params),
      type: "POST",
      complete: function(jqXHR) {
          if(jqXHR.status == 500 || jqXHR.status == 404 || jqXHR.status == 403 || jqXHR.status == 422) {
            /* errors will be loaded by the default view direct to the form */
          } else {
            /* send request if ok close modal and refresh tables */
            $("#modal-new-block").modal("hide");
            refresh_timetables();

          }
      }
  });
}

function prepareRoomParams() {
  var room_id_value = $("#block_room_id").val();
  var basic_params = prepareParams();
  var room_params = {id: room_id_value};
  var params = $.extend({}, basic_params, room_params);
  if(room_id_value.length > 0) {
    return params
  } else {
    return null
  }
}

function prepareGroupsParams() {
  var group_ids_value = $("#block_group_ids").val();
  var basic_params = prepareParams();
  var group_params = {group_ids: group_ids_value };
  var params = $.extend({}, basic_params, group_params);
  if(group_ids_value != null) {
    return params
  } else {
    return null
  }
}

function prepareParams() {
  var event_id = $("#block_event_id").val();
  var params = {};
  if ( event_id != undefined ) {
    params = {event_id: event_id };
  }
  var meeting_id = $("#block_meeting_id").val();
  if ( meeting_id != undefined ) {
    params = {meeting_id: meeting_id };
  }
  return params;
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
