FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }
    rank 1
    tag_kind
    description "MyText"
  end
end
