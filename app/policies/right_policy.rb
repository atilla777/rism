class RightPolicy < ApplicationPolicy
  def index?
    return true if @user.admin?
    false
  end

  def show?
    return true if @user.admin?
    scope.where(id: record.id).exists?
  end

  def create?
    return true if @user.admin?
    false
  end

  def new?
    create?
  end

  def update?
    return true if @user.admin?
    false
  end

  def edit?
    update?
  end

  def destroy?
    return true if @user.admin?
    false
  end

  def permitted_attributes
    %i[organization_id level role_id subject_id subject_type]
  end
end
