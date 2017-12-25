FactoryBot.define do
  factory :user do
    sequence(:name) { | n | "User#{n}" }
    sequence(:email) { | n | "User#{n}@domain.io" }
    department_id nil
    department_name 'Department'
    rank 001
    organization
    active true
    trait(:active) { active true }
    password 'password'
    password_confirmation 'password'
    description "MyText"
    transient { role false }
    transient { allowed_organization_id nil }
    transient { allowed_model 'Organization' }
    after(:create) do | user, evaluator |
      if evaluator.role.present?
        role = create(:role,
                      id: 5)
        create(:role_member,
               user_id: user.id,
               role_id: role.id)
        case evaluator.role
        when :manager
          level = 1
        when :editor
          level = 2
        when :reader
          level = 3
        end
        create(:right,
               organization_id: evaluator.allowed_organization_id,
               role_id: role.id,
               subject_type: evaluator.allowed_model,
               level: level)
      end
    end
  end
end
