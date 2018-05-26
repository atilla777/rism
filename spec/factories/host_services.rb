FactoryBot.define do
  factory :host_service do
    sequence(:name) { |n| "MyPort#{n}" }
    organization nil
    host nil
    port 80
    protocol 'tcp'
    legality 0
    description "MyText"
  end
end
