FactoryBot.define do
  factory :right do
    association :role, factory: [:role, :custom_role]
    organization
    subject { | a | a.association(:organization) }
    level 3
    trait(:manage) { level 1 }
    trait(:edit) { level 2 }
    trait(:read) { level 3 }
  end
end
