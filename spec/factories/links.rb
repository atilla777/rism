FactoryBot.define do
  factory :link do
    association :first_record, fabrica: :incident
    association :second_record, fabrica: :organization
    link_kind
    description "Link description"
  end
end
