FactoryBot.define do
  factory :scan_job do
    sequence(:name) { |n| "Name#{n}" }
    organization
    scan_option
    hosts "MyString"
    ports "MyString"
    description "MyText"
  end
end
