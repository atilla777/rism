class IndicatorPolicy < ApplicationPolicy

  def permitted_attributes
    [
      :investigation_id,
      :content,
      :indicators_list,
      {indicator_context_ids: []},
      :content_format,
      :content_subkinds,
      :description,
      :purpose,
      {custom_fields: Indicator.custom_fields_names},
      :trust_level
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
        scope.includes(:investigation)
             .where(investigation: {organization_id: user.allowed_organizations_ids})
      end
    end
  end
end
