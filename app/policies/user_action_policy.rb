class UserActionPolicy < ApplicationPolicy
  def permitted_attributes
      %i[]
  end

  def user_actions_dashboard?
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
        scope.joins(:user)
          .merge(
            User.where(
              organization_id: user.allowed_organizations_ids('User')
            )
          )
      end
    end
  end
end
