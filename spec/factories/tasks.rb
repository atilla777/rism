FactoryBot.define do
  factory :task do
    name "MyString"
    description "MyString"
    srart_date "2022-03-26"
    planned_end "2022-03-26"
    real_end "2022-03-26"
    creator nil
    updater nil
    user nil
    organization nil
  end
end
