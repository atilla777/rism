class ArticlePolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         organization_id
         user_id
         content
         published]
  end

  def download_image?
    show?
  end

  def publicate?
    create?
  end

  def toggle_subscription?
    index?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # ordinar users can read only published articles that belongs to allowed organizations
    def resolve
      if user.admin_editor_reader?
        scope.all
      elsif user.can_read_model_index?(scope)
        scope.all
      else
        scope.where(
          organization_id: user.allowed_organizations_ids(scope, :edit)
        ).or(scope.where(
          organization_id: user.allowed_organizations_ids(scope),
          published: true
        ))
      end
    end
  end
end
