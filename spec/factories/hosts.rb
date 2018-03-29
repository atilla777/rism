FactoryBot.define do
  factory :host do
    sequence(:name) { |n| "MyIP#{n}" }
    organization
    sequence(:ip) { |n| "10.0.0.#{n}" }
    description 'MyIP'
  end
end
