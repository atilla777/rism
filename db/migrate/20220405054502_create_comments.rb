class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.references :user, foreign_key: true
      t.references :parent, foreign_key: {to_table: :comments}
      
      t.text :content

      t.timestamps
    end
  end
end
