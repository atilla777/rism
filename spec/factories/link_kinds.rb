FactoryBot.define do
  factory :link_kind do
    sequence(:name) { |n| "LinkKind#{n}" }
    sequence(:code_name) { |n| "C#{n}" }
    rank 1
    first_record_type 'Organization'
    second_record_type 'Incident'
    equal false
    color '#69e814'
    description 'Description'
  end
end
