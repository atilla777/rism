FactoryBot.define do
  factory :attachment do
    sequence(:name) { | n | "Attachment#{n}" }
    sequence(:document) { | n | "Document#{n}" }
    organization
  end
end
