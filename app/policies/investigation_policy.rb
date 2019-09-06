class InvestigationPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :name,
      :enrich,
      :custom_codename,
      :feed_codename,
      :organization_id,
      :feed_id,
      :investigation_kind_id,
      :indicators_list,
      {custom_fields: Investigation.custom_fields_names},
      :description
    ]
  end

  def run?
    create?
  end

  def tree_show?
    index?
  end

  def enrich?
    create?
  end

  def set_readable?
    index?
  end
end
