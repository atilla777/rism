class AddFieldsToHostService < ActiveRecord::Migration[5.1]
  def change
    add_reference :host_services, :host_service_status, foreign_key: true
    add_column :host_services, :host_service_status_changed_at, :datetime
  end
end
