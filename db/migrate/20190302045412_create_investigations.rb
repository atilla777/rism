class CreateInvestigations < ActiveRecord::Migration[5.1]
  def change
    create_table :investigations do |t|
      t.string :name
      t.string :custom_codename
      t.references :organization, foreign_key: true
      t.references :investigation_kind, foreign_key: true
      t.references :feed, foreign_key: true
      t.jsonb :custom_fields
      t.text :description

      t.references :created_by,  index: true, foreign_key: false
      t.references :updated_by,  index: true, foreign_key: false

      t.timestamps
    end

    add_index  :investigations, :custom_fields, using: :gin
  end
end
