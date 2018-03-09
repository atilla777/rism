FactoryBot.define do
  factory :link_kind do
    sequence(:name) { "LinkKind#{n}" }
    sequence(:code_name) { "C#{n}" }
    rank 1
    record_type 'Incident'
    equal false
  end
end
