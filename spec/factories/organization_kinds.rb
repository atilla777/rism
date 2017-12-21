FactoryBot.define do
  factory :organization_kind do
    sequence(:name) { | n | "Name#{n}"}
    description "MyText"
  end
end
