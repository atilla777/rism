FactoryBot.define do
  factory :role_member do
    association :user, :skip_validation
    role
  end
end
