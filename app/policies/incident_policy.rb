# frozen_string_literal: true

class IncidentPolicy < ApplicationPolicy
  # TODO: use or delete
#  def index?
#    return true if @user.admin_editor_reader?
#    @user.can? :read, Incident
#  end
#
#  def create?
#    return true if @user.admin_editor?
#    @user.can? :edit, Incident
#  end

  def search?
    index?
  end

  def permitted_attributes
    %i[
      name
      organization_id
      user_id
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
      state
    ] << {
      links_attributes: %i[
        link_kind_id
        second_record_id
        second_record_type
        description
        nested
      ]
    }
  end
end
