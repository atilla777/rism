class InvestigationPolicy < ApplicationPolicy
  def permitted_attributes
    [:name,
      :custom_codename,
      :feed_codename,
      :organization_id,
      :feed_id,
      :investigation_kind_id,
      :indicators_list,
      {custom_fields: Investigation.custom_fields_names},
     :description]
  end

  def run?
    create?
  end
end
