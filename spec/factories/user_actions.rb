FactoryBot.define do
  factory :user_action do
    user nil
    controller "MyString"
    action "MyString"
    params ""
    ip ""
    browser "MyString"
    comment "MyText"
  end
end
