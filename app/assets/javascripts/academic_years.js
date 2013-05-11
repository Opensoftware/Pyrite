$(document).ready(function() {
  bindEditAcademicYearEventButton();
  bindRemoveAcademicYearEvent();
  $("#submit-academic-year-event-form").click(function() {
    bindAjaxAcademicYearEventForm();
    $(this).parent().parent().find("form").submit();
  });
});

function bindAjaxAcademicYearEventForm() {
  $("#new_academic_year_event, #edit_academic_year_event").bind("ajax:success", function(evt, data, status, xhr) {
    $("#academic-year-events-list").html(data);
    $("#academic-year-events-modal").modal('hide');
    bindEditAcademicYearEventButton();
    bindRemoveAcademicYearEvent();
  });
}

function bindEditAcademicYearEventButton() {
  $(".button-edit-academic-year-event, #button-new-academic-year-event").bind("ajax:success", function(evt, data, status, xhr) {
    $("#academic-year-events-modal .modal-body").html(data);
    $("#academic-year-events-modal").modal();
    $(".datepicker").datepicker({ dateFormat: "yy-mm-dd" });
    bindAjaxAcademicYearEventForm();
  });
}

function bindRemoveAcademicYearEvent() {
  $(".button-remove-academic-year-event").bind("ajax:success", function(evt, data, status, xhr) {
    $(this).closest("tr").remove();
  })
}
