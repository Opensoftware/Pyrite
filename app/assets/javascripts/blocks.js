// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {
  $("#block_group_ids").on("change", function() {
    alert("request new plan for groups");
  });

  $("#block_room").on("change", function() {
    alert("request new plan for rooms");
  });

  $("#block_event").on("change", function() {
    alert("refresh both plans");
  });
});
