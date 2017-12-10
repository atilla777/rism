$(document).on('turbolinks:load', function() {
  $('input[type="file"]').change(function(e){
      var fileName = e.target.files[0].name;
      alert('The file "' + fileName +  '" has been selected.');
  });

});
