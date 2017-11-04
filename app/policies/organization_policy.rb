class OrganizationPolicy < ApplicationPolicy
  def permitted_attributes
    %i[name parent_id kind description]
  end

  class Scope < Scope
    def resolve
      if user.admin_editor_reader?
        scope.all
      else
        scope.where(id: user.allowed_organizations_ids)
      end
    end
  end
end
