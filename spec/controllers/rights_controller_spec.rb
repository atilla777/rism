# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RightsController, type: :controller do
  let(:model_class) { Right }
  let(:all_records) { Right.all }
  let(:organization) { create :organization }
  let(:right_role) { create(:role, :custom_role) }
  let(:record) do
    create(
      :right,
      :edit,
      role_id: right_role.id,
      organization_id: organization.id
    )
  end
  let(:new_params) {{}}
  let(:new_record) do
    post(
      :create,
      params: {
        right: attributes_for(
          :right,
          :read,
          role_id: right_role.id,
          organization_id: organization.id
        )
      }
    )
  end
  let(:update_record) do
    put(
      :update,
      params: {
        id: record.id,
        right: attributes_for(
          :right,
          :read,
          role_id: right_role.id,
          organization_id: organization.id
        )
      }
    )
  end
  let(:delete_record) do
    delete :destroy, params: { id: record.id }
  end

  context 'when anonymous user' do
    it_behaves_like 'an anonymous'
  end

  describe 'global role member' do
    let(:user) { create :user, :skip_validation,  active: true }

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

      it_behaves_like 'unauthorized to read'
      it_behaves_like 'unauthorized to edit'
    end

    context 'when reader' do
      let(:role) { create :role, :reader }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'unauthorized to read'
      it_behaves_like 'unauthorized to edit'
    end
  end

  context 'when not global role member with some privileges' do
    let(:user) do
      create(
        :user_with_right,
        allowed_action: :manage,
        allowed_models: [Organization]
      )
    end

    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    it_behaves_like 'unauthorized to read'
    it_behaves_like 'unauthorized to edit'
  end
end
