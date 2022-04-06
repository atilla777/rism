# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def permitted_attributes
      %i[
        name
        parent_id
        organization_id
        user_id
        description
        start
        planned_end
        real_end
        task_status_id
        task_priority_id
        current_description
        custom_description
        user_description
      ]
  end

  def toggle_readable?
    index?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin_editor_reader?
        scope.all
      elsif user.can_read_model_index?(scope)
        scope.all
      else
        scope.where(organization_id: user.allowed_organizations_ids(scope))
      end
    end
  end
end
