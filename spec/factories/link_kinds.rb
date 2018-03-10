FactoryBot.define do
  factory :link_kind do
    sequence(:name) { |n| "LinkKind#{n}" }
    sequence(:code_name) { |n| "C#{n}" }
    rank 1
    record_type 'Incident'
    equal false
  end
end
