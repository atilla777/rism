FactoryBot.define do
  factory :search_filter do
    name "MyString"
    user nil
    shared false
    rank 1
    content "MyText"
  end
end
