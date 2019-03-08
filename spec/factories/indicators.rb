FactoryBot.define do
  factory :indicator do
    user
    investigation
    ioc_kind 0
    content "MyString"
    trust_level "MyString"
  end
end
