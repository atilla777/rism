FactoryBot.define do
  factory :record_template do
    sequence(:name) { |n| "Template#{n}" }
    record_content ''
    record_tags ''
    record_type 'Incident'
    description 'MyText'
  end
end
