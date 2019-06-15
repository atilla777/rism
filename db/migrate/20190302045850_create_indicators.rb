class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE indicator_purpose
          AS ENUM (
            #{Indicator.purposes.values.map {|i| "'#{i}'"}.join(', ')}
          )
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
          AS ENUM (
            #{Indicator.trust_levels.values.map {|i| "'#{i}'"}.join(', ')}
          )
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE indicator_trust_level;
        SQL
      end

      change.up do
        execute <<-SQL
          CREATE TYPE indicator_content_format
          AS ENUM (
            #{Indicator.content_formats.values.map {|i| "'#{i}'"}.join(', ')}
          );
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE indicator_content_format;
        SQL
      end
    end

    create_table :indicators do |t|
      t.references :investigation, foreign_key: true
      t.column :trust_level, 'indicator_trust_level', default: 'not_set'
      t.string :content
      t.column :content_format, 'indicator_content_format'
      t.column :purpose, 'indicator_purpose', default: 'not_set'
      t.text:description
      t.jsonb :custom_fields
      t.jsonb :enrichment, null: false, default: '{}'

      t.references :created_by,  index: true, foreign_key: {to_table: :users}
      t.references :updated_by,  index: true, foreign_key: {to_table: :users}

      t.timestamps
    end

    add_index :indicators, :enrichment, using: :gin
    add_index :indicators, :custom_fields, using: :gin
    add_index :indicators, 'content gin_trgm_ops', using: :gin
  end
end
