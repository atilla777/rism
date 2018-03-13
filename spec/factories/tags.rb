FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }
    rank 1
    tag_kind
    color '#69e814'
    description "MyText"
  end
end
