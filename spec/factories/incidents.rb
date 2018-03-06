FactoryBot.define do
  factory :incident do
    discovery_date "2018-03-06 09:17:12"
    start_date "2018-03-06 09:17:12"
    end_date "2018-03-06 09:17:12"
    close_date "2018-03-06 09:17:12"
    sequence(:event_description) { |n| "Event description #{n}" }
    investigation_description "MyText"
    action_description "MyText"
    severity 0
    damage 0
    state 0
  end
end
