FactoryBot.define do
  factory :indicator do
    user
    investigation
    content_format 0
    content "MyString"
    trust_level "MyString"
  end
end
