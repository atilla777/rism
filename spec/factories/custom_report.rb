FactoryBot.define do
  factory :custom_report do
    custom_report_folder nil
    organization nil
    user nil
    name "MyString"
    description "MyText"
    statement "MyText"
    variables ""
    result_format "MyString"
  end
end
