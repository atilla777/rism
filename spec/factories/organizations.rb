FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization#{n}" }
    sequence(:full_name) { |n|  "Organization#{n} full name" }
    sequence(:codename) { |n| "CODE_#{n}" }
    parent_id nil
    organization_kind
    description "MyText"
  end
end
