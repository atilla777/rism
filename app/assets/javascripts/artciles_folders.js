$(document).on('turbolinks:load', function() {
  $('#selectAllArticles').click(function() {
    if (this.checked) {
      $('input[id^="article_ids_"]').each(function() {
        this.checked = true;
      });
    } else {
     $('input[id^="article_ids_"]').each(function() {
        this.checked = false;
      });
    }
  });

  $('#selectAllArticlesFolders').click(function() {
   if (this.checked) {
     $('input[id^="articles_folder_ids_"]').each(function() {
       this.checked = true;
     });
   } else {
    $('input[id^="articles_folder_ids_"]').each(function() {
       this.checked = false;
     });
   }
  });
});
