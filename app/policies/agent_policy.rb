# frozen_string_literal: true

class AgentPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
      %i[name
         organization_id
         address
         protocol
         hostname
         port
         secret
         description]
  end
end
