FactoryBot.define do
  factory :agent do
    sequence(:name) { |n| "Agent#{n}" }
    address ""
    sequence(:hostname) do |n|
      "host#{n}"
    end
    port 1323
    protocol :http
    secret "secret"
    description "MyText"
    organization
  end
end
