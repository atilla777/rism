class RightPolicy < ApplicationPolicy
  def index?
    return true if @user.admin?
    false
  end

  def show?
    index?
    #scope.where(id: record.id).exists?
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    index?
  end

  def permitted_attributes
    %i[organization_id level role_id subject_id subject_type]
  end
end
