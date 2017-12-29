FactoryBot.define do
  factory :attachment do
    sequence(:name) { | n | "Attachment#{n}" }
    organization
    document File.open(File.join(Rails.root, '/spec/files/test.txt'))
  end
end
