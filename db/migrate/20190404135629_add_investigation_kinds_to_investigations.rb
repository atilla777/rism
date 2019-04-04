class AddInvestigationKindsToInvestigations < ActiveRecord::Migration[5.1]
  def change
    add_reference :investigations, :investigation_kind, foreign_key: true
  end
end
