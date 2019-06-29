class CreateSearchFilters < ActiveRecord::Migration[5.1]
  def change
    create_table :search_filters do |t|
      t.string :name
      t.string :filtred_model
      t.references :organization, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :shared
      t.integer :rank
      t.jsonb :content
      t.text :description

      t.timestamps
    end
  end
end
