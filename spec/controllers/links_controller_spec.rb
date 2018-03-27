# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'global role member' do
    let(:user) { create :user, :skip_validation, active: true }

#    let(:user) {
#      user = User.new(attributes_for :user)
#      user.save(validate: false)
#      user
#    }
    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    context 'when admin' do
      let(:role) { create :role, :admin }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it 'jast work' do

      end
    end
  end


  context 'when not global role member with read privileges' do
    let(:user) do
      create(
        :user_with_right,
        allowed_action: :read,
        allowed_models: ['Link']
      )
    end

    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    it 'jast work to' do

    end
  end
end
