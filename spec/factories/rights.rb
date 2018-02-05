FactoryBot.define do
  factory :right do
    association :role, factory: [:role, :custom_role]
    organization
    subject_type 'Organization'
    subject_id nil
    level 3
    trait(:manage) { level 1 }
    trait(:edit) { level 2 }
    trait(:read) { level 3 }
  end
end
