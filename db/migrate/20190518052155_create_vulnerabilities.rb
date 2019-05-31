class CreateVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE vuln_feed
          AS ENUM ('custom', 'nvd');
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE vuln_feed;
        SQL
      end

      change.up do
        execute <<-SQL
          CREATE TYPE vuln_actuality
          AS ENUM ('not_set', 'actual', 'not_actual');
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE vuln_actuality;
        SQL
      end

      change.up do
        execute <<-SQL
          CREATE TYPE vuln_relevance
          AS ENUM ('not_set', 'relevant', 'not_relevant');
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE vuln_relevance;
        SQL
      end
    end
    create_table :vulnerabilities do |t|
      # manual or from NVD json
      t.string :codename
      t.column  :feed, 'vuln_feed', default: 'custom'
      t.text :vendors, array: true, default: []
      t.text :products, array: true, default: []
      t.text :cwe, array: true, default: []
      t.decimal :cvss3, precision: 3, scale: 1
      t.string :cvss3_vector
      t.decimal :cvss3_exploitability, precision: 3, scale: 1
      t.decimal :cvss3_impact, precision: 3, scale: 1
      t.decimal :cvss2, precision: 3, scale: 1
      t.string :cvss2_vector
      t.decimal :cvss2_exploitability, precision: 3, scale: 1
      t.decimal :cvss2_impact, precision: 3, scale: 1
      t.string :description, array: true, default: []
      t.datetime :published
      t.boolean :published_time, default: false # is time in published present?
      t.datetime :modified
      t.boolean :modified_time, default: false # is time in modified present?
      # not from NVD json
      t.text :custom_description
      t.text :custom_recomendation
      t.text :custom_references
      t.jsonb :custom_fields
      t.integer :state, limit: 1 # is vuln old (readed), new published (unreadead) or modified (unreaded)?
      t.column :custom_actuality, 'vuln_actuality', default: 'not_set'
      t.column :actuality, 'vuln_actuality', default: 'not_set' # automatic set - is vuln applicable tu us by criticality and vector?
      t.column :custom_relevance, 'vuln_relevance', default: 'not_set'
      t.column :relevance, 'vuln_relevance', default: 'not_set' # automatic set - is vuln applicable to us by vendor and (or) product?
      #t.boolean :custom_relevance, default: false # manual set
      #t.boolean :custom_actuality, default: false # manual set
      t.boolean :blocked, default: false # is vuln created from automatic sync from NVD base?
      t.jsonb :raw_data, null: false, default: '{}'

      t.timestamps
    end

    add_index  :vulnerabilities, :codename, unique: true
    add_index  :vulnerabilities, :vendors, using: :gin
    add_index  :vulnerabilities, :products, using: :gin
    add_index  :vulnerabilities, :cwe, using: :gin
    add_index  :vulnerabilities, 'cvss3_vector gin_trgm_ops', using: :gin
    add_index  :vulnerabilities, 'cvss2_vector gin_trgm_ops', using: :gin
    add_index  :vulnerabilities, :description, using: :gin

    add_index  :vulnerabilities, 'custom_description gin_trgm_ops', using: :gin
    add_index  :vulnerabilities, :published, order: {published: :desc}
    add_index  :vulnerabilities, :modified, order: {published: :desc}
  end
end
