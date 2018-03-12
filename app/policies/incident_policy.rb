class IncidentPolicy < ApplicationPolicy

  # TODO: allow view onlu for user who is allowed to view
  # organizations linked to incident

  def index?
    return true if @user.admin_editor_reader?
    @user.can? :read, Incident
  end

  def create?
    return true if @user.admin_editor?
    @user.can? :edit, Incident
  end

  def permitted_attributes
    %i[name
       discovered_at
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
