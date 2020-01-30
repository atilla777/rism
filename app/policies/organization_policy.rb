class OrganizationPolicy < ApplicationPolicy
  def permitted_attributes
    %i[name codename full_name parent_id organization_kind_id description]
  end

  class Scope < Scope
    def resolve
      if user.admin_editor_reader?
        scope.all
      elsif user.can_read_model_index?(scope)
        scope.all
      else
        scope.where(
          id: user.allowed_organizations_ids(scope)
        )
      end
    end
  end
end
