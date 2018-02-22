FactoryBot.define do
  factory :tag_kind do
    sequence(:name) { |n| "Name#{n}" }
    sequence(:code_name) { |n| "Code#{n}" }
    description "MyText"
  end
end
