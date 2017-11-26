class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def autocomplete_organization_name?
    return true if @user.admin_editor_reader?
    @user.can? :read, @record
  end

  def index?
    return true if @user.admin_editor_reader?
    @user.can? :read, @record
  end

  def show?
    return true if @user.admin_editor_reader?
    @user.can? :read, @record
    #scope.where(:id => record.id).exists?
  end

  def create?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def new?
    create?
  end

  def update?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def edit?
    update?
  end

  def destroy?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def revert?
    update?
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
