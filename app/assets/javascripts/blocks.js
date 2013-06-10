// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {
  $("#block_group_ids").on("change", function() {
    alert("request new plan for groups");
  });

  $("#block_room_id").on("change", function() {
    var fetch_timetable_url = $(this).data("timetable-url");
    var room_id_value = $(this).val();
    var params = {id: room_id_value };
    var loading = $("#room-timetable").busyBox({
      spinner:  '<img src="/assets/loading.gif">'
    });
    $.ajax({
        url: fetch_timetable_url,
        dataType: 'script',
        data: params,
        type: "GET",
        complete: function(jqXHR) {
            loading.busyBox('close');
            if(jqXHR.status == 500 || jqXHR.status == 404 || jqXHR.status == 403) {
                errorHandling(jqXHR.status);
            }
        }
    });
  });

  $("#block_event").on("change", function() {
    alert("refresh both plans");
  });
});
