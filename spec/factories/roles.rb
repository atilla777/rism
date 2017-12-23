FactoryBot.define do
  factory :role do
    sequence(:name) { | n | "Role#{n}" }
    description 'Descritpion'
  end
end
