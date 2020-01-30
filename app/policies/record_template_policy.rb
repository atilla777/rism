class RecordTemplatePolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[
      name
      record_content
      description
      record_type
      current_user
      sharing_option
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
        # TODO: check code bellow
        sql = <<~SQL
          user_id = ? OR
          organization_id = ? OR
          (user_id IS NULL AND organization_id IS NULL)
        SQL
        scope.where(sql, user.id, user.organization_id)
      end
    end
  end
end
