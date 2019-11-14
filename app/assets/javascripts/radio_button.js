$(document).on('turbolinks:load', function() {
  $(".chb").change(function(){
      $(".chb").prop('checked',false);
      $(this).prop('checked',true);
  });
});
