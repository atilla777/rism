module Authlogic
  module TestHelper
    def create_user_session(user)
      UserSession.create!(user)
    end

    def login(options)
      create(:user, options)
      visit sign_in_path
      fill_in 'email', with: user.email
      fill_in I18n.t('user_sessions.password'), with: 'password'
      click_button I18n.t('user_sessions.sign_in')
    end

    def logout
      click_on I18n.t('user_sessions.sign_out')
    end
  end
end

RSpec.configure do | config |
  require 'authlogic/test_case'
  config.include Authlogic::TestCase
  config.include Authlogic::TestHelper, type: :controller
end
