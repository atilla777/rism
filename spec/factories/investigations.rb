FactoryBot.define do
  factory :investigation do
    name "MyName"
    user
    organization
    feed
    description "MyText"
    threat 0
  end
end
