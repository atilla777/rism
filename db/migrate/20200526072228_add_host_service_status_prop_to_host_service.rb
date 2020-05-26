class AddHostServiceStatusPropToHostService < ActiveRecord::Migration[5.1]
  def change
    add_column :host_services, :host_service_status_prop, :string

    add_index :host_services, :host_service_status_prop
  end
end
