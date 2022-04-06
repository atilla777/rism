FactoryBot.define do
  factory :task_priorities do
    sequence(:name) { |n| "MyName#{n}" }
    sequence(:priority) { |n| "MyPriority#{n}" }
    sequence(:rank) { |n| n }
  end
end
