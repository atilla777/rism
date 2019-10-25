class IndicatorPolicy < ApplicationPolicy

  def permitted_attributes
    [
      :investigation_id,
      :enrich,
      :content,
      :indicators_list,
      {indicator_context_ids: []},
      :content_format,
      :content_subkinds,
      :description,
      :purpose,
      {custom_fields: Indicator.custom_fields_names},
      :trust_level,
      :parent_id,
      :parent_conjunction
    ]
  end

  def select?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def reset?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

  def paste?
    return true if @user.admin_editor?
    @user.can? :edit, @record
  end

#  def set_readable?
#    index?
#  end

  def toggle_readable?
    index?
  end

  def enrich?
    create?
  end

  def enrichment?
    index?
  end

  def toggle_trust_level?
    create?
  end

  def toggle_purpose?
    create?
  end

  def tree_show?
    index?
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
        scope.joins(:investigation)
          .merge(
            Investigation.where(
              organization_id: user.allowed_organizations_ids('Investigation')
            )
          )
      end
    end
  end
end
