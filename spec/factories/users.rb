FactoryBot.define do
  factory :user do
    trait :skip_validation do
      to_create { |instance| instance.save(validate: false) }
    end
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "User#{n}@domain.io" }
    department_id nil
    department_name 'Department'
    sequence(:rank) { |n| n }
    organization
    active true
    password 'Pa$$w0rd'
    password_confirmation 'Pa$$w0rd'
    sequence(:description) { |n| "User#{n} description" }
    factory :user_with_right do
      to_create { |instance| instance.save(validate: false) }
      transient { allowed_action :read}
      transient { allowed_organization_id nil }
      transient { allowed_models ['Organization'] }
      after(:create) do | user, evaluator |
        role = create(:role,
                      id: 5)
        create(:role_member,
               user_id: user.id,
               role_id: role.id)
        level = Right.action_to_level(evaluator.allowed_action)
        evaluator.allowed_models.each do |model|
          create(:right,
                 organization_id: evaluator.allowed_organization_id,
                 role_id: role.id,
                 subject_type: model,
                 level: level)
        end
      end
    end
  end
end
