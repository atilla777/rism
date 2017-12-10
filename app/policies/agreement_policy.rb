class AgreementPolicy < ApplicationPolicy
  def permitted_attributes
      %i[prop
         beginning
         organization_id
         contractor_id
         agreement_kind_id
         duration
         prolongation
         description]
  end
end
