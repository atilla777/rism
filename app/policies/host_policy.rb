class HostPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         to_hosts
         ip
         organization_id
         description]
  end

  def new_import?
    create?
  end

  def create_import?
    create?
  end

  def toggle_readable?
    index?
  end

  def run?
    create?
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
        puts user.allowed_organizations_ids(scope)
        scope.where(
          organization_id: user.allowed_organizations_ids(scope)
        )
      end
    end
  end
end
