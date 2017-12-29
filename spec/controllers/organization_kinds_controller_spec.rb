require 'rails_helper'

RSpec.describe OrganizationKindsController, type: :controller do
  context 'anonymous user' do
    it 'can`t view records' do
      get :index

      expect(response). to redirect_to(:sign_in)
    end
  end

  context 'admin user' do
    setup :activate_authlogic
    let(:user) { create(:user,
                        active: true) }
    let(:role) { create(:role, :admin) }
    let(:user_to_role) { create(:role_member,
                         role_id: role.id,
                         user_id: user.id) }
    before :each do
      user
      role
      user_to_role
      create_user_session(user)
    end
    it 'can view records' do
      get :index

      expect(response).to render_template(:index)
    end
  end
end
