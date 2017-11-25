class DepartmentPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         parent_id
         organization_id
         rank
         description]
  end


  def select?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def reset?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def paste?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end
end
