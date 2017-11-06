class DepartmentPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         parent_id
         organization_id
         description]
  end
end
