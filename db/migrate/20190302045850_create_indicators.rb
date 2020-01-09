class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE indicator_purpose
          AS ENUM (
            'not_set', 'for_detect', 'for_prevent'
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
            'not_set', 'low', 'high'
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
            'filename', 'filesize', 'process', 'account', 'email_theme', 'email_content', 'uri', 'domain', 'email_author', 'other', 'network_service', 'network', 'network_port', 'email_adress', 'md5', 'sha256', 'sha512'
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
      t.references :parent, table: :indicators, index: true
      t.boolean :parent_conjunction
      t.column :trust_level, 'indicator_trust_level', default: 'not_set'
      t.string :content
      t.column :content_format, 'indicator_content_format'
      t.column :purpose, 'indicator_purpose', default: 'not_set'
      t.text:description
      t.jsonb :custom_fields
      t.jsonb :enrichment, null: false, default: '{}'

      t.references :created_by,  index: true, foreign_key: false
      t.references :updated_by,  index: true, foreign_key: false

      t.timestamps
    end

    add_index :indicators, :custom_fields, using: :gin
    add_index :indicators, 'content gin_trgm_ops', using: :gin
  end
end
