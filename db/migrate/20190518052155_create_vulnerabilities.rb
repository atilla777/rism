class CreateVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :vulnerabilities do |t|
      t.string :codename
      t.text :vendors, array: true, default: []
      t.text :products, array: true, default: []
      t.jsonb :versions, null: false, default: '{}'
      t.integer :cpe
      t.string :cvss3
      t.string :cvss3_vector
      t.text :references, array: true, default: []
      t.integer :feed
      t.string :feed_description, array: true, default: []
      t.string :description
      t.datetime :published
      t.boolean :published_time, default: false

      t.timestamps
    end

    add_index  :vulnerabilities, :codename, unique: true
    add_index  :vulnerabilities, :vendors, using: :gin
    add_index  :vulnerabilities, :products, using: :gin
    add_index  :vulnerabilities, :versions, using: :gin
    add_index  :vulnerabilities, :feed_description, using: :gin
  end
end
