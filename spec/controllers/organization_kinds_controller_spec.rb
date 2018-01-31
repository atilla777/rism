# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationKindsController, type: :controller do
  let(:model) { OrganizationKind }
  let(:record) { create(:organization_kind) }
  let(:new_record) do
    post :create,
         params: { organization_kind: attributes_for(:organization_kind) }
  end
  let(:update_record) do
    put :update,
         params: {  id: record.id, organization_kind: { name: 'Updated!' } }
  end
  let(:sacrifice_record) { create(:organization_kind) }
  let(:delete_record) do
    delete :destroy, params: { id: sacrifice_record.id }
  end

  context 'when anonymous user' do
    let (:record) { create(:organization_kind) }
    it_behaves_like 'an anonymous'
  end

  context 'when built in users' do
    setup :activate_authlogic
    let(:user) { create(:user, active: true) }

    before do
      create_user_session(user)
    end

    context 'when global admin role member' do
      let(:role) { create(:role, :admin) }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'an admin'
    end

    context 'when global editor role member' do
      let(:role) { create(:role, :editor) }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'an admin'
    end

    context 'when global reader role member' do
      let(:role) { create(:role, :reader) }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'a reader'
    end

#    context 'when reader' do
#      let(:role) { create(:role, :reader) }
#
#      before do
#        create(:role_member, role_id: role.id, user_id: user.id)
#      end
#
#      it_behaves_like 'a built in role member'
#    end
  end
end
