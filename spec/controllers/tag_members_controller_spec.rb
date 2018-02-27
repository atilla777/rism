# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagMembersController, type: :controller do
  let(:record_model) { Agreement }
  let(:organization) { create :organization }
  let(:not_allowed_organization) { create :organization }
  let(:record) { create record_model.name.downcase.to_sym, organization_id: organization.id }
  let(:not_allowed_record) do
    create record_model.name.downcase.to_sym, organization_id: not_allowed_organization.id
  end
  let(:tag) { create :tag }
  let(:tag_member) do
    create(:tag, record_id: record.id, record_type: record_model.to_s, tag_id: tag.id )
  end
  let(:add_tag) do
    post(
      :create,
      params: { record_id: record.id, record_type: record_model.to_s, tag_id: tag.id },
      xhr: true
    )
  end
  let(:delete_tag) do
    delete :destroy, params: { id: tag_member.id }, xhr: true
  end

  context 'when anonymos user' do
    it 'can`t add tag to record' do
      expect { add_tag }.to_not (change { TagMember.count }.by(1))
      expect(response).to redirect_to(:sign_in)
    end

    it 'can`t delete tag from record' do
      expect { delete_tag }.to_not (change { TagMember.count }.by(-1))
      expect(response).to redirect_to(:sign_in)
    end
  end

  describe 'global role member' do
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

      it 'can add tag to record' do
        expect { add_tag }.to(change { TagMember.count }.by(1))
        expect(response).to have_http_status(:success)
      end

      it 'can delete tag from record' do
        expect { delete_tag }.to (change { TagMember.count }.by(-1))
        expect(response).to have_http_status(:success)
      end
    end

#    context 'when editor' do
#      let(:role) { create :role, :editor }
#
#      before do
#        create(:role_member, role_id: role.id, user_id: user.id)
#      end
#
#    end
#
#    context 'when reader' do
#      let(:role) { create :role, :reader }
#
#      before do
#        create(:role_member, role_id: role.id, user_id: user.id)
#      end
#
#    end
#  end
#
#  describe 'not global role memeber' do
#    setup :activate_authlogic
#
#    before do
#      create_user_session(user)
#    end
#
#    context 'when manager' do
#      let(:user) do
#        create(
#          :user_with_right,
#          allowed_organization_id: organization.id,
#          allowed_action: :manage,
#          allowed_models: [record_model.to_s]
#        )
#      end
#
#    end
#
#    context 'when editor' do
#      let(:user) do
#        create(
#          :user_with_right,
#          allowed_organization_id: organization.id,
#          allowed_action: :edit,
#          allowed_models: [record_model.to_s]
#        )
#      end
#
#    end
#
#    context 'when reader' do
#      let(:user) do
#        create(
#          :user_with_right,
#          allowed_organization_id: organization.id,
#          allowed_action: :read,
#          allowed_models: [record_model.to_s]
#        )
#      end
#
#    end
#
#    context 'when not allowed organization reader' do
#      let(:user) do
#        create(
#          :user_with_right,
#          allowed_organization_id: not_allowed_organization.id,
#          allowed_action: :read,
#          allowed_models: [record_model.to_s]
#        )
#      end
#
#    end
  end
end
