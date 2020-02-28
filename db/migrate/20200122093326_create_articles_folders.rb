class CreateArticlesFolders < ActiveRecord::Migration[5.1]
  def change
    create_table :articles_folders do |t|
      t.string :name
      t.integer :rank
      t.references :organization, foreign_key: true
      #t.references :parent, table: :departments, index: true
      t.references :parent, table: :article_folders, index: true
      t.text :description

      t.timestamps
    end

    add_foreign_key :articles_folders, :articles_folders, column: :parent_id
    add_index :articles_folders, :name
  end
end
