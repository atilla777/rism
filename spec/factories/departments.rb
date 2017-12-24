FactoryBot.define do
  factory :department do
    sequence(:name) { | n | "Department#{n}" }
    parent_id nil
    organization
    rank 1
  end
end
