$(document).ready(function() {
  refresh_timetables();

  $("#block_group_ids").on("change", function() {
    refresh_groups_if_value_exists();
  });

  $("#block_room_ids").on("change", function() {
    refresh_room_if_value_exists();
  });

  $("#block_event_id").on("change", function() {
    reset_date = true;
    refresh_timetables(reset_date);
  });

  $("#block_meeting_id").on("change", function() {
    reset_date = true;
    refresh_timetables(reset_date);
  });

  $("#new-block-submit-button").on("click", function() {
    sendRequestToCreateNewBlock();
  });

  $("#new-block-form-modal").submit(function(e) {
    e.preventDefault();
  });

  $("#block_group_ids").on("select2-selecting", function(e) {
    if(e.choice.css == "group_category") {
      // TODO we could do it better
      // we are + "" to get always a string, in some case when there is just one
      // number data will parse it and return integer and then split will fail.
      group_ids = ($(e.choice.element).data("group-ids") + "").split(",");
      selected_options = $(this).select2("val");
      options = $.merge(selected_options, group_ids);
      $(this).select2("val", options);
      $(this).select2("close");
      refresh_groups_if_value_exists();
      e.preventDefault();
    }
  });
  bindSelect2($("#block_group_ids"));
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
            $("#modal-new-block").modal("hide");
          }
      }
  });
}

function prepareRoomParams(reset_date) {
  var room_ids_value = $("#block_room_ids").val();
  var basic_params = prepareParams(reset_date);
  var room_params = {room_ids: room_ids_value};
  var params = $.extend({}, basic_params, room_params);
  if(room_ids_value != null ) {
    return params
  } else {
    return null
  }
}

function prepareGroupsParams(reset_date) {
  var group_ids_value = $("#block_group_ids").val();
  var basic_params = prepareParams(reset_date);
  var group_params = {group_ids: group_ids_value };
  var params = $.extend({}, basic_params, group_params);
  if(group_ids_value != null) {
    return params
  } else {
    return null
  }
}

function prepareParams(reset_date) {
  var event_id = $("#block_event_id").val();
  var params = {};
  if ( reset_date == true ){
    params = $.extend( params, { reset_date: true });
  }
  if ( event_id != undefined ) {
    params = $.extend( params, { event_id: event_id });
  }
  var meeting_id = $("#block_meeting_id").val();
  if ( meeting_id != undefined ) {
    params = $.extend( params, { meeting_id: meeting_id });
  }
  return params;
}

function refresh_room_if_value_exists(reset_date) {
  var params = prepareRoomParams(reset_date);
  if ( params != null ) {
    refresh_room_timetable(params);
  }
}

function refresh_groups_if_value_exists(reset_date) {
  var params = prepareGroupsParams(reset_date);
  if ( params != null ) {
    refresh_groups_timetable(params);
  }
}

function refresh_timetables(reset_date) {
  refresh_room_if_value_exists(reset_date);
  refresh_groups_if_value_exists(reset_date);
}
