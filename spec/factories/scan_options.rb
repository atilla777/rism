FactoryBot.define do
  factory :scan_option do
    sequence(:name) { |n| "Name#{n}" }
    options {}
    description "MyText"
  end
end
