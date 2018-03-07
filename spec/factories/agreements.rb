FactoryBot.define do
  factory :agreement do
    beginning Date.current
    sequence(:prop) { |n| "Prop#{n}" }
    agreement_kind
    organization
    association :contractor, factory: :organization
  end
end
