class AddOrganizationToRights < ActiveRecord::Migration[5.1]
  def change
    add_reference :rights, :organization, foreign_key: true
  end
end
