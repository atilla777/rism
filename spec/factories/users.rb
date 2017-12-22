FactoryBot.define do
  factory :user do
    sequence(:name) { | n | "User#{n}" }
    sequence(:email) { | n | "User#{n}@domain.io" }
    department_id nil
    department_name 'Department'
    rank 001
    organization
    active false
    description "MyText"
  end
end
