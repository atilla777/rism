$(document).on('turbolinks:load', function() {
  console.log('sdf');
  $("#message").toggle( "blind", 1000);
  return false;
});
