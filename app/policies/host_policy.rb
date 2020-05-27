class HostPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         to_hosts
         ip
         organization_id
         description]
  end
end
