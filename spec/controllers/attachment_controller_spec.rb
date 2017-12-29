require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  setup :activate_authlogic
  let(:organization) { create(:organization) }
  let(:not_allowed_organization) { create(:organization) }
  let(:attachment) { create(:attachment,
                            organization_id: organization.id) }
  let(:not_allowed_attachment) { create(:attachment,
                                        organization_id: not_allowed_organization.id) }

  context 'anonumous user' do
    it 'can`t get attachment' do
      get :download, params: { id: attachment.id }

      expect(response). to redirect_to(:sign_in)
    end
  end

  context 'not anonumous users' do
    before :each do
      create_user_session(user)
      allow(controller).to receive(:send_data) { controller.render nothing: true }
    end

    context 'admin user' do
      let!(:user) { create(:user,
                          active: true) }
      let!(:role) { create(:role, :admin) }
      let!(:user_to_role) { create(:role_member,
                           role_id: role.id,
                           user_id: user.id) }
      before :each do
        create_user_session(user)
      end

      it 'can download attachment' do
        get :download, params: { id: attachment.id }

        expect(response.body).to eq("file\n")
      end
    end

    context 'reader' do
      let!(:user) { create(:user_with_right,
                            allowed_action: :read,
                            allowed_organization_id: organization.id,
                            allowed_models: ['Organization',
                                             'Attachment']) }

      it 'can download allowed attachment' do
        get :download, params: { id: attachment.id }

        expect(response.body).to eq("file\n")
      end

      it 'can`t download not allowed attachment' do
        get :download, params: { id: not_allowed_attachment.id }

        expect(response.body).not_to eq("file\n")
      end
    end
  end
end
