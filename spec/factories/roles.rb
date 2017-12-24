FactoryBot.define do
  factory :role do
    trait(:admin) { id 1 }
    trait(:editor) { id 2 }
    trait(:reader) { id 3 }
    trait(:custom_role) { id 4 }
    sequence(:name) { | n | "Role#{n}" }
    description 'Descritpion'
  end
end
