class HostPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         ip
         organization_id
         description]
  end
end
