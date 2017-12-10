class AddAgreementKindToAgreement < ActiveRecord::Migration[5.1]
  def change
    add_reference :agreements, :agreement_kind, foreign_key: true
  end
end
