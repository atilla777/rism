class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    create_table :indicators do |t|
      t.references :user, foreign_key: true
      t.references :investigation, foreign_key: true
      t.integer :ioc_kind
      t.integer :trust_level
      t.string :content
      t.jsonb :enrichment, null: false, default: '{}'

      t.timestamps
    end

    add_index  :indicators, :enrichment, using: :gin
  end
end
