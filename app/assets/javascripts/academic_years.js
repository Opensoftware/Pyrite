$(document).ready(function() {
  bindAcademicYearFetchButton();
  bindRemoveAcademicYearElement();
  $("#submit-academic-year-form").on("click", function() {
    $(this).parent().parent().find("form").submit();
  });
});

function bindAcademicYearForm() {
  $("#academic-year-modal .modal-dialog .modal-body form").on("ajax:success", function(evt, data, status, xhr) {
    $("#list-container").html(data);
    $("#academic-year-modal").modal('hide');
    setActiveTabForAcademicYear(this);
    bindAcademicYearFetchButton();
    bindRemoveAcademicYearElement();
  }).on("ajax:error", function(xhr, txt, error) {
    $("#academic-year-modal .modal-errors").html(txt.responseText);
  });
}

function bindAcademicYearFetchButton() {
  $(".academic-year-fetch-form").on("ajax:success", function(evt, data, status, xhr) {
    var modal_header = $(this).data("modal-header");
    $("#academic-year-modal .modal-header h3").html(modal_header);
    $("#academic-year-modal .modal-errors").html("");
    $("#academic-year-modal .modal-body").html(data);
    $("#academic-year-modal").modal();
    reloadDatepicker();
    bindAcademicYearForm();
  });
}

function bindRemoveAcademicYearElement() {
  $(".button-remove-academic-year-element").on("ajax:success", function(evt, data, status, xhr) {
    var refresh = $(this).data("refresh");
    if ( refresh != "undefined") {
      $("#list-container").html(data);
      setActiveTabForAcademicYear(this);
      bindAcademicYearFetchButton();
      bindRemoveAcademicYearElement();
    } else {
      $(this).closest("tr").remove();
    }
  })
}

function setActiveTabForAcademicYear(element) {
  var active_tab = $(element).data("active-tab");
  $("#academic-year-tabs a:first").tab("show")
  if ( active_tab != "undefined" ) {
    $(active_tab).tab("show");
  }
}
