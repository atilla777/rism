# frozen_string_literal: true

RSpec.shared_examples 'manage organization record' do
  given(:organization) { create :organization }
  given(:not_allowed_organization) { create(:organization) }
  given(:records) do
    create_list(resource, 3, organization_id: organization.id)
  end
  given(:not_allowed_record) do
    create(resource, organization_id: not_allowed_organization.id)
  end

  context 'when anonymous' do
    it_behaves_like 'feature anonymous'
  end

  describe 'role members' do
    background { login(user) }

    after { logout }

    context 'when reader' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :read,
          allowed_organization_id: organization.id,
          allowed_models: ['Organization', resource_class.name]
        )
      end

      it_behaves_like 'feature authorized to read'

      it_behaves_like 'feature unauthorized to edit'

      it_behaves_like 'feature unauthorized access not allowed'
    end

    context 'when editor' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :edit,
          allowed_organization_id: organization.id,
          allowed_models: ['Organization', resource_class.name]
        )
      end

      it_behaves_like 'feature authorized to read'

      it_behaves_like 'feature authorized to edit'

      it_behaves_like 'feature unauthorized access not allowed'
    end
  end
end
