class CreateVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :vulnerabilities do |t|
      t.string :codename
      t.text :vendors, array: true, default: []
      t.text :products, array: true, default: []
      t.text :cwe, array: true, default: []
      t.jsonb :versions, null: false, default: '{}'
      t.jsonb :cpe, null: false, default: '{}'
      t.decimal :cvss3, precision: 3, scale: 1
      t.string :cvss3_vector
      t.decimal :cvss3_exploitability, precision: 3, scale: 1
      t.decimal :cvss3_impact, precision: 3, scale: 1
#      t.integer :av
#      t.integer :ac
#      t.integer :pr
#      t.integer :ui
#      t.integer :s
#      t.integer :c
#      t.integer :i
#      t.integer :a
#      t.integer :e
#      t.integer :rl
#      t.integer :rc
#      t.integer :cr
#      t.integer :ir
#      t.integer :ar
      t.decimal :cvss2, precision: 3, scale: 1
      t.string :cvss2_vector
      t.decimal :cvss2_exploitability, precision: 3, scale: 1
      t.decimal :cvss2_impact, precision: 3, scale: 1
      t.text :references, array: true, default: []
      t.integer :feed
      t.string :feed_description, array: true, default: []
      t.string :description
      t.datetime :published
      t.boolean :published_time, default: false
      t.datetime :modified
      t.boolean :modified_time, default: false
      t.boolean :unread, default: false

      t.timestamps
    end

    add_index  :vulnerabilities, :published
    add_index  :vulnerabilities, :modified
    add_index  :vulnerabilities, :codename, unique: true
    add_index  :vulnerabilities, :vendors, using: :gin
    add_index  :vulnerabilities, :products, using: :gin
    add_index  :vulnerabilities, :versions, using: :gin
    add_index  :vulnerabilities, :cpe, using: :gin
    add_index  :vulnerabilities, :cwe, using: :gin
    add_index  :vulnerabilities, :feed_description, using: :gin
  end
end
