class InvestigationPolicy < ApplicationPolicy
  def permitted_attributes
    %i[name
       organization_id
       user_id
       feed_id
       threat
       description]
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
