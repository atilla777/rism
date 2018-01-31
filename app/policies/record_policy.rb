# Specific access check for record that not
# belongs to organization
module RecordPolicy
  def create?
    return true if @user.admin_editor?
    false
  end

  def update?
    return true if @user.admin_editor?
    false
  end

  def destroy?
    return true if @user.admin_editor?
    false
  end
end
