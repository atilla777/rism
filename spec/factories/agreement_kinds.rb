FactoryBot.define do
  factory :agreement_kind do
    sequence(:name) { |n| "Name#{n}"}
    description "MyText"
  end
end
