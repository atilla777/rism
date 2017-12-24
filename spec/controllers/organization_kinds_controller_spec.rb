require 'rails_helper'

RSpec.describe OrganizationKindsController, type: :controller do
  context 'anonymous user' do
    it 'can`t view records' do
      get :index

      expect(response). to redirect_to(:sign_in)
    end
  end
end
