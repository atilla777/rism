# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:model) { Organization }
  let(:record) { create :organization }
  let(:new_record) do
    post :create,
         params: {
           organization: attributes_for(:organization)
           .merge(organization_kind_id: create(:organization_kind).id)
    }
  end
  let(:update_record) do
    put :update,
         params: { id: record.id, organization: { name: 'Updated!' } }
  end
  let(:sacrifice_record) { create :organization, parent_id: record.id }
  let(:delete_record) do
    delete :destroy, params: { id: sacrifice_record.id }
  end

  before do
    create :organization
  end

  context 'when anonymos user' do
    it_behaves_like 'an anonymous'
  end

  context 'when global role memebers' do
    let(:user) { create :user, active: true }
    let(:all_records) { model.all }
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

  context 'when ordinar user is a record manager' do
    let(:user) do
      create(
        :user_with_right,
        allowed_organization_id: record.id,
        allowed_action: :manage,
        allowed_models: %w[Organization]
      )
    end
    let(:all_records) do
      model.where(id: record.id).first
    end
    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    it_behaves_like 'authorized to read'
    it_behaves_like 'authorized to edit'
  end
end

