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

  def enrich?
    create?
  end

  def clone?
    index?
  end

  def toggle_readable?
    index?
  end

  def publicate?
    create?
  end

  def toggle_subscription?
    index?
  end

  def investigations_dashboard?
    index?
  end
end
