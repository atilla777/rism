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

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin_editor_reader?
        scope.all
      else
        ids = user.allowed_organizations_ids
        scope.where(organization_id: ids)
             .or(scope.where(contractor_id: ids))
      end
    end
  end
end
