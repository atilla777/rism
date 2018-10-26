class ScanJobsHostPolicy < ApplicationPolicy
  def permitted_attributes
    %i[scan_job_id
       host_id]
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
