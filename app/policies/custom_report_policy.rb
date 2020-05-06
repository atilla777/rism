class CustomReportPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         organization_id
         folder_id
         content
         description
         statement
         add_csv_header
         utf_encoding
         result_format
      ]
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
        scope.where(
          organization_id: user.allowed_organizations_ids(scope, :edit)
        ).or(scope.where(
          organization_id: user.allowed_organizations_ids(scope)
        ))
      end
    end
  end
end
