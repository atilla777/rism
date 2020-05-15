class CreatePublications < ActiveRecord::Migration[5.1]
  def change
    create_table :publications do |t|
      t.references :publicable, polymorphic: true
      t.datetime :created_at
    end
  end
end
