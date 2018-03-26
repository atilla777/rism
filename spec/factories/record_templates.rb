FactoryBot.define do
  factory :record_template do
    sequence(:name) { |n| "Template#{n}" }
    attributes({name: 'Name'})
    record_content({name: 'Name'})
    record_type 'Incident'
    description 'MyText'
  end
end
