# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:model_class) { Organization }
  let(:record) { create :organization }
  let(:not_allowed_record) do
    create(:organization, parent_id: create(:organization).id)
  end
  let(:new_params) {{}}
  let(:new_record) do
    post(
      :create,
      params: {
        organization: attributes_for(:organization)
        .merge(organization_kind_id: create(:organization_kind).id)
      }
    )
  end
  let(:update_record) do
    put :update,
        params: { id: record.id, organization: { name: 'Updated!' } }
  end
  let(:update_not_allowed_record) do
    put(
      :update,
      params: { id: not_allowed_record.id, organization: { name: 'Updated!' } }
    )
  end
  let(:delete_record) do
    delete :destroy, params: { id: record.id }
  end
  let(:delete_not_allowed_record) do
    delete :destroy, params: { id: not_allowed_record.id }
  end

  context 'when anonymos user' do
    it_behaves_like 'an anonymous'
  end

  describe 'global role memeber' do
    let(:user) { create :user, :skip_validation, active: true }
    let(:all_records) { model_class.all }

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
      let(:role) { create :role, :reader }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'unauthorized to edit'
    end
  end

  describe 'not global role memeber' do
    setup :activate_authlogic

    let(:all_records) do
      model_class.where(id: record.id).first
    end

    before do
      create_user_session(user)
    end

    context 'when manager' do
      let(:user) do
        create(
          :user_with_right,
          allowed_organization_id: record.id,
          allowed_action: :manage,
          allowed_models: [model_class.to_s]
        )
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'authorized to edit'
      it_behaves_like 'unauthorized to access not allowed'
    end

    context 'when editor' do
      let(:user) do
        create(
          :user_with_right,
          allowed_organization_id: record.id,
          allowed_action: :edit,
          allowed_models: [model_class.to_s]
        )
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'authorized to edit'
      it_behaves_like 'unauthorized to access not allowed'
    end

    context 'when reader' do
      let(:user) do
        create(
          :user_with_right,
          allowed_organization_id: record.id,
          allowed_action: :read,
          allowed_models: [model_class.to_s]
        )
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'unauthorized to edit'
      it_behaves_like 'unauthorized to access not allowed'
    end
  end
end
