# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  setup :activate_authlogic
  let(:organization) { create(:organization) }
  let(:not_allowed_organization) { create(:organization) }
  let(:attachment) do
    create(:attachment, organization_id: organization.id)
  end
  let(:not_allowed_attachment) do
    create(:attachment, organization_id: not_allowed_organization.id)
  end

  context 'when anonumous user' do
    it 'can`t get attachment' do
      get :download, params: { id: attachment.id }

      expect(response). to redirect_to(:sign_in)
    end
  end

  context 'when built in role member' do
    let(:user) { create(:user, :skip_validation, active: true) }

    before do
      create_user_session(user)
      allow(controller).to(receive(:send_data)) do
        controller.render nothing: true
      end
    end

    shared_examples 'a built in role member' do
      it 'can download any attachment' do
        get :download, params: { id: attachment.id }

        expect(response.body).to eq("file\n")

        get :download, params: { id: not_allowed_attachment.id }

        expect(response.body).to eq("file\n")
      end
    end

    context 'when admin' do
      let(:role) { create(:role, :admin) }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'a built in role member'
    end

    context 'when editor' do
      let(:role) { create(:role, :editor) }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'a built in role member'
    end

    context 'when reader' do
      let(:role) { create(:role, :reader) }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'a built in role member'
    end
  end

  context 'when ordinary user' do
    before do
      create_user_session(user)
      allow(controller).to(receive(:send_data)) do
        controller.render nothing: true
      end
    end

    shared_examples 'an ordinary authorized user' do
      it 'can download allowed attachment' do
        get :download, params: { id: attachment.id }

        expect(response.body).to eq("file\n")
      end

      it 'can`t download not allowed attachment' do
        get :download, params: { id: not_allowed_attachment.id }

        expect(response.body).not_to eq("file\n")
      end
    end

    context 'when organization admin' do
      let(:user) do
        create(
          :user_with_right,
          allowed_action: :manage,
          allowed_organization_id: organization.id,
          allowed_models: %w[Organization Attachment]
        )
      end

      it_behaves_like 'an ordinary authorized user'
    end

    context 'when organization admin' do
      let(:user) do
        create(
          :user_with_right,
          allowed_action: :edit,
          allowed_organization_id: organization.id,
          allowed_models: %w[Organization Attachment]
        )
      end

      it_behaves_like 'an ordinary authorized user'
    end

    context 'when organization reader' do
      let(:user) do
        create(
          :user_with_right,
          allowed_action: :read,
          allowed_organization_id: organization.id,
          allowed_models: %w[Organization Attachment]
        )
      end

      it_behaves_like 'an ordinary authorized user'
    end
  end
end
