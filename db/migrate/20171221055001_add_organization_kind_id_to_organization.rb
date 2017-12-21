class AddOrganizationKindIdToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_reference :organizations, :organization_kind, foreign_key: true
  end
end
