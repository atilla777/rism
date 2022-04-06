FactoryBot.define do
  factory :comment do
    commentable nil
    user nil
    content "MyText"
    parent nil
  end
end
