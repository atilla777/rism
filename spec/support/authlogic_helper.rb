# frozen_string_literal: true

module Authlogic
  module TestHelper
    def create_user_session(user)
      UserSession.create!(user)
    end

    def login(user)
      visit sign_in_path
      fill_in 'user_session_email', with: user.email
      fill_in 'user_session_password', with: 'Pa$$w0rd'
      find('input[name="commit"]').click
    end

    def logout
      find('a[href="/sign_out"]').click
    end
  end
end

RSpec.configure do |config|
  require 'authlogic/test_case'
  config.include Authlogic::TestCase
  config.include Authlogic::TestHelper, type: :controller
  config.include Authlogic::TestHelper, type: :feature
  config.include Authlogic::TestHelper, type: :system
end
