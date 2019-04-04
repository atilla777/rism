class IndicatorPolicy < ApplicationPolicy

  def permitted_attributes
    %i[
      user_id
      investigation_id
      content
      indicators_list
      ioc_kind
      danger
      trust_level
    ]
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
        scope.includes(:investigation)
             .where(investigation: {organization_id: user.allowed_organizations_ids})
      end
    end
  end
end
