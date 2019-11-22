$(document).on('turbolinks:load', function() {
  $('.modal_link').on('click', function(e){
    e.preventDefault();
    $('#modal_window').modal('show').find('.modal-body').empty().load($(this).attr('href'));
  });
});

