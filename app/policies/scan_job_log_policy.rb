class ScanJobLogPolicy < ApplicationPolicy

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
             .where(scan_jobs: {organization_id: user.allowed_organizations_ids})
      end
    end
  end
end