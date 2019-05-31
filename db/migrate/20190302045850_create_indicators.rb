class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE indicator_purpose
          AS ENUM ('not_set', 'for_detect', 'for_prevent');
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE indicator_purpose;
        SQL
      end

      change.up do
        execute <<-SQL
          CREATE TYPE indicator_trust_level
          AS ENUM ('not_set', 'low', 'high');
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE indicator_trust_level;
        SQL
      end
    end

    create_table :indicators do |t|
      t.references :user, foreign_key: true
      t.references :investigation, foreign_key: true
      t.column :trust_level, 'indicator_trust_level', default: 'not_set'
      t.string :content
      t.integer :content_format, limit: 1
      t.column :purpose, 'indicator_purpose', default: 'not_set'
      t.text:description
      t.jsonb :enrichment, null: false, default: '{}'

      t.timestamps
    end

    add_index  :indicators, :enrichment, using: :gin
    add_index :indicators, 'content gin_trgm_ops', using: :gin
  end
end
