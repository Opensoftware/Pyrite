$(document).ready(function() {

  $("#year_for_viewing, #year_for_editing").on("change", function() {
    var url = $("form").data("fetch-url");
    var element_to_update = $($(this).data("update"));
    var data = { academic_year_id: $(this).val() }
    $.get(url, data, 'script')
      .done(function(data) {
        element_to_update.html(data);
      });
    });

});

