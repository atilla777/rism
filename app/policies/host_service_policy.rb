class HostServicePolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         port
         protocol
         legality
         organization_id
         host_id
         description]
  end
end
