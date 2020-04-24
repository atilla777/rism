class SchedulePolicy < ApplicationPolicy
  def permitted_attributes
      %i[minutes
         hours
         week_days
         months
         month_days]
  end

  def run?
    user.admin_editor?
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
        # TODO: make it work not only for scan job (add custom report)
        ids = user.allowed_organizations_ids(scope)
        scope.joins(:scan_job)
             .where(scan_jobs: {organization_id: ids})
      end
    end
  end
end
