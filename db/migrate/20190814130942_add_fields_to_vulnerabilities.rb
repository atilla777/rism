class AddFieldsToVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    add_column :vulnerabilities, :custom_published, :datetime
    add_column  :vulnerabilities, :custom_published_time, :boolean, default: false # is time in custom_published present?
    add_column :vulnerabilities, :custom_codenames, :text, array: true, default: []

    add_index  :vulnerabilities, :custom_codenames, using: :gin
  end
end
