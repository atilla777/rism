class TornadosApiPolicy
  attr_reader :user, :record

  def initialize(user, record = TornadosApi)
    @user = user
    @record = record
  end

  def show?
    return true if @user.admin_editor?
    @user.can? :read, 'TornadosApi'
  end
end
