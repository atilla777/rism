FactoryBot.define do
  factory :incident do
    sequence(:name) { |n| "Incident#{n}" }
    discovered_at "2018-03-06 09:17:12"
    started_at "2018-03-06 09:17:12"
    finished_at "2018-03-06 09:17:12"
    closed_at "2018-03-06 09:17:12"
    sequence(:event_description) { |n| "Event description #{n}" }
    investigation_description "MyText"
    action_description "MyText"
    severity 0
    damage 0
    state 0
    organization
    association :user, :skip_validation
  end
end
