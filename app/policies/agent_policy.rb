class AgentPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         organization_id
         address
         hostname
         port
         secret
         description]
  end
end
