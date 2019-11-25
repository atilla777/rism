class CreateEnrichments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrichments do |t|
      t.jsonb :content, null: false, default: {}
      t.references :enrichmentable, polymorphic: true
      t.integer :broker, limit: 2
      t.datetime :created_at
    end
  end
end
