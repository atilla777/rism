class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def autocomplete_organization_name?
    index?
  end

  def autocomplete_agreement_prop?
    index?
  end

  def autocomplete_user_name?
    index?
  end

  def index?
    return true if @user.admin_editor_reader?
    @user.can? :read, @record
  end

  def show?
    index?
  end

  def create?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end

  def revert?
    create?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
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
      else
        scope.where(organization_id: user.allowed_organizations_ids)
      end
    end
  end
end
