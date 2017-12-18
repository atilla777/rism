FactoryBot.define do
  factory :organization do
    sequence(:name) { | n | "Organizaion#{n}" }
    sequence(:full_name) { | n | "Organizaion#{n} full name" }
    parent_id nil
    kind 0
  end
end
