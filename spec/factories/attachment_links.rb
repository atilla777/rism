FactoryBot.define do
  factory :attachment_link do
    record { | a | a.association(:agreement) }
    attachment
  end
end
