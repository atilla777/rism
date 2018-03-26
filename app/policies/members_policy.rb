module MembersPolicy
# TODO: user or delete
#  def show?
#    return true if @user.admin_editor_reader?
#    @user.can? :read, @record.class
#  end
#
#  def create?
#    return true if @user.admin_editor?
#    @user.can? :edit, @record.class
#  end
#
#  def update?
#    create?
#  end
#
#  def destroy?
#    return true if @user.admin_editor?
#    create?
#  end
end
