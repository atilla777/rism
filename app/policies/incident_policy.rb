class IncidentPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[discovered_at
       discovered_time
       started_at
       started_time
       finished_at
       finished_time
       closed_at
       event_description
       investigation_description
       action_description
       severity
       damage
       state]
  end

  class Scope < Scope
    def resolve
        scope.all
    end
  end
end
