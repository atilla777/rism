# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationKindsController, type: :controller do
  let(:model) { OrganizationKind }
  let(:record) { create :organization_kind }
  let(:another_record) { create :organization_kind }
  let(:all_records) { model.all }
  let(:new_record) do
    post :create,
         params: { organization_kind: attributes_for(:organization_kind) }
  end
  let(:update_record) do
    put :update,
         params: {  id: record.id, organization_kind: { name: 'Updated!' } }
  end
  let(:sacrifice_record) { create :organization_kind }
  let(:delete_record) do
    delete :destroy, params: { id: sacrifice_record.id }
  end

  context 'when anonymous user' do
    it_behaves_like 'an anonymous'
  end

  context 'when global role memebers' do
    let(:user) { create :user, active: true }
    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    context 'when admin' do
      let(:role) { create :role, :admin }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'authorized to edit'
    end

    context 'when editor' do
      let(:role) { create :role, :editor }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'authorized to edit'
    end

    context 'when reader' do
      let(:role) { create:role, :reader }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'unauthorized to edit'
    end
  end

  context 'when ordinar user with at least read privileges' do
    let(:user) do
      create(
        :user_with_right,
        allowed_action: :manage,
        allowed_models: %w[OrganizationKind]
      )
    end
    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    it_behaves_like 'authorized to read'
    it_behaves_like 'unauthorized to edit'
  end
end
