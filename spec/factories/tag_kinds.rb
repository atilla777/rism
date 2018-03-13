FactoryBot.define do
  factory :tag_kind do
    sequence(:name) { |n| "Name#{n}" }
    sequence(:code_name) { |n| "Code#{n}" }
    record_type 'Organization'
    color '#69e814'
    description "MyText"
  end
end
