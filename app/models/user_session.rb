class UserSession < Authlogic::Session::Base
  UserSession.last_request_at_threshold = 10.minutes
  UserSession.consecutive_failed_logins_limit = 5
  UserSession.failed_login_ban_for = 10.minutes
end
