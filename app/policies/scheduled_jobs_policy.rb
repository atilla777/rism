class ScheduledJobsPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    return true if @user.admin_editor_reader?
    @user.can? :read, ScanJob
  end

  def destroy?
    return true if @user.admin_editor?
    @user.can? :edit, ScanJob
  end

  def destroy_all?
    return true if @user.admin_editor?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin_editor_reader?
        scope
      elsif user.can_read_model_index?(ScanJob)
        scope
      else
        allowed_jobs
      end
    end

    def allowed_jobs
      organization_ids = user.allowed_organizations_ids('ScanJob')
      scope.select do |job|
        scan_job = ScanJob.find(job.args[0]['arguments'][0])
        organization_ids.include?(scan_job.organization_id)
      end
    end
  end
end
