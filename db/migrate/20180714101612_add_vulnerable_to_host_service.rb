class AddVulnerableToHostService < ActiveRecord::Migration[5.1]
  def change
    add_column :host_services, :vulnerable, :boolean
    add_column :host_services, :vuln_description, :text
  end
end
