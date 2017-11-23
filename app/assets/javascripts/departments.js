$(document).on('turbolinks:load', function() {
  $('#selectAllUsers').click(function() {
    if (this.checked) {
      $('input[id^="user_ids_"]').each(function() {
        this.checked = true;
      });
    } else {
     $('input[id^="user_ids_"]').each(function() {
        this.checked = false;
      });
    }
  });

  $('#selectAllDepartments').click(function() {
   if (this.checked) {
     $('input[id^="department_ids_"]').each(function() {
       this.checked = true;
     });
   } else {
    $('input[id^="department_ids_"]').each(function() {
       this.checked = false;
     });
   }
  });
});
