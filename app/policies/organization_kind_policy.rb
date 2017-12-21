class OrganizationKindPolicy < ApplicationPolicy
  def permitted_attributes
    if user.admin_editor?
      %i[name
         description]
    end
  end
end
