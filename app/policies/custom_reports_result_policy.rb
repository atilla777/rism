class CustomReportsResultPolicy < ApplicationPolicy

  def permitted_attributes
    %i[
      custom_report_id
      result_path
    ]
  end

  def run?
    edit?
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
        scope.joins(:custom_report)
          .merge(
            CustomReport.where(
              organization_id: user.allowed_organizations_ids('CustomReport')
            )
          )
      end
    end
  end
end
