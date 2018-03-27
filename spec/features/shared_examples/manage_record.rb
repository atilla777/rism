# frozen_string_literal: true

RSpec.shared_examples 'manage record' do
  given(:records) do
    create_list(resource, 3)
  end

  context 'when anonymous' do
    it_behaves_like 'anonymous in browser'
  end

  describe 'role members' do
    background { login(user) }

    after { logout }

    context 'when global editor' do
      let(:user) { create :user, :skip_validation, active: true }
      let(:role) { create :role, :editor }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read in browser'

      it_behaves_like 'authorized to edit in browser'
    end

    context 'when ordinar reader' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :read,
          allowed_models: ['Organization', resource_class.name]
        )
      end

      it_behaves_like 'authorized to read in browser'

      it_behaves_like 'unauthorized to edit in browser'
    end
  end
end
