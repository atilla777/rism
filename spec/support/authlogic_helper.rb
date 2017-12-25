module Authlogic
  module TestHelper
    def create_user_session(user)
      UserSession.create!(user)
    end
  end
end

RSpec.configure do | config |
  config.include Authlogic::TestCase
  config.include Authlogic::TestHelper, type: :controller
end
