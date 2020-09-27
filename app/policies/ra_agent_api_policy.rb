class RaAgentApiPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    return true if @user.admin_editor?
    @user.can? :edit, 'RaAgentApi'
  end
end
