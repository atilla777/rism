# Specific access check for record that not
# belongs to organization
module RecordPolicy
  def show?
    return true if @user.admin_editor_reader?
    @user.can? :read, @record
  end

  def create?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end
end
