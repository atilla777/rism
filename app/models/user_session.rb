class UserSession < Authlogic::Session::Base
  UserSession.last_request_at_threshold = 10.minutes
end
