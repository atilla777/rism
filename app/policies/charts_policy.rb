class ChartsPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    return true if @user.admin_editor_reader?
    @user.can? :read, 'Charts'
  end
end
