class ScanJobLogPolicy < ApplicationPolicy
  def permitted_attributes
      %i[jid
         scan_job_id
         agent_id
         queue
         start
         finish]
  end

  def run?
    create?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin_editor_reader?
        scope.all
      elsif user.can_read_model_index?(scope)
        scope.all
      else
        scope.includes(:scan_job)
             .where(scan_jobs: {organization_id: user.allowed_organizations_ids(scope)})
      end
    end
  end
end
