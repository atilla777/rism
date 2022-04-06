# frozen_string-literal: true

class CommentPolicy < ApplicationPolicy
  #include RecordPolicy

  def permitted_attributes
    %i[parent_id
       commentable_id
       commentable_type
       parent_id]
  end

  def create?
    return true if @user.admin_editor?
    @user.can?(:read, @record.commentable) && @user.can?(:edit, Comment)
  end
  
  def update?
    destroy?
  end

  def destroy?
    return true if @user.admin_editor?
    @user.can?(:read, @record.commentable) && @user.can?(:edit, Comment) && @user == @record.user
  end
  

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
