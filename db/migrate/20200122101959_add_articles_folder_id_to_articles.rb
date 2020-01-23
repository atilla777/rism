class AddArticlesFolderIdToArticles < ActiveRecord::Migration[5.1]
  def change
    add_reference :articles, :articles_folder, foreign_key: true
  end
end
