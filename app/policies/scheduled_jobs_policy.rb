class ScheduledJobsPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    return true if @user.admin?
  end

  def destroy?
    return true if @user.admin?
  end
end
