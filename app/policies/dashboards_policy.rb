class DashboardsPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    return true if @user.admin_editor_reader?
    @user.can? :read, 'Dashboards'
  end

  def show?
    index?
  end
end
