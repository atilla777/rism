FactoryBot.define do
  factory :organization do
    sequence(:name) { | n | "Organizaion#{n}" }
    sequence(:full_name) { | n | "Organizaion#{n} full name" }
    parent_id nil
    organization_kind
    description "MyText"
  end
end
