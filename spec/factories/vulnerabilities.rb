FactoryBot.define do
  factory :vulnerability do
    codename "MyString"
    vendors "MyText"
    products "MyText"
    versions "MyText"
    cvss3 "MyString"
    cvss3_vector "MyString"
    references "MyText"
    feed 1
    feed_description "MyString"
    description "MyString"
    published "2019-05-18"
  end
end
