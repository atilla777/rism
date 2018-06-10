class SchedulePolicy < ApplicationPolicy
  def permitted_attributes
      %i[minutes
         hours
         week_days
         month
         month_days]
  end

  def show?
    return true if @user.admin_editor_reader?
    return true if @user.can? :read, @record
    return true if @user.can? :read, @record.contractor
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
        ids = user.allowed_organizations_ids
        scope.joins(:job)
             .where(job: {organization_id: ids})
      end
    end
  end
end
