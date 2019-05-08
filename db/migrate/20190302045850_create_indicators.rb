class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    create_table :indicators do |t|
      t.references :user, foreign_key: true
      t.references :investigation, foreign_key: true
      t.integer :trust_level
      t.string :content
      t.integer :content_kind
      t.text:content_subkinds
      t.boolean :danger
      t.text:description
      t.jsonb :enrichment, null: false, default: '{}'

      t.timestamps
    end

    add_index  :indicators, :enrichment, using: :gin
    add_index :indicators, :content, using: :gin, order: {content: :gin_trgm_ops}
  end
end
