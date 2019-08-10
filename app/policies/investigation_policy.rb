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

#    t.bigint "user_id"
#    t.bigint "investigation_id"
#    t.integer "ioc_kind"
#    t.integer "trust_level"
#    t.string "content"
#    t.jsonb "enrichment", default: "{}", null: false

  def run?
    create?
  end
end
